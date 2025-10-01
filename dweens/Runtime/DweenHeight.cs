using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenHeight : Dween
    {
        [SerializeField]
        private float _offHeight = 0;

        [SerializeField]
        private float _onHeight;

        private Dynamics.Dynamics _dynamics;
        private float _target;

        public override void TurnOn()
        {
            _dynamics.ChangePreset(_risingPreset);
            _target = _onHeight;
        }

        public override void TurnOff()
        {
            _dynamics.ChangePreset(_fallingPreset);
            _target = _offHeight;
        }

        public override void ForceOn()
        {
            _rt.sizeDelta = new Vector2(_rt.sizeDelta.x, _onHeight);
        }

        public override void ForceOff()
        {
            _rt.sizeDelta = new Vector2(_rt.sizeDelta.x, _offHeight);
        }

        public override void SetupDween()
        {
            ForceOff();
            _target = _offHeight;
            _dynamics = new Dynamics.Dynamics(_risingPreset, _target);
        }

        public override void UpdateDween(float time, RectTransform rt)
        {
            base.UpdateDween(time, rt);
            float height = _dynamics.Update(time, _target);
            rt.sizeDelta = new Vector2(rt.sizeDelta.x, height);
        }
    }
}
