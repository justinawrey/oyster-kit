using UnityEngine;
using UnityEngine.EventSystems;
using BlueOyster.ProceduralAnimations;

namespace BlueOyster.UIListeners
{
    public class TriggerImpulseClickListener : MonoBehaviour, IPointerClickHandler
    {
        [SerializeField]
        private BaseImpulse baseImpulse;

        public void OnPointerClick(PointerEventData eventData)
        {
            baseImpulse.Trigger();
        }
    }
}

