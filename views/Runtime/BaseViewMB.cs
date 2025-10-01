using UnityEngine;
using System;
using BlueOyster.Reactive;
using BlueOyster.Stores;

namespace BlueOyster.Views
{
    public abstract class BaseViewMB<T> : MonoBehaviour where T : Store
{
    protected T SourceStore;

    protected void OnEnable()
    {
        SourceStore = Store.Get<T>();
    }

    [SerializeField]
    protected bool runCbOnEnable = true;

    [SerializeField]
    protected bool runCbOnStart = false;
}

public abstract class BaseViewMB<T, P> : BaseViewMB<T> where T : Store
{
    protected Action unsub;

    protected new void OnEnable()
    {
        base.OnEnable();
        unsub = Property.OnChange(OnChange);

        if (runCbOnEnable)
        {
            OnChange(Property.Value);
        }
    }

    protected void Start()
    {
        if (runCbOnStart)
        {
            OnChange(Property.Value);
        }
    }

    protected void OnDisable()
    {
        unsub?.Invoke();
    }

    protected abstract void OnChange(P value);
    protected abstract ReactiveBase<P> Property { get; }
}

public abstract class BaseViewMB<T, P1, P2> : BaseViewMB<T> where T : Store
{
    protected Action unsub;
    protected Action unsub2;

    protected new void OnEnable()
    {
        base.OnEnable();
        unsub = Property1.OnChange(OnChangeProperty1);
        unsub2 = Property2.OnChange(OnChangeProperty2);

        if (runCbOnEnable)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
        }
    }

    protected void Start()
    {
        if (runCbOnStart)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
        }
    }

    protected void OnDisable()
    {
        unsub?.Invoke();
        unsub2?.Invoke();
    }

    protected abstract void OnChangeProperty1(P1 value);
    protected abstract ReactiveBase<P1> Property1 { get; }

    protected abstract void OnChangeProperty2(P2 value);
    protected abstract ReactiveBase<P2> Property2 { get; }
}

public abstract class BaseViewMB<T, P1, P2, P3> : BaseViewMB<T> where T : Store
{
    protected Action unsub1;
    protected Action unsub2;
    protected Action unsub3;

    protected new void OnEnable()
    {
        base.OnEnable();
        unsub1 = Property1.OnChange(OnChangeProperty1);
        unsub2 = Property2.OnChange(OnChangeProperty2);
        unsub3 = Property3.OnChange(OnChangeProperty3);

        if (runCbOnEnable)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
        }
    }

    protected void Start()
    {
        if (runCbOnStart)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
        }
    }

    protected void OnDisable()
    {
        unsub1?.Invoke();
        unsub2?.Invoke();
        unsub3?.Invoke();
    }

    protected abstract void OnChangeProperty1(P1 value);
    protected abstract ReactiveBase<P1> Property1 { get; }

    protected abstract void OnChangeProperty2(P2 value);
    protected abstract ReactiveBase<P2> Property2 { get; }

    protected abstract void OnChangeProperty3(P3 value);
    protected abstract ReactiveBase<P3> Property3 { get; }
}

public abstract class BaseViewMB<T, P1, P2, P3, P4> : BaseViewMB<T> where T : Store
{
    protected Action unsub1;
    protected Action unsub2;
    protected Action unsub3;
    protected Action unsub4;

    protected new void OnEnable()
    {
        base.OnEnable();
        unsub1 = Property1.OnChange(OnChangeProperty1);
        unsub2 = Property2.OnChange(OnChangeProperty2);
        unsub3 = Property3.OnChange(OnChangeProperty3);
        unsub4 = Property4.OnChange(OnChangeProperty4);

        if (runCbOnEnable)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
            OnChangeProperty4(Property4.Value);
        }
    }

    protected void Start()
    {
        if (runCbOnStart)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
            OnChangeProperty4(Property4.Value);
        }
    }

    protected void OnDisable()
    {
        unsub1?.Invoke();
        unsub2?.Invoke();
        unsub3?.Invoke();
        unsub4?.Invoke();
    }

    protected abstract void OnChangeProperty1(P1 value);
    protected abstract ReactiveBase<P1> Property1 { get; }

    protected abstract void OnChangeProperty2(P2 value);
    protected abstract ReactiveBase<P2> Property2 { get; }

    protected abstract void OnChangeProperty3(P3 value);
    protected abstract ReactiveBase<P3> Property3 { get; }

    protected abstract void OnChangeProperty4(P4 value);
    protected abstract ReactiveBase<P4> Property4 { get; }
}

public abstract class BaseViewMB<T, P1, P2, P3, P4, P5> : BaseViewMB<T> where T : Store
{
    protected Action unsub1;
    protected Action unsub2;
    protected Action unsub3;
    protected Action unsub4;
    protected Action unsub5;

    protected new void OnEnable()
    {
        base.OnEnable();
        unsub1 = Property1.OnChange(OnChangeProperty1);
        unsub2 = Property2.OnChange(OnChangeProperty2);
        unsub3 = Property3.OnChange(OnChangeProperty3);
        unsub4 = Property4.OnChange(OnChangeProperty4);
        unsub5 = Property5.OnChange(OnChangeProperty5);

        if (runCbOnEnable)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
            OnChangeProperty4(Property4.Value);
            OnChangeProperty5(Property5.Value);
        }
    }

    protected void Start()
    {
        if (runCbOnStart)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
            OnChangeProperty4(Property4.Value);
            OnChangeProperty5(Property5.Value);
        }
    }

    protected void OnDisable()
    {
        unsub1?.Invoke();
        unsub2?.Invoke();
        unsub3?.Invoke();
        unsub4?.Invoke();
        unsub5?.Invoke();
    }

    protected abstract void OnChangeProperty1(P1 value);
    protected abstract ReactiveBase<P1> Property1 { get; }

    protected abstract void OnChangeProperty2(P2 value);
    protected abstract ReactiveBase<P2> Property2 { get; }

    protected abstract void OnChangeProperty3(P3 value);
    protected abstract ReactiveBase<P3> Property3 { get; }

    protected abstract void OnChangeProperty4(P4 value);
    protected abstract ReactiveBase<P4> Property4 { get; }

    protected abstract void OnChangeProperty5(P5 value);
    protected abstract ReactiveBase<P5> Property5 { get; }
}

public abstract class BaseViewMB<T, P1, P2, P3, P4, P5, P6> : BaseViewMB<T> where T : Store
{
    protected Action unsub1;
    protected Action unsub2;
    protected Action unsub3;
    protected Action unsub4;
    protected Action unsub5;
    protected Action unsub6;

    protected new void OnEnable()
    {
        base.OnEnable();
        unsub1 = Property1.OnChange(OnChangeProperty1);
        unsub2 = Property2.OnChange(OnChangeProperty2);
        unsub3 = Property3.OnChange(OnChangeProperty3);
        unsub4 = Property4.OnChange(OnChangeProperty4);
        unsub5 = Property5.OnChange(OnChangeProperty5);
        unsub6 = Property6.OnChange(OnChangeProperty6);

        if (runCbOnEnable)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
            OnChangeProperty4(Property4.Value);
            OnChangeProperty5(Property5.Value);
            OnChangeProperty6(Property6.Value);
        }
    }

    protected void Start()
    {
        if (runCbOnStart)
        {
            OnChangeProperty1(Property1.Value);
            OnChangeProperty2(Property2.Value);
            OnChangeProperty3(Property3.Value);
            OnChangeProperty4(Property4.Value);
            OnChangeProperty5(Property5.Value);
            OnChangeProperty6(Property6.Value);
        }
    }

    protected void OnDisable()
    {
        unsub1?.Invoke();
        unsub2?.Invoke();
        unsub3?.Invoke();
        unsub4?.Invoke();
        unsub5?.Invoke();
        unsub6?.Invoke();
    }

    protected abstract void OnChangeProperty1(P1 value);
    protected abstract ReactiveBase<P1> Property1 { get; }

    protected abstract void OnChangeProperty2(P2 value);
    protected abstract ReactiveBase<P2> Property2 { get; }

    protected abstract void OnChangeProperty3(P3 value);
    protected abstract ReactiveBase<P3> Property3 { get; }

    protected abstract void OnChangeProperty4(P4 value);
    protected abstract ReactiveBase<P4> Property4 { get; }

    protected abstract void OnChangeProperty5(P5 value);
    protected abstract ReactiveBase<P5> Property5 { get; }

    protected abstract void OnChangeProperty6(P6 value);
    protected abstract ReactiveBase<P6> Property6 { get; }
    }
}
