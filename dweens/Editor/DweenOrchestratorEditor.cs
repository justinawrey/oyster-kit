using BlueOyster.Dweens;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(DweenOrchestrator))]
public class DweenOrchestratorEditor : Editor
{
    private DweenOrchestrator _target;
    private bool _on = false;

    private void OnEnable()
    {
        _target = (DweenOrchestrator)target;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        string buttonText = _on ? "Set off" : "Set on";
        if (GUILayout.Button(buttonText))
        {
            if (!_on)
            {
                _on = true;
                if (Application.isPlaying)
                    _target.TurnOn();
                else
                    _target.ForceOn();
            }
            else
            {
                _on = false;
                if (Application.isPlaying)
                    _target.TurnOff();
                else
                    _target.ForceOff();
            }
        }

        DrawPropertiesExcluding(serializedObject, "m_Script");
        serializedObject.ApplyModifiedProperties();
    }
}
