#nullable enable
using System;
using System.Collections.Generic;

namespace BlueOyster.Reactive
{
    // A computed variable for sets that checks for deep equality when refreshing
    // dependents, as well as providing value diffing with
    // convenience OnAdd and OnRemove callbacks
    [Serializable]
    public class ComputedSet<T> : Computed<HashSet<T>>
        where T : IEquatable<T>
    {
        private List<Action<T>> _addCbs = new List<Action<T>>();
        private List<Action<T>> _removeCbs = new List<Action<T>>();

        protected override bool EqualityFunc(HashSet<T>? first, HashSet<T>? second)
        {
            if (first is null && second is null)
            {
                return true;
            }

            if (first is null && second is not null)
            {
                return false;
            }

            if (first is not null && second is null)
            {
                return false;
            }

            if (first is HashSet<T> f && second is HashSet<T> s)
            {
                return f.SetEquals(s);
            }

            return false;
        }

        protected override void FlushAdditionalCbs(HashSet<T>? prev, HashSet<T>? curr)
        {
            if (prev is null && curr is null)
            {
                return;
            }

            if (prev is null && curr is not null)
            {
                foreach (T item in curr)
                {
                    _addCbs.ForEach(cb => cb(item));
                }
                return;
            }

            if (prev is not null && curr is null)
            {
                foreach (T item in prev)
                {
                    _removeCbs.ForEach(cb => cb(item));
                }
                return;
            }

            // don't worry about checking p.SetEquals(c) here, we're assuming the sets
            // are NOT equal!
            if (prev is HashSet<T> previous && curr is HashSet<T> current)
            {
                void ProcessCallbacks(HashSet<T> previous, HashSet<T> current, List<Action<T>> cbs)
                {
                    HashSet<T> diff = new();
                    foreach (T currentItem in current)
                    {
                        if (!previous.Contains(currentItem))
                        {
                            diff.Add(currentItem);
                        }
                    }
                    foreach (T item in diff)
                    {
                        cbs.ForEach(cb => cb(item));
                    }
                }

                ProcessCallbacks(previous, current, _addCbs);
                ProcessCallbacks(current, previous, _removeCbs);
            }
        }

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
    }
}
#nullable disable
