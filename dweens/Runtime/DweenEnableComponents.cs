using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenEnableComponents : BaseDween
    {
        [SerializeField]
        private List<Behaviour> components;

        public override void ForceOn()
        {
            for (int i = 0; i < components.Count; i++)
            {
                components[i].enabled = true;
            }
        }

        public override void ForceOff()
        {
            for (int i = 0; i < components.Count; i++)
            {
                components[i].enabled = false;
            }
        }

        public override void SetupDween()
        {
            ForceOff();
        }

        public override void TurnOff()
        {
            ForceOff();
        }

        public override void TurnOn()
        {
            ForceOn();
        }

        // no-op
        public override void UpdateDween(float time, RectTransform rt) { }
    }
}
