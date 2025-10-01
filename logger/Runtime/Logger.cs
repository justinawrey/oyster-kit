using System;
using UnityEngine;

namespace BlueOyster.Logger
{
    public enum LogLevel
    {
        None,
        Info,
        Verbose
    }

    [Serializable]
    public class Logger
    {
        public LogLevel EditorLogLevel = LogLevel.Info;
        public LogLevel BuildLogLevel = LogLevel.Verbose;
        public string Prefix = "";
        public Color Color = Color.green;

        private string GetLogLevelPrefix(LogLevel logLevel) =>
            logLevel switch
            {
                LogLevel.Info => "info",
                LogLevel.Verbose => "verbose",
                _ => ""
            };

        private string Now => DateTime.UtcNow.ToString("HH:mm:ss.ff");

        private void LogRaw(LogLevel logLevel, bool timestamp, object message)
        {
            string timestampStr = timestamp ? $"[{Now}] " : "";
            Debug.Log($"{timestampStr}({GetLogLevelPrefix(logLevel)}) {Prefix}: {message}");
        }

        private void LogRichText(LogLevel logLevel, bool timestamp, object message)
        {
            string colorHex = ColorUtility.ToHtmlStringRGBA(Color);
            string timestampStr = timestamp ? $"<b>{Now}</b> " : "";

            Debug.Log(
                $"{timestampStr}<b>({GetLogLevelPrefix(logLevel)})</b> <color=#{colorHex}><b>{Prefix}</b></color>: {message}"
            );
        }

        public void Info(object message)
        {
            if (Application.isEditor && EditorLogLevel != LogLevel.None)
            {
                LogRichText(LogLevel.Info, false, message);
                return;
            }

            if (!Application.isEditor && BuildLogLevel != LogLevel.None)
            {
                LogRaw(LogLevel.Info, true, message);
            }
        }

        public void Verbose(object message)
        {
            if (Application.isEditor && EditorLogLevel == LogLevel.Verbose)
            {
                LogRichText(LogLevel.Verbose, false, message);
                return;
            }

            if (!Application.isEditor && BuildLogLevel == LogLevel.Verbose)
            {
                LogRaw(LogLevel.Verbose, true, message);
            }
        }
    }
}
