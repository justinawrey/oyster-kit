// using System;
// using BlueOyster.PixelPerfectUtils;
// using UnityEditor;
// using UnityEngine;

// [CustomEditor(typeof(SSCGrid))]
// public class SSCGridEditor : Editor
// {
//     private SerializedProperty showGridProperty;
//     private SSCGrid targ;

//     private void OnEnable()
//     {
//         showGridProperty = serializedObject.FindProperty("showGrid");
//         targ = (SSCGrid)target;
//     }

//     public override void OnInspectorGUI()
//     {
//         serializedObject.Update();
//         DrawPropertiesExcluding(serializedObject, "m_Script");
//         if (GUILayout.Button("Align Camera"))
//         {
//             AlignCamera();
//         }
//         serializedObject.ApplyModifiedProperties();
//     }

//     private void AlignCamera()
//     {
//         targ.AlignCamera();
//     }
// }