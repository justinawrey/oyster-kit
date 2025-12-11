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
        public static Reactive<Collider> ActiveCollider = new(null);
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
            unsub = ActiveCollider.OnChange(OnActiveColliderChange);
            OnActiveColliderChange(null, ActiveCollider.Value);

            mousePositionProvider = GetComponent<IMousePositionProvider>();
            if (mousePositionProvider == null)
            {
                throw new Exception("WorldSelectionController must have an IMousePositionProvider");
            }

            worldSelectActionReference.action.performed += WorldSelect;
        }

        private new void OnDisable()
        {
            base.OnDisable();
            unsub();
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
                ActiveCollider.Value = null;
            }
        }

        private void Aim()
        {
            Vector2 mousePosition = mousePositionProvider.GetMousePosition();
            Ray ray = mainCam.ScreenPointToRay(mousePosition);

            if (Physics.Raycast(ray, out RaycastHit hit, 1000))
            {
                ActiveCollider.Value = hit.collider;
            }
            else
            {
                ActiveCollider.Value = null;
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

            if (ActiveCollider.Value == null)
            {
                return;
            }

            if (worldSelectables.TryGetValue(ActiveCollider.Value, out var selectables))
            {
                for (int i = 0; i < selectables.Count; i++)
                {
                    selectables[i].WorldSelect();
                }
            }
        }
    }
}


