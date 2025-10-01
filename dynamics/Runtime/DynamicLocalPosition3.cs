using UnityEngine;

namespace BlueOyster.Dynamics
{
    public class DynamicLocalPosition3 : MonoBehaviour
    {
        [HideInInspector]
        public Vector3 Position;

        [SerializeField]
        private DynamicsPresetSO preset;
        private Dynamics3 dynamics;

        private void OnEnable()
        {
            Position = transform.localPosition;
            dynamics = new Dynamics3(preset, Position);
        }

        private void Update()
        {
            transform.localPosition = dynamics.Update(Time.deltaTime, Position);
        }

        public void ChangePreset(DynamicsPresetSO preset)
        {
            dynamics.ChangePreset(preset);
        }
    }
}

