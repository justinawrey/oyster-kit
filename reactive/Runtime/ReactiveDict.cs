#nullable enable
using System;
using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.Reactive
{
    [Serializable]
    public class KVP<K, V>
    {
        public K? Key = default(K);
        public V? Val = default(V);

        public KVP(K key, V val)
        {
            Key = key;
            Val = val;
        }
    }

    [Serializable]
    public class ReactiveDict<K, V>
        : Dictionary<K, V>,
            IReactiveCallbackOwner<Dictionary<K, V>>,
            ISerializationCallbackReceiver
    {
        private List<Action<K, V>> _addCbs = new List<Action<K, V>>();
        private List<Action<K, V>> _removeCbs = new List<Action<K, V>>();
        public Dictionary<K, V>? Value => this;

        [SerializeField]
        private List<KVP<K, V>> _kvps = new List<KVP<K, V>>();

        public Action OnAdd(Action<K, V> cb)
        {
            _addCbs.Add(cb);
            return () => _addCbs.Remove(cb);
        }

        public Action OnRemove(Action<K, V> cb)
        {
            _removeCbs.Add(cb);
            return () => _removeCbs.Remove(cb);
        }

        public Action OnChange(Action<Dictionary<K, V>?> cb)
        {
            Action<K, V> curried = (_, __) => cb(Value);

            _addCbs.Add(curried);
            _removeCbs.Add(curried);

            return () =>
            {
                _addCbs.Remove(curried);
                _removeCbs.Remove(curried);
            };
        }

        public new void Add(K key, V val)
        {
            base.Add(key, val);

            foreach (Action<K, V> cb in _addCbs)
            {
                cb(key, val);
            }
        }

        public new void Remove(K key)
        {
            V val = this[key];
            base.Remove(key);

            foreach (Action<K, V> cb in _removeCbs)
            {
                cb(key, val);
            }
        }

        public new void Clear()
        {
            Dictionary<K, V> copy = new Dictionary<K, V>(this);
            base.Clear();

            foreach (var kvp in copy)
            {
                foreach (Action<K, V> cb in _removeCbs)
                {
                    cb(kvp.Key, kvp.Value);
                }
            }
        }

        public void OnBeforeSerialize()
        {
            _kvps.Clear();
            foreach (var (key, val) in this)
            {
                _kvps.Add(new KVP<K, V>(key, val));
            }
        }

        public void OnAfterDeserialize()
        {
            base.Clear();
            foreach (var kvp in _kvps)
            {
#pragma warning disable 8604
                base.Add(kvp.Key, kvp.Val);
#pragma warning restore 8604
            }
        }
    }
}
#nullable disable
