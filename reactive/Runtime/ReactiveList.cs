#nullable enable
using System;
using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.Reactive
{
    [Serializable]
    public class ReactiveList<T>
        : List<T>,
            IReactiveCallbackOwner<List<T>>,
            ISerializationCallbackReceiver
    {
        private List<Action<T>> _addCbs = new List<Action<T>>();
        private List<Action<T>> _removeCbs = new List<Action<T>>();
        public List<T>? Value => this;

        [SerializeField]
        private List<T> _internal = new List<T>();

        public Action OnAdd(Action<T> cb)
        {
            _addCbs.Add(cb);
            return () => _addCbs.Remove(cb);
        }

        public Action OnRemove(Action<T> cb)
        {
            _removeCbs.Add(cb);
            return () => _removeCbs.Remove(cb);
        }

        public Action OnChange(Action<List<T>?> cb)
        {
            Action<T?> curried = _ => cb(Value);

            _addCbs.Add(curried);
            _removeCbs.Add(curried);

            return () =>
            {
                _addCbs.Remove(curried);
                _removeCbs.Remove(curried);
            };
        }

        public new void Add(T item)
        {
            base.Add(item);

            foreach (Action<T> cb in _addCbs)
            {
                cb(item);
            }
        }

        public new void Remove(T item)
        {
            base.Remove(item);

            foreach (Action<T> cb in _removeCbs)
            {
                cb(item);
            }
        }

        public new void Clear()
        {
            List<T> copy = new List<T>(this);
            base.Clear();

            copy.ForEach(item =>
            {
                foreach (Action<T> cb in _removeCbs)
                {
                    cb(item);
                }
            });
        }

        public void OnBeforeSerialize()
        {
            _internal.Clear();
            _internal.AddRange(this);
        }

        public void OnAfterDeserialize()
        {
            base.Clear();
            AddRange(_internal);
        }
    }
}
