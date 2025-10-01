using System;
using System.Collections.Generic;
using BlueOyster.Reactive;
using UnityEngine;
using UnityEngine.InputSystem;
using BlueOyster.Toggleables;

namespace BlueOyster.WorldSelectables
{
    public interface IWorldSelectable
    {
        void WorldSelectionEnter();
        void WorldSelectionExit();
        void WorldSelect();
    }

    public interface IMousePositionProvider
    {
        Vector2 GetMousePosition();
    }

    public class WorldSelectionController : BaseToggleable
    {
        private Dictionary<Collider, List<IWorldSelectable>> worldSelectables = new();
        private Reactive<Collider> activeCollider = new(null);
        private Camera mainCam;
        private Action unsub;
        private IMousePositionProvider mousePositionProvider;

        [SerializeField]
        private InputActionReference worldSelectActionReference;

        public void RegisterWorldSelectable(Collider col, IWorldSelectable interactable)
        {
            if (!worldSelectables.ContainsKey(col))
            {
                worldSelectables[col] = new List<IWorldSelectable>();
            }

            worldSelectables[col].Add(interactable);
        }

        public void UnregisterWorldSelectable(Collider col, IWorldSelectable interactable)
        {
            if (worldSelectables.ContainsKey(col))
            {
                worldSelectables[col].Remove(interactable);
            }
        }

        private new void OnEnable()
        {
            base.OnEnable();
            mainCam = Camera.main;
            unsub = activeCollider.OnChange(OnActiveColliderChange);
            OnActiveColliderChange(null, activeCollider.Value);

            mousePositionProvider = GetComponent<IMousePositionProvider>();
            if (mousePositionProvider == null)
            {
                throw new Exception("WorldSelectionController must have an IMousePositionProvider");
            }

            worldSelectActionReference.action.Enable();
            worldSelectActionReference.action.performed += WorldSelect;
        }

        private new void OnDisable()
        {
            base.OnDisable();
            unsub();
            worldSelectActionReference.action.Disable();
            worldSelectActionReference.action.performed -= WorldSelect;
        }

        private void Update()
        {
            if (!Enabled.Value)
            {
                return;
            }

            Aim();
        }

        override public void OnToggle(bool on)
        {
            if (!on)
            {
                activeCollider.Value = null;
            }
        }

        private void Aim()
        {
            Vector2 mousePosition = mousePositionProvider.GetMousePosition();
            Ray ray = mainCam.ScreenPointToRay(mousePosition);

            if (Physics.Raycast(ray, out RaycastHit hit, 1000))
            {
                activeCollider.Value = hit.collider;
            }
            else
            {
                activeCollider.Value = null;
            }
        }

        private void OnActiveColliderChange(Collider prev, Collider curr)
        {
            if (prev != null)
            {
                if (worldSelectables.TryGetValue(prev, out var selectables))
                {
                    for (int i = 0; i < selectables.Count; i++)
                    {
                        selectables[i].WorldSelectionExit();
                    }
                }

            }

            if (curr != null)
            {
                if (worldSelectables.TryGetValue(curr, out var selectables))
                {
                    for (int i = 0; i < selectables.Count; i++)
                    {
                        selectables[i].WorldSelectionEnter();
                    }
                }
            }
        }

        private void WorldSelect(InputAction.CallbackContext context)
        {
            if (!Enabled.Value)
            {
                return;
            }

            if (activeCollider.Value == null)
            {
                return;
            }

            if (worldSelectables.TryGetValue(activeCollider.Value, out var selectables))
            {
                for (int i = 0; i < selectables.Count; i++)
                {
                    selectables[i].WorldSelect();
                }
            }
        }
    }
}


