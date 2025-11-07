using UnityEngine;
using System;
using UnityEngine.EventSystems;
using BlueOyster.SceneBooter;
using Cysharp.Threading.Tasks;

namespace BlueOyster.UIListeners
{
    public abstract class EmitGameEventClickListener<C, GE> : MonoBehaviour, IPointerClickHandler
        where C : IBooterConfig<GE>
        where GE : Enum
    {
        protected abstract SceneBooter<C, GE> booter { get; }

        [SerializeField]
        private GE _event;

        [SerializeField]
        private float delay = 0f;

        public void OnPointerClick(PointerEventData eventData)
        {
            if (delay > 0)
            {
                EmitWithDelay(delay).Forget();
            }
            else
            {
                booter.Context.EventBus.Trigger(_event);
            }
        }

        private async UniTaskVoid EmitWithDelay(float delay)
        {
            await UniTask.WaitForSeconds(delay);
            booter.Context.EventBus.Trigger(_event);
        }
    }
}
