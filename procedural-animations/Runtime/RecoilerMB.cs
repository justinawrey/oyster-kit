using Cysharp.Threading.Tasks;
using BlueOyster.Dynamics;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    public class RecoilerMB : MonoBehaviour
    {
        [SerializeField]
        private DynamicLocalPosition3 position;

        [SerializeField]
        private float recoilAmount = 0.3f;

        [SerializeField]
        private float duration = 0.1f;

        private Vector3 originalPosition;

        private void OnEnable()
        {
            originalPosition = transform.localPosition;
        }

        public void Recoil()
        {
            Routine().Forget();
        }

        private async UniTaskVoid Routine()
        {
            position.Position = originalPosition - transform.forward * recoilAmount;
            await UniTask.WaitForSeconds(duration);
            position.Position = originalPosition;
        }
    }
}

