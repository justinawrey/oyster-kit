#nullable enable
using System;

namespace BlueOyster.Reactive
{
    public interface IReactiveCallbackOwner<T>
    {
        public Action OnChange(Action<T?> cb);
        public T? Value { get; }
    }
}

#nullable disable
