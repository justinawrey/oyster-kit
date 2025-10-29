using Cysharp.Threading.Tasks;
using BlueOyster.Dynamics;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    public class PulserMB : MonoBehaviour
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

        public void Pulse()
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
