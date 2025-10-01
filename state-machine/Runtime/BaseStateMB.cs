#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;

namespace BlueOyster.StateMachine
{
    [ExecuteAlways]
    public class BaseStateMB : MonoBehaviour
    {
#if UNITY_EDITOR
    private void Awake() {
        // not sure why this works but honestly fuck it
        if (EditorApplication.isPlaying || EditorApplication.isPlayingOrWillChangePlaymode) {
            return;
        }

        EditorApplication.delayCall += () => {
            Component[] components = GetComponents(GetType());
            if (components.Length > 1) {
                Debug.LogError($"Multiple {GetType().Name} states on {gameObject.name}");
                DestroyImmediate(this);
            }
        };
    }
#endif

        public virtual void OnEnter() { }
        public virtual void OnExit() { }
        public virtual void OnUpdate() { }
        public virtual void OnFixedUpdate() { }
    }
}
