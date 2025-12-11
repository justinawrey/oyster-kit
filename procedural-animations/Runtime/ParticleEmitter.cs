using BlueOyster.ProceduralAnimations;
using Cysharp.Threading.Tasks;
using UnityEngine;

public class ParticleEmitter : BaseImpulse
{
    [SerializeField]
    private ParticleSystem particles;

    [SerializeField]
    private int amount = 5;

    [SerializeField]
    private int variance = 1;

    [SerializeField]
    private float interval = 0.05f;

    public override void Trigger()
    {
        Routine().Forget();
    }

    private async UniTaskVoid Routine()
    {
        int randomAmount = Random.Range(amount - variance, amount + variance);
        for (int i = 0; i < randomAmount; i++)
        {
            particles.Emit(1);
            await UniTask.WaitForSeconds(interval);
        }
    }
}