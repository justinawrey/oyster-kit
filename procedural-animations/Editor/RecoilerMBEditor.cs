using UnityEditor;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    [CustomEditor(typeof(RecoilerMB))]
    public class RecoilerMBEditor : Editor
    {
        private RecoilerMB recoilerTarget;

        private void OnEnable()
        {
            recoilerTarget = (RecoilerMB)target;
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
                EditorGUILayout.HelpBox("Enter Play Mode to test the recoil animation.", MessageType.Info);
                GUI.enabled = false;
            }

            // Add test button
            if (GUILayout.Button("Test Recoil Animation"))
            {
                if (recoilerTarget != null && Application.isPlaying)
                {
                    recoilerTarget.Recoil();
                }
            }

            // Re-enable GUI
            GUI.enabled = true;
        }
    }
}
