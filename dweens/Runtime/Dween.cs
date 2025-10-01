using BlueOyster.Dynamics;
using UnityEngine;

namespace BlueOyster.Dweens
{
    public class Dween : BaseDween
    {
        [SerializeField]
        protected DynamicsPresetSO _risingPreset;

        [SerializeField]
        protected DynamicsPresetSO _fallingPreset;

        private RectTransform _rtBacking = null;
        protected RectTransform _rt
        {
            get
            {
                if (_rtBacking != null)
                {
                    return _rtBacking;
                }

                _rtBacking = GetComponent<RectTransform>();
                return _rtBacking;
            }
        }

        public override void UpdateDween(float time, RectTransform rt)
        {
            if (rt == null)
            {
                Debug.LogError(
                    "dween is being updated, but it was passed no rect transform. This should never happen and things are broken!"
                );
            }
        }
    }
}
