using System.Collections.Generic;
using BlueOyster.Toggleables;
using UnityEngine;
using UnityEngine.UI;

namespace BlueOyster.UIListeners
{
    public class EnableInteractableGroup : BaseToggleable
    {
        private List<Selectable> selectables = new();

        [SerializeField]
        private Selectable initialSelectionInGroup;

        private Selectable selectionMemory;

        private new void OnEnable()
        {
            transform.GetComponentsInChildren(selectables);
            base.OnEnable();
            OnToggle(Enabled.Value);
        }

        private new void OnDisable()
        {
            selectables.Clear();
            base.OnDisable();
        }

        public override void OnToggle(bool isOn)
        {
            foreach (var selectable in selectables)
            {
                selectable.interactable = isOn;
            }

            // if we're leaving the selection group, nothing to initially select.
            // but, we can remember the last selected item for when we return.
            if (!isOn)
            {
                var lastSelected = LastSelectedGameObjectTracker.LastSelected;
                if (lastSelected != null)
                {
                    selectionMemory = lastSelected.GetComponent<Selectable>();
                }
                return;
            }

            // Never reselect memory or fallback initial when we're straight up just
            // using the mouse! 
            if (LastSelectedGameObjectTracker.IsUsingMouse)
            {
                return;
            }

            // select the last thing that was selected in this group
            // before we moved to a different group
            if (selectionMemory != null)
            {
                selectionMemory.Select();
                selectionMemory = null;
                return;
            }

            // otherwise go to a fallback selection
            if (initialSelectionInGroup != null)
            {
                initialSelectionInGroup.Select();
            }
        }
    }
}