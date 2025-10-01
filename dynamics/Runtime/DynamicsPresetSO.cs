using UnityEngine;

namespace BlueOyster.Dynamics
{
    [CreateAssetMenu(fileName = "Dynamics Preset", menuName = "Dynamics/Preset")]
    public class DynamicsPresetSO : ScriptableObject
    {
        [Range(0, 10)]
        public float F = 2f;

        [Range(0, 2)]
        public float Z = 0.5f;

        [Range(-10, 10)]
        public float R = -1f;
    }
}
