using UnityEngine;

namespace BlueOyster.ProximityInteractables
{
    public class BaseInteractable : MonoBehaviour
    {
        private ProximityInteractable proximityInteractable;

        protected void OnEnable()
        {
            proximityInteractable = GetComponentInParent<ProximityInteractable>();
            if (proximityInteractable == null)
            {
                Debug.LogError("oops!", gameObject);
                throw new System.Exception("added an BaseInteractable to a component without a ProximityInteractable as a parent somewhere");
            }

            proximityInteractable.RegisterInteractable(this);
        }

        protected void OnDisable()
        {
            proximityInteractable.UnregisterInteractable(this);
        }

        public virtual void Interact() { }
        public virtual void OnProximityEnter() { }
        public virtual void OnProximityExit() { }
    }
}
