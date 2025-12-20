using System;
using System.Collections.Generic;
using BlueOyster.Reactive;
using UnityEngine;
using UnityEngine.Events;

namespace OysterKit
{
    public class DataBinding<T> : MonoBehaviour
    {
        [SerializeField]
        private NamedProp property;

        [SerializeField]
        private List<UnityEvent<T>> onChange;

        private Action unsub;
        private Reactive<T> data;
        public Reactive<T> Data => data;

        private void OnEnable()
        {
            data = property.ReadValue<Reactive<T>>();
            unsub = data.OnChange(TriggerUnityEvents);
            TriggerUnityEvents(data.Value);
        }

        private void OnDisable()
        {
            unsub?.Invoke();
        }

        private void TriggerUnityEvents(T arg)
        {
            for (int i = 0; i < onChange.Count; i++)
            {
                onChange[i].Invoke(arg);
            }
        }
    }
}
