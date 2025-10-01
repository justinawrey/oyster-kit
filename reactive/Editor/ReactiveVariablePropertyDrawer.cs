using System;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace BlueOyster.Reactive.PropertyDrawers
{
    [CustomPropertyDrawer(typeof(Reactive<>))]
    public class ReactiveVariablePropertyDrawer : PropertyDrawer
    {
        private SerializedProperty GetValueProperty(SerializedProperty property) =>
            property.FindPropertyRelative("_val");

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.BeginChangeCheck();
            EditorGUI.PropertyField(
                position,
                GetValueProperty(property),
                new GUIContent($"{label.text} [R]")
            );
            bool changed = EditorGUI.EndChangeCheck();

            if (changed)
            {
                property.serializedObject.ApplyModifiedProperties();
                ForceFlushCallbacks(property);
            }
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return EditorGUI.GetPropertyHeight(GetValueProperty(property));
        }

        // update live in editor looooool
        private void ForceFlushCallbacks(SerializedProperty property)
        {
            object targetObject = property.serializedObject.targetObject;
            string[] path = property.propertyPath.Split('.');

            // Traverse the object hierarchy to get the parent object
            for (int i = 0; i < path.Length - 1; i++)
            {
                string pathPart = path[i];
                // Handle array elements if needed
                if (pathPart == "Array" && path.Length > i + 1 && path[i + 1].StartsWith("data["))
                {
                    // Skip "Array" and process the array index
                    i++;
                    continue;
                }

                FieldInfo fieldInfo = targetObject.GetType().GetField(
                    pathPart,
                    BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Public
                );

                if (fieldInfo != null)
                {
                    targetObject = fieldInfo.GetValue(targetObject);
                    if (targetObject == null) return; // Exit if any parent in the chain is null
                }
            }

            // Get the final field info for the reactive variable
            string fieldName = path[path.Length - 1];
            FieldInfo finalFieldInfo = targetObject.GetType().GetField(
                fieldName,
                BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Public
            );

            if (finalFieldInfo == null) return;

            object fieldValue = finalFieldInfo.GetValue(targetObject);
            if (fieldValue == null) return;

            Type reactiveVarType = finalFieldInfo.FieldType;
            MethodInfo methodInfo = reactiveVarType.BaseType?.GetMethod(
                "ForceFlushCallbacks",
                BindingFlags.NonPublic | BindingFlags.Instance
            );
            methodInfo?.Invoke(fieldValue, null);
        }
    }
}
