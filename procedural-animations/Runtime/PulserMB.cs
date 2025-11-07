using Cysharp.Threading.Tasks;
using BlueOyster.Dynamics;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    public class PulserMB : BaseImpulse
    {
        [SerializeField]
        private DynamicScale3 scale;

        [SerializeField]
        private float targetFactor = 1.3f;

        [SerializeField]
        private float duration = 0.1f;

        private Vector3 originalScale;

        private void OnEnable()
        {
            originalScale = transform.localScale;
        }

        public override void Trigger()
        {
            Routine().Forget();
        }

        private async UniTaskVoid Routine()
        {
            scale.Scale = originalScale * targetFactor;
            await UniTask.WaitForSeconds(duration);
            scale.Scale = originalScale;
        }
    }
}
