using UnityEngine;

namespace BlueOyster.WorldSelectables
{
    public abstract class BaseWorldSelectableMB : MonoBehaviour, IWorldSelectable
    {
        private WorldSelectionController worldSelectionController;

        [SerializeField]
        private Collider col;

        protected void OnEnable()
        {
            worldSelectionController = GetComponentInParent<WorldSelectionController>();
            if (worldSelectionController == null)
            {
                Debug.LogError("oops!", gameObject);
                throw new System.Exception("added an IWorldSelectable to a component without a WorldSelectionController as a parent somewhere");
            }

            worldSelectionController.RegisterWorldSelectable(col, this);
        }

        protected void OnDisable()
        {
            worldSelectionController.UnregisterWorldSelectable(col, this);
        }

        public virtual void WorldSelectionEnter() { }
        public virtual void WorldSelectionExit() { }
        public virtual void WorldSelect() { }
    }
}

