using UnityEditor;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    [CustomEditor(typeof(TorquerMB))]
    public class TorquerMBEditor : Editor
    {
        private TorquerMB torquerTarget;

        private void OnEnable()
        {
            torquerTarget = (TorquerMB)target;
        }

        public override void OnInspectorGUI()
        {
            // Draw the default inspector
            DrawDefaultInspector();

            // Add spacing
            EditorGUILayout.Space();

            // Check if we're in play mode
            if (!Application.isPlaying)
            {
                EditorGUILayout.HelpBox("Enter Play Mode to test the torque animation.", MessageType.Info);
                GUI.enabled = false;
            }

            // Add test button
            if (GUILayout.Button("Test Torque Animation"))
            {
                if (torquerTarget != null && Application.isPlaying)
                {
                    torquerTarget.Torque();
                }
            }

            // Re-enable GUI
            GUI.enabled = true;
        }
    }
}
