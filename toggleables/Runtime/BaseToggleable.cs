using UnityEngine;
using BlueOyster.Reactive;
using System;

namespace BlueOyster.Toggleables
{
    /// <summary>
    /// Base class for creating toggleable components with reactive state management.
    /// Inherit from this class to create toggleable UI or game object behaviors.
    /// </summary>
    public abstract class BaseToggleable : MonoBehaviour
    {
        [NonSerialized]
        public Reactive<bool> Enabled = new(true);

        private Action unsub;

        protected virtual void OnEnable()
        {
            unsub = Enabled.OnChange(on => OnToggle(on));
        }

        protected virtual void OnDisable()
        {
            unsub?.Invoke();
        }

        /// <summary>
        /// Override this method to implement toggle behavior
        /// </summary>
        /// <param name="isOn">Current toggle state</param>
        public virtual void OnToggle(bool isOn) { }
    }
}
