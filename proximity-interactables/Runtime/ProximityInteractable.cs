using System;
using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.ProximityInteractables
{
    public class ProximityInteractable : MonoBehaviour
    {
        [SerializeField]
        private string interacteeTag;

        [NonSerialized]
        public List<BaseInteractable> Interactables = new();

        private static ProximityInteractable active = null;
        private static Stack<ProximityInteractable> stack = new();

        public void RegisterInteractable(BaseInteractable interactable)
        {
            Interactables.Add(interactable);
        }

        public void UnregisterInteractable(BaseInteractable interactable)
        {
            Interactables.Remove(interactable);
        }

        private void OnEnable()
        {
            stack.Clear();
        }

        private void OnDisable()
        {
            stack.Clear();
        }

        public static void InteractCurrent()
        {
            if (active == null)
            {
                return;
            }

            foreach (BaseInteractable interactable in active.Interactables)
            {
                interactable.Interact();
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (!other.CompareTag(interacteeTag))
            {
                return;
            }

            foreach (BaseInteractable interactable in Interactables)
            {
                interactable.OnProximityEnter();
            }

            stack.Push(this);
            active = stack.Peek();
        }

        private void OnTriggerExit(Collider other)
        {
            if (!other.CompareTag(interacteeTag))
            {
                return;
            }

            foreach (BaseInteractable interactable in Interactables)
            {
                interactable.OnProximityExit();
            }

            stack.Pop();
            if (stack.Count > 0)
            {
                active = stack.Peek();
            }
            else
            {
                active = null;
            }
        }
    }
}
