using BlueOyster.Dweens;
using UnityEditor;
using UnityEngine;

[CustomPropertyDrawer(typeof(DweenWithDelay))]
public class DweenWithDelayDrawer : PropertyDrawer
{
    // Draw the property inside the given rect
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        // Using BeginProperty / EndProperty on the parent property means that
        // prefab override logic works on the entire property.
        // EditorGUI.BeginProperty(position, label, property);

        // EditorGUILayout.BeginHorizontal();
        var width = position.width / 3;
        var shrunkRect = new Rect(position.x, position.y, width, position.height);

        EditorGUI.PropertyField(
            shrunkRect,
            property.FindPropertyRelative("Dween"),
            GUIContent.none
        );

        var r = new Rect(
            position.x + shrunkRect.width,
            position.y,
            width,
            EditorGUIUtility.singleLineHeight
        );

        var origLabelWidth = EditorGUIUtility.labelWidth;
        EditorGUIUtility.labelWidth = 80;
        EditorGUI.PropertyField(r, property.FindPropertyRelative("RisingDelay"));

        var r2 = new Rect(
            position.x + shrunkRect.width + r.width,
            position.y,
            width,
            EditorGUIUtility.singleLineHeight
        );

        EditorGUI.PropertyField(r2, property.FindPropertyRelative("FallingDelay"));
        EditorGUIUtility.labelWidth = origLabelWidth;

        // EditorGUILayout.EndHorizontal();

        // Draw fields - pass GUIContent.none to each so they are drawn without labels
        // EditorGUI.PropertyField(
        //     amountRect,
        //     property.FindPropertyRelative("amount"),
        //     GUIContent.none
        // );
        // EditorGUI.PropertyField(unitRect, property.FindPropertyRelative("unit"), GUIContent.none);
        // EditorGUI.PropertyField(nameRect, property.FindPropertyRelative("name"), GUIContent.none);
        //
        // // Set indent back to what it was
        // EditorGUI.indentLevel = indent;

        // EditorGUI.EndProperty();
    }
}
