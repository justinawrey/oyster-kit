using UnityEngine;
using UnityEngine.EventSystems;
using BlueOyster.Dweens;

namespace BlueOyster.UIListeners
{
    public class TriggerDweenHoverListener : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, ISelectHandler, IDeselectHandler
    {
        [SerializeField]
        private DweenOrchestrator orchestrator;

        public void OnDeselect(BaseEventData eventData)
        {
            orchestrator.TurnOff();
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            orchestrator.TurnOn();
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            orchestrator.TurnOff();
        }

        public void OnSelect(BaseEventData eventData)
        {
            orchestrator.TurnOn();
        }
    }
}
