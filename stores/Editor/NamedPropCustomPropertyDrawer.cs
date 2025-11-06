using UnityEditor;
using UnityEngine;

[CustomPropertyDrawer(typeof(NamedProp))]
public class NamedPropCustomPropertyDrawer : PropertyDrawer
{
    private SerializedProperty GetStoreProperty(SerializedProperty property) =>
        property.FindPropertyRelative("source");

    private SerializedProperty GetPropertyNameProperty(SerializedProperty property) =>
        property.FindPropertyRelative("propertyName");

    private float GetStorePropertyHeight(SerializedProperty property) =>
        EditorGUI.GetPropertyHeight(GetStoreProperty(property));

    private float GetPropertyNamePropertyHeight(SerializedProperty property) =>
        EditorGUI.GetPropertyHeight(GetPropertyNameProperty(property));

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        property.serializedObject.Update();
        EditorGUI.BeginChangeCheck();

        // Draw the label
        position = EditorGUI.PrefixLabel(position, label);

        // Calculate widths - 60% for store, 40% for property name
        float storeWidth = position.width * 0.6f;
        float nameWidth = position.width * 0.4f - 5f;

        // Draw store field
        Rect storeRect = new Rect(position.x, position.y, storeWidth, GetStorePropertyHeight(property));
        EditorGUI.PropertyField(storeRect, GetStoreProperty(property), GUIContent.none);

        // Draw property name field without label
        Rect nameRect = new Rect(
            position.x + storeWidth + 5f,
            position.y,
            nameWidth,
            GetPropertyNamePropertyHeight(property)
        );
        EditorGUI.PropertyField(nameRect, GetPropertyNameProperty(property), GUIContent.none);

        bool changed = EditorGUI.EndChangeCheck();

        if (changed)
        {
            property.serializedObject.ApplyModifiedProperties();
        }
    }

    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        return GetStorePropertyHeight(property) + EditorGUIUtility.standardVerticalSpacing;
    }

    private void DrawStoreProperties(SerializedProperty property)
    {
        // propertyNames.Clear();

        // var store = storeProperty.objectReferenceValue as Store;
        // var fields = store.GetType().GetFields(BindingFlags.Public | BindingFlags.Instance | BindingFlags.NonPublic);
        // foreach (var field in fields)
        // {
        //     if (field.GetCustomAttribute<RefPropAttribute>() != null)
        //     {
        //         propertyNames.Add(field.Name);
        //     }
        // }

        // if (propertyNames.Count > 0)
        // {
        //     selectedPropertyIndex = EditorGUILayout.Popup("Ref Prop", selectedPropertyIndex, propertyNames.ToArray());
        // }
    }
}

