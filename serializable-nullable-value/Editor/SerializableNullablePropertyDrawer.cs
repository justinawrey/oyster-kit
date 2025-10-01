using UnityEditor;
using UnityEngine;

namespace SerializableNullable
{
    [CustomPropertyDrawer(typeof(SerializableNullable<>))]
    public class SerializableNullablePropertyDrawer : PropertyDrawer
    {
        private float _buttonWidth = 75;
        private float _spacing = 5;

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SerializedProperty valueProperty = property.FindPropertyRelative("_val");
            SerializedProperty hasValueProperty = property.FindPropertyRelative("_hasValue");

            Rect valueRect = new Rect(position);
            valueRect.width -= _buttonWidth + _spacing;

            Rect buttonRect = new Rect(valueRect);
            buttonRect.x += valueRect.width + _spacing;
            buttonRect.width = _buttonWidth;

            if (hasValueProperty.boolValue)
            {
                DrawValueGUI(valueRect, valueProperty, label);
                DrawButton(buttonRect, hasValueProperty);
                return;
            }

            DrawNullGUI(valueRect, label);
            DrawButton(buttonRect, hasValueProperty);
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return EditorGUIUtility.singleLineHeight;
        }

        private void DrawNullGUI(Rect valueRect, GUIContent label)
        {
            EditorGUI.LabelField(valueRect, new GUIContent($"{label.text} [NULL]"));
        }

        private void DrawValueGUI(
            Rect valueRect,
            SerializedProperty valueProperty,
            GUIContent label
        )
        {
            EditorGUI.PropertyField(valueRect, valueProperty, new GUIContent($"{label.text}"));
        }

        private void DrawButton(Rect buttonRect, SerializedProperty hasValueProperty)
        {
            string label = hasValueProperty.boolValue ? "Set To Null" : "Unset Null";
            if (GUI.Button(buttonRect, label))
            {
                hasValueProperty.boolValue = !hasValueProperty.boolValue;
            }
        }
    }
}
