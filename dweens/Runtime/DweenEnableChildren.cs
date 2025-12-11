using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenEnableChildren : BaseDween
    {
        public override void ForceOn()
        {
            for (int i = 0; i < transform.childCount; i++)
            {
                transform.GetChild(i).gameObject.SetActive(true);
            }
        }

        public override void ForceOff()
        {
            for (int i = 0; i < transform.childCount; i++)
            {
                transform.GetChild(i).gameObject.SetActive(false);
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
