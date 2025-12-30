#if UNITY_EDITOR
using System.Net;
using System.Text;
using System.Threading;
using UnityEditor;
using UnityEditor.Compilation;
using UnityEngine;

[InitializeOnLoad]
static class NeovimUnityControlServer
{
    const string Prefix = "http://127.0.0.1:51789/";

    static HttpListener listener;
    static Thread listenerThread;

    static bool needsRefresh = false;
    static HttpListenerContext activeContext;

    static NeovimUnityControlServer()
    {
        Start();
        EditorApplication.update += MainThreadTick;
    }

    static void Start()
    {
        listener = new HttpListener();
        listener.Prefixes.Add(Prefix);
        listener.Start();

        listenerThread = new Thread(BackgroundThreadListen) { IsBackground = true };
        listenerThread.Start();

        Debug.Log($"[Neovim] Control server listening on {Prefix}");
    }

    static void BackgroundThreadListen()
    {
        // blocking
        activeContext = listener.GetContext();
        needsRefresh = true;
    }

    static void MainThreadTick()
    {
        if (!needsRefresh)
            return;

        Handle(activeContext);
    }

    static void Handle(HttpListenerContext ctx)
    {
        needsRefresh = false;
        try
        {
            if (ctx.Request.Url.AbsolutePath == "/recompile")
            {
                AssetDatabase.Refresh();
                EditorApplication.QueuePlayerLoopUpdate();
                CompilationPipeline.RequestScriptCompilation();
            }

            WriteResponse(ctx, "ok");
        }
        catch (System.Exception e)
        {
            WriteResponse(ctx, e.ToString(), 500);
        }
    }

    static void WriteResponse(HttpListenerContext ctx, string text, int status = 200)
    {
        var bytes = Encoding.UTF8.GetBytes(text);
        ctx.Response.StatusCode = status;
        ctx.Response.ContentLength64 = bytes.Length;
        ctx.Response.OutputStream.Write(bytes, 0, bytes.Length);
        ctx.Response.OutputStream.Close();
    }
}
#endif
