using BlueOyster.StateMachine;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(StateMachineToggleableCoordinatorMB))]
public class StateMachineToggleableCoordinatorMBEditor : Editor
{
    private StateMachineToggleableCoordinatorMB targ;
    private BaseStateMB state;

    private void OnEnable()
    {
        targ = (StateMachineToggleableCoordinatorMB)target;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        DrawPropertiesExcluding(serializedObject, "m_Script");

        EditorGUILayout.LabelField("Debug Options", EditorStyles.boldLabel);
        state = (BaseStateMB)EditorGUILayout.ObjectField("Simulated State", state, typeof(BaseStateMB), true);
        if (GUILayout.Button("Simulate State Change"))
        {
            targ.SimulateStateChange(state);
        }

        serializedObject.ApplyModifiedProperties();
    }
}
