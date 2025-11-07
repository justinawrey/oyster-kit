using Cysharp.Threading.Tasks;
using BlueOyster.Dynamics;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    public class TorquerMB : BaseImpulse
    {
        [SerializeField]
        private DynamicLocalRotation3 rotation;

        [SerializeField]
        private float torqueAmount = 10f;

        [SerializeField]
        private Vector3 torqueDir = new Vector3(1, 0, 1);

        [SerializeField]
        private bool useRandomTorqueDir = true;

        [SerializeField]
        private float duration = 0.1f;

        private Vector3 originalLocalRotation;

        private void OnEnable()
        {
            originalLocalRotation = rotation.EulerAngles;
        }

        public override void Trigger()
        {
            Routine().Forget();
        }

        private async UniTaskVoid Routine()
        {
            Vector3 actualTorqueDir = useRandomTorqueDir ? new Vector3(Random.Range(-1f, 1f), 0, Random.Range(-1f, 1f)).normalized : torqueDir;

            rotation.EulerAngles = originalLocalRotation + (actualTorqueDir * torqueAmount);
            await UniTask.WaitForSeconds(duration);
            rotation.EulerAngles = originalLocalRotation;
        }
    }
}