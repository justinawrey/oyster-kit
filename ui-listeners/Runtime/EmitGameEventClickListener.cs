using UnityEngine;
using System;
using UnityEngine.EventSystems;
using BlueOyster.SceneBooter;
using Cysharp.Threading.Tasks;

namespace BlueOyster.UIListeners
{
    public abstract class EmitGameEventClickListener<C, GE> : MonoBehaviour, IPointerClickHandler, ISubmitHandler
        where C : IBooterConfig<GE>
        where GE : Enum
    {
        protected abstract SceneBooter<C, GE> booter { get; }

        [SerializeField]
        private GE _event;

        [SerializeField]
        private float delay = 0f;

        private bool canSubmit = true;

        public void OnPointerClick(PointerEventData eventData)
        {
            if (!canSubmit) return;

            if (delay > 0)
            {
                canSubmit = false;
                EmitWithDelay(delay).Forget();
            }
            else
            {
                booter.Context.EventBus.Trigger(_event);
            }
        }

        public void OnSubmit(BaseEventData eventData)
        {
            if (!canSubmit) return;

            if (delay > 0)
            {
                canSubmit = false;
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
            canSubmit = true;
        }
    }
}
