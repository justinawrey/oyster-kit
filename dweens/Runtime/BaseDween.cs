using UnityEngine;
using BlueOyster.Toggleables;

namespace BlueOyster.Dweens
{
    // only exists to hack the editor, this way we can drag nicer
    public class BaseDween : BaseToggleable
    {
        public virtual void ForceOff()
        {
            throw new System.NotImplementedException();
        }

        public virtual void ForceOn()
        {
            throw new System.NotImplementedException();
        }

        public virtual void SetupDween()
        {
            throw new System.NotImplementedException();
        }

        public virtual void TurnOff()
        {
            throw new System.NotImplementedException();
        }

        public virtual void TurnOn()
        {
            throw new System.NotImplementedException();
        }

        public virtual void UpdateDween(float time, RectTransform rt)
        {
            throw new System.NotImplementedException();
        }

        public override void OnToggle(bool on)
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
    }
}
