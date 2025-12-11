using UnityEditor;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    [CustomEditor(typeof(BaseImpulse), true)]
    public class BaseImpulseEditor : Editor
    {
        private BaseImpulse baseImpulse;

        private void OnEnable()
        {
            baseImpulse = (BaseImpulse)target;
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
                EditorGUILayout.HelpBox("Enter Play Mode to test the impulse animation.", MessageType.Info);
                GUI.enabled = false;
            }

            // Add test button
            if (GUILayout.Button("Test Impulse Animation"))
            {
                if (baseImpulse != null && Application.isPlaying)
                {
                    baseImpulse.Trigger();
                }
            }

            // Re-enable GUI
            GUI.enabled = true;
        }
    }
}
