using UnityEditor;
using UnityEngine;

namespace ReactiveUnity.PropertyDrawers
{
    [CustomPropertyDrawer(typeof(Computed<>))]
    public class ComputedVariablePropertyDrawer : PropertyDrawer
    {
        private SerializedProperty GetValueProperty(SerializedProperty property) =>
            property.FindPropertyRelative("_val");

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.BeginDisabledGroup(true);
            EditorGUI.PropertyField(
                position,
                GetValueProperty(property),
                new GUIContent($"{label.text} [C]")
            );
            EditorGUI.EndDisabledGroup();
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return EditorGUI.GetPropertyHeight(GetValueProperty(property));
        }
    }
}
