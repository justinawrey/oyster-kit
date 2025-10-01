#nullable enable
using System;
using System.Collections.Generic;

namespace BlueOyster.Reactive
{
    [Serializable]
    public class ReactiveSet<T> : HashSet<T>, IReactiveCallbackOwner<HashSet<T>>
    {
        private List<Action<T>> _addCbs = new List<Action<T>>();
        private List<Action<T>> _removeCbs = new List<Action<T>>();
        public HashSet<T>? Value => this;

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

        public Action OnChange(Action<HashSet<T>?> cb)
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
            if (!base.Add(item))
            {
                return;
            }

            foreach (Action<T> cb in _addCbs)
            {
                cb(item);
            }
        }

        public new void Remove(T item)
        {
            if (!base.Remove(item))
            {
                return;
            }

            foreach (Action<T> cb in _removeCbs)
            {
                cb(item);
            }
        }

        public new void Clear()
        {
            HashSet<T> copy = new HashSet<T>(this);
            base.Clear();

            foreach (T item in copy)
            {
                foreach (Action<T> cb in _removeCbs)
                {
                    cb(item);
                }
            }
        }
    }
}
