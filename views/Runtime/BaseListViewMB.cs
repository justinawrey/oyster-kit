using UnityEngine;
using StoreLib = BlueOyster.Stores;
using System;
using BlueOyster.Reactive;

namespace BlueOyster.Views
{
    public abstract class BaseListViewMB<T, P> : MonoBehaviour where T : StoreLib.Store
{
    protected T Store;

    private Action unsubAdd;
    private Action unsubRemove;

    private void OnEnable()
    {
        Store = StoreLib.Store.Get<T>();

        unsubAdd = ListProperty.OnAdd(OnAdd);
        unsubRemove = ListProperty.OnRemove(OnRemove);

        for (int i = 0; i < ListProperty.Count; i++)
        {
            OnAdd(ListProperty[i]);
        }
    }

    private void OnDisable()
    {
        unsubAdd();
        unsubRemove();
    }

    protected abstract void OnAdd(P value);
    protected abstract void OnRemove(P value);
    protected abstract ReactiveList<P> ListProperty { get; }
    }
}