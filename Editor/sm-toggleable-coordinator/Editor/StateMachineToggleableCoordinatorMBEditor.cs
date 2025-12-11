using System.Collections.Generic;
using BlueOyster.StateMachine;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(StateMachineToggleableCoordinatorMB))]
public class StateMachineToggleableCoordinatorMBEditor : Editor
{
    private StateMachineToggleableCoordinatorMB targ;
    private readonly List<BaseStateMB> states = new();

    private void OnEnable()
    {
        targ = (StateMachineToggleableCoordinatorMB)target;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        DrawPropertiesExcluding(serializedObject, "m_Script");

        if (targ.StateMachine != null)
        {
            EditorGUILayout.LabelField("Simulate State Change", EditorStyles.boldLabel);

            // TODO: ack could be slow
            targ.StateMachine.gameObject.GetComponents(states);
            foreach (BaseStateMB state in states)
            {
                if (GUILayout.Button(state.GetType().Name))
                {
                    targ.SimulateStateChange(state);
                }
            }
        }

        serializedObject.ApplyModifiedProperties();
    }
}
