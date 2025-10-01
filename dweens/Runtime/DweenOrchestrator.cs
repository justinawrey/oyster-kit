using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.Dweens
{
    [System.Serializable]
    public class DweenWithDelay
    {
        public BaseDween Dween;
        public float RisingDelay = 0;
        public float FallingDelay = 0;
    }

    public class DweenOrchestrator : BaseDween
    {
        [SerializeField]
        private bool _isUpdateSource = true;

        [SerializeField]
        private bool _controlOwnRectTransform = true;

        [SerializeField]
        private List<DweenWithDelay> _dweens = new List<DweenWithDelay>();

        private bool _on = false;
        public bool On => _on;

        private RectTransform _rtBacking = null;
        private RectTransform _rt
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

        private new void OnEnable()
        {
            base.OnEnable();
            SetupDween();
        }

        public override void TurnOn()
        {
            _on = true;
            foreach (var dween in _dweens)
            {
                dween.Dween.TurnOn();
            }
        }

        public override void TurnOff()
        {
            _on = false;

            // When turning off, go in the reverse order.
            for (int i = _dweens.Count - 1; i >= 0; i--)
            {
                var dween = _dweens[i];
                dween.Dween.TurnOff();
            }
        }

        public void SetTo(bool on)
        {
            if (on)
            {
                TurnOn();
            }
            else
            {
                TurnOff();
            }
        }

        public override void ForceOn()
        {
            _on = true;
            foreach (var dween in _dweens)
            {
                dween.Dween.ForceOn();
            }
        }

        public override void ForceOff()
        {
            _on = false;
            foreach (var dween in _dweens)
            {
                dween.Dween.ForceOff();
            }
        }

        // what
        public override void UpdateDween(float deltaTime, RectTransform rt)
        {
            foreach (var dween in _dweens)
            {
                RectTransform nrt = rt;
                if (rt == null && _controlOwnRectTransform)
                {
                    nrt = _rt;
                }
                dween.Dween.UpdateDween(deltaTime, nrt);
            }
        }

        public override void SetupDween()
        {
            foreach (var dween in _dweens)
            {
                dween.Dween.SetupDween();
            }
        }

        private void Update()
        {
            if (!_isUpdateSource)
            {
                return;
            }

            UpdateDween(Time.unscaledDeltaTime, _controlOwnRectTransform ? _rt : null);
        }
    }
}
