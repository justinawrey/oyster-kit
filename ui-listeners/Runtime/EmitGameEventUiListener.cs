using UnityEngine;
using System;
using UnityEngine.EventSystems;
using BlueOyster.SceneBooter;

namespace BlueOyster.UIListeners
{
    public abstract class EmitGameEventUiListener<C, GE> : MonoBehaviour, IPointerClickHandler
        where C : IBooterConfig<GE>
        where GE : Enum
    {
        protected abstract SceneBooter<C, GE> booter { get; }

        [SerializeField]
        private GE _event;

        public void OnPointerClick(PointerEventData eventData)
        {
            booter.Context.EventBus.Trigger(_event);
        }
    }
}
