using UnityEngine;

namespace BlueOyster.Dynamics
{
    public class DynamicPosition3 : MonoBehaviour
    {
        [HideInInspector]
        public Vector3 Position;

        [SerializeField]
        private DynamicsPresetSO preset;
        private Dynamics3 dynamics;

        private void OnEnable()
        {
            Position = transform.position;
            dynamics = new Dynamics3(preset, Position);
        }

        private void Update()
        {
            transform.position = dynamics.Update(Time.deltaTime, Position);
        }

        public void ChangePreset(DynamicsPresetSO preset)
        {
            dynamics.ChangePreset(preset);
        }
    }
}
