using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenWidth : Dween
    {
        [SerializeField]
        private float _offWidth = 0;

        [SerializeField]
        private float _onWidth;

        private Dynamics.Dynamics _dynamics;
        private float _target;

        public override void TurnOn()
        {
            _dynamics.ChangePreset(_risingPreset);
            _target = _onWidth;
        }

        public override void TurnOff()
        {
            _dynamics.ChangePreset(_fallingPreset);
            _target = _offWidth;
        }

        public override void ForceOn()
        {
            _rt.sizeDelta = new Vector2(_onWidth, _rt.sizeDelta.y);
        }

        public override void ForceOff()
        {
            _rt.sizeDelta = new Vector2(_offWidth, _rt.sizeDelta.y);
        }

        public override void SetupDween()
        {
            ForceOff();
            _target = _offWidth;
            _dynamics = new Dynamics.Dynamics(_risingPreset, _target);
        }

        public override void UpdateDween(float time, RectTransform rt)
        {
            base.UpdateDween(time, rt);
            float width = _dynamics.Update(time, _target);
            rt.sizeDelta = new Vector2(width, rt.sizeDelta.y);
        }
    }
}
