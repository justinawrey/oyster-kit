using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    public interface IImpulseAnimation
    {
        void Trigger();
    }

    public abstract class BaseImpulse : MonoBehaviour, IImpulseAnimation
    {
        public abstract void Trigger();
    }
}

