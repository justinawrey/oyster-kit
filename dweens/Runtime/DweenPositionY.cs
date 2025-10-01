using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenPositionY : Dween
    {
        [SerializeField]
        private float _offPos = 0;

        [SerializeField]
        private float _onPos;

        [SerializeField]
        private bool snap = false;

        private Dynamics.Dynamics _dynamics;
        private float _target;

        public override void TurnOn()
        {
            _dynamics.ChangePreset(_risingPreset);
            _target = _onPos;
        }

        public override void TurnOff()
        {
            _dynamics.ChangePreset(_fallingPreset);
            _target = _offPos;
        }

        public override void ForceOn()
        {
            _rt.anchoredPosition = new Vector2(_rt.anchoredPosition.x, _onPos);
        }

        public override void ForceOff()
        {
            _rt.anchoredPosition = new Vector2(_rt.anchoredPosition.x, _offPos);
        }

        public override void SetupDween()
        {
            ForceOff();
            _target = _offPos;
            _dynamics = new Dynamics.Dynamics(_risingPreset, _target);
        }

        public override void UpdateDween(float time, RectTransform rt)
        {
            base.UpdateDween(time, rt);
            float posY = _dynamics.Update(time, _target);

            if (snap)
            {
                posY = Mathf.RoundToInt(posY);
            }

            rt.anchoredPosition = new Vector2(rt.anchoredPosition.x, posY);
        }
    }
}
