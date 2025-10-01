using UnityEditor;
using UnityEngine;

namespace StructuredLogger
{
    [CustomPropertyDrawer(typeof(StructuredLogger.Logger))]
    public class LoggerPropertyDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.LabelField(
                WithLineOffset(position, 0),
                "Logging Settings",
                EditorStyles.boldLabel
            );

            SerializedProperty editorLogLevel = property.FindPropertyRelative("EditorLogLevel");
            SerializedProperty buildLogLevel = property.FindPropertyRelative("BuildLogLevel");
            SerializedProperty prefix = property.FindPropertyRelative("Prefix");
            SerializedProperty color = property.FindPropertyRelative("Color");

            EditorGUI.PropertyField(WithLineOffset(position, 1), editorLogLevel);
            EditorGUI.PropertyField(WithLineOffset(position, 2), buildLogLevel);
            EditorGUI.PropertyField(WithLineOffset(position, 3), prefix);
            EditorGUI.PropertyField(WithLineOffset(position, 4), color);
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return (EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing)
                * 5;
        }

        private Rect WithLineOffset(Rect rect, int lines)
        {
            Rect r = new Rect(rect);
            r.y +=
                (EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing)
                * lines;
            r.height = EditorGUIUtility.singleLineHeight;
            return r;
        }
    }
}
