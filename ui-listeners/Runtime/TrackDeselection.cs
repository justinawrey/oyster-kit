using BlueOyster.UIListeners;
using UnityEngine;
using UnityEngine.EventSystems;

namespace OysterKit
{
    public class TrackDeselection : MonoBehaviour, IDeselectHandler, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
    {
        public void OnDeselect(BaseEventData eventData)
        {
            LastSelectedGameObjectTracker.LastSelected = gameObject;
        }

        public void OnPointerClick(PointerEventData eventData)
        {
            LastSelectedGameObjectTracker.IsUsingMouse = true;
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            LastSelectedGameObjectTracker.IsUsingMouse = true;
            EventSystem.current.SetSelectedGameObject(null);
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            LastSelectedGameObjectTracker.IsUsingMouse = true;
            EventSystem.current.SetSelectedGameObject(null);
        }
    }
}
