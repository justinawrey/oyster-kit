using UnityEngine;

namespace BlueOyster.Dynamics
{
    public class DynamicLocalRotation3 : MonoBehaviour
    {
        [HideInInspector]
        public Vector3 EulerAngles;

        [SerializeField]
        private DynamicsPresetSO preset;
        private Dynamics3 dynamics;

        private void OnEnable()
        {
            EulerAngles = transform.localEulerAngles;
            dynamics = new Dynamics3(preset, EulerAngles);
        }

        private void Update()
        {
            transform.localEulerAngles = dynamics.Update(Time.deltaTime, EulerAngles);
        }

        public void ChangePreset(DynamicsPresetSO preset)
        {
            dynamics.ChangePreset(preset);
        }
    }
}
