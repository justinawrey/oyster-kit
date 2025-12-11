using BlueOyster.Dweens;
using UnityEditor;

[CustomEditor(typeof(Dween), true)]
public class DweenEditor : Editor
{
    private Dween _target;

    private void OnEnable()
    {
        _target = (Dween)target;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        DrawPropertiesExcluding(serializedObject, "m_Script");
        serializedObject.ApplyModifiedProperties();
    }
}
