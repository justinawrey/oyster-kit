using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenScaleX : Dween
    {
        [SerializeField]
        private float _offScale = 0;

        [SerializeField]
        private float _onScale;

        private Dynamics.Dynamics _dynamics;
        private float _target;

        public override void TurnOn()
        {
            _dynamics.ChangePreset(_risingPreset);
            _target = _onScale;
        }

        public override void TurnOff()
        {
            _dynamics.ChangePreset(_fallingPreset);
            _target = _offScale;
        }

        public override void ForceOn()
        {
            _rt.localScale = new Vector3(_onScale, _rt.localScale.y, _rt.localScale.z);
        }

        public override void ForceOff()
        {
            _rt.localScale = new Vector3(_offScale, _rt.localScale.y, _rt.localScale.z);
        }

        public override void SetupDween()
        {
            ForceOff();
            _target = _offScale;
            _dynamics = new Dynamics.Dynamics(_risingPreset, _target);
        }

        public override void UpdateDween(float time, RectTransform rt)
        {
            base.UpdateDween(time, rt);
            float scaleX = _dynamics.Update(time, _target);
            rt.localScale = new Vector3(scaleX, rt.localScale.y, rt.localScale.z);
        }
    }
}
