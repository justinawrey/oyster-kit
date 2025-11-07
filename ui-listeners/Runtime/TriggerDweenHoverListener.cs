using UnityEngine;
using UnityEngine.EventSystems;
using BlueOyster.Dweens;

namespace BlueOyster.UIListeners
{
    public class TriggerDweenHoverListener : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
    {
        [SerializeField]
        private DweenOrchestrator orchestrator;

        public void OnPointerEnter(PointerEventData eventData)
        {
            orchestrator.TurnOn();
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            orchestrator.TurnOff();
        }
    }
}
