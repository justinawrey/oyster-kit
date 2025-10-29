using UnityEditor;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    [CustomEditor(typeof(PulserMB))]
    public class PulserMBEditor : Editor
    {
        private PulserMB pulserTarget;

        private void OnEnable()
        {
            pulserTarget = (PulserMB)target;
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
                EditorGUILayout.HelpBox("Enter Play Mode to test the pulse animation.", MessageType.Info);
                GUI.enabled = false;
            }

            // Add test button
            if (GUILayout.Button("Test Pulse Animation"))
            {
                if (pulserTarget != null && Application.isPlaying)
                {
                    pulserTarget.Pulse();
                }
            }

            // Re-enable GUI
            GUI.enabled = true;
        }
    }
}
