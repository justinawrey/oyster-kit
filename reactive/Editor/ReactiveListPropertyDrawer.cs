using UnityEditor;
using UnityEngine;

namespace BlueOyster.Reactive.PropertyDrawers
{
    [CustomPropertyDrawer(typeof(ReactiveList<>))]
    public class ReactiveListPropertyDrawer : PropertyDrawer
    {
        private SerializedProperty GetValueProperty(SerializedProperty property) =>
            property.FindPropertyRelative("_internal");

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.PropertyField(
                position,
                GetValueProperty(property),
                new GUIContent(label.text + " [R]"),
                true
            );
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return EditorGUI.GetPropertyHeight(GetValueProperty(property));
        }
    }
}
