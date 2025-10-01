using BlueOyster.StateMachine;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(StateMachine), true)]
public class StateMachineEditor : Editor
{
    private StateMachine stateMachine;

    private void OnEnable()
    {
        stateMachine = (StateMachine)target;
    }

    public override void OnInspectorGUI()
    {
        // Update the serialized object
        serializedObject.Update();

        // Draw all properties except 'states'
        DrawPropertiesExcluding(serializedObject, "m_Script");

        // Show current state
        if (Application.isPlaying)
        {
            EditorGUILayout.HelpBox($"Current State: {(stateMachine.CurrentState.Value == null ? "none" : stateMachine.CurrentState.Value.GetType().Name)}", MessageType.Info);
            Repaint();
        }
        else
        {
            EditorGUILayout.HelpBox("Current state is only visible in Play mode.", MessageType.Info);
        }


        // Apply changes
        serializedObject.ApplyModifiedProperties();
    }
}
