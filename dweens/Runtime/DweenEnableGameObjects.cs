using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.Dweens
{
    public class DweenEnableGameObjects : BaseDween
    {
        [SerializeField]
        private List<GameObject> gameObjects;

        public override void ForceOn()
        {
            for (int i = 0; i < gameObjects.Count; i++)
            {
                gameObjects[i].SetActive(true);
            }
        }

        public override void ForceOff()
        {
            for (int i = 0; i < gameObjects.Count; i++)
            {
                gameObjects[i].SetActive(false);
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
