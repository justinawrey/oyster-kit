using UnityEngine;
using UnityEngine.EventSystems;
using BlueOyster.ProceduralAnimations;

namespace BlueOyster.UIListeners
{
    public class TriggerImpulseClickListener : MonoBehaviour, IPointerClickHandler, ISubmitHandler
    {
        [SerializeField]
        private BaseImpulse baseImpulse;

        public void OnPointerClick(PointerEventData eventData)
        {
            baseImpulse.Trigger();
        }

        public void OnSubmit(BaseEventData eventData)
        {
            baseImpulse.Trigger();
        }
    }
}

