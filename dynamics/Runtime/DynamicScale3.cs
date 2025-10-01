using UnityEngine;

namespace BlueOyster.Dynamics
{
    public class DynamicScale3 : MonoBehaviour
    {
        [HideInInspector]
        public Vector3 Scale;

        [SerializeField]
        private DynamicsPresetSO preset;
        private Dynamics3 dynamics;

        private void OnEnable()
        {
            Scale = transform.localScale;
            dynamics = new Dynamics3(preset, Scale);
        }

        private void Update()
        {
            transform.localScale = dynamics.Update(Time.deltaTime, Scale);
        }

        public void ChangePreset(DynamicsPresetSO preset)
        {
            dynamics.ChangePreset(preset);
        }
    }
}
