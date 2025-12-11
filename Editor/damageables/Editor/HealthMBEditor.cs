using UnityEditor;
using UnityEngine;

namespace BlueOyster.Damageables
{
    [CustomEditor(typeof(HealthMB))]
    public class HealthMBEditor : Editor
    {
        // private SerializedProperty invulnerable;
        // private SerializedProperty maxHealthUncapped;
        // private SerializedProperty maxHealth;
        // private SerializedProperty initialHealth;
        private HealthMB healthMB;

        private void OnEnable()
        {
            // invulnerable = serializedObject.FindProperty("Invulnerable");
            // maxHealthUncapped = serializedObject.FindProperty("MaxHealthUncapped");
            // maxHealth = serializedObject.FindProperty("maxHealth");
            // initialHealth = serializedObject.FindProperty("initialHealth");
            healthMB = (HealthMB)target;
        }

        override public void OnInspectorGUI()
        {
            serializedObject.Update();

            DrawDefaultInspector();

            // EditorGUILayout.PropertyField(invulnerable);
            // EditorGUILayout.PropertyField(maxHealthUncapped);

            // if (!invulnerable.boolValue && !maxHealthUncapped.boolValue)
            // {
            //     EditorGUILayout.PropertyField(maxHealth);
            // }

            // if (!invulnerable.boolValue)
            // {
            //     EditorGUILayout.PropertyField(initialHealth);
            // }

            EditorGUI.BeginDisabledGroup(!Application.isPlaying);
            if (GUILayout.Button("Deal 1 Damage"))
            {
                healthMB.TakeDamage(1, null);
            }
            EditorGUI.EndDisabledGroup();


            serializedObject.ApplyModifiedProperties();
        }
    }
}
