using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenRotationZ : Dween
    {
        [SerializeField]
        private float _offRot = 0;

        [SerializeField]
        private float _onRot;

        private Dynamics.Dynamics _dynamics;
        private float _target;

        public override void TurnOn()
        {
            _dynamics.ChangePreset(_risingPreset);
            _target = _onRot;
        }

        public override void TurnOff()
        {
            _dynamics.ChangePreset(_fallingPreset);
            _target = _offRot;
        }

        public override void ForceOn()
        {
            _rt.localEulerAngles = new Vector3(_rt.localEulerAngles.x, _rt.localEulerAngles.y, _onRot);
        }

        public override void ForceOff()
        {
            _rt.localEulerAngles = new Vector3(_rt.localEulerAngles.x, _rt.localEulerAngles.y, _offRot);
        }

        public override void SetupDween()
        {
            ForceOff();
            _target = _offRot;
            _dynamics = new Dynamics.Dynamics(_risingPreset, _target);
        }

        public override void UpdateDween(float time, RectTransform rt)
        {
            base.UpdateDween(time, rt);
            float rotZ = _dynamics.Update(time, _target);
            rt.localEulerAngles = new Vector3(rt.localEulerAngles.x, rt.localEulerAngles.y, rotZ);
        }
    }
}
