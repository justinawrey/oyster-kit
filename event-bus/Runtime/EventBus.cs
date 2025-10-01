using System;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;

namespace BlueOyster.EventBus
{
    public struct EventResult<GE> where GE : Enum
    {
        public GE Event;
        public object Arg;

        public T GetArg<T>()
        {
            return (T)Arg;
        }
    }

    public class EventBus<GE> where GE : Enum
    {
        private readonly Dictionary<GE, Delegate> eventMap = new();

        private void Subscribe<T>(GE e, Action<T> handler)
        {
            if (eventMap.TryGetValue(e, out Delegate existingHandler))
            {
                eventMap[e] = Delegate.Combine(existingHandler, handler);
                return;
            }

            eventMap[e] = handler;
        }

        private void Unsubscribe<T>(GE e, Action<T> handler)
        {
            if (eventMap.TryGetValue(e, out Delegate existingHandler))
            {
                var newDelegate = Delegate.Remove(existingHandler, handler);
                if (newDelegate != null)
                {
                    eventMap[e] = newDelegate;
                }
                else
                {
                    // If no more handlers, remove the event from the map
                    eventMap.Remove(e);
                }
            }
        }

        public UniTask WaitForEvent(GE e)
        {
            var tcs = new UniTaskCompletionSource();
            void handler(object arg)
            {
                Unsubscribe<object>(e, handler);
                tcs.TrySetResult();
            }

            Subscribe<object>(e, handler);
            return tcs.Task;
        }

        public UniTask<T> WaitForEvent<T>(GE e)
        {
            var tcs = new UniTaskCompletionSource<T>();
            void handler(object arg)
            {
                Unsubscribe<object>(e, handler);
                tcs.TrySetResult((T)arg);
            }

            Subscribe<object>(e, handler);
            return tcs.Task;
        }

        public UniTask<EventResult<GE>> WaitForEventOneOf(GE e1, GE e2)
        {
            var tcs = new UniTaskCompletionSource<EventResult<GE>>();
            void handlerE1(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                tcs.TrySetResult(new EventResult<GE> { Event = e1, Arg = arg });
            }

            void handlerE2(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                tcs.TrySetResult(new EventResult<GE> { Event = e2, Arg = arg });
            }

            Subscribe<object>(e1, handlerE1);
            Subscribe<object>(e2, handlerE2);
            return tcs.Task;
        }

        public UniTask<EventResult<GE>> WaitForEventOneOf(GE e1, GE e2, GE e3)
        {
            var tcs = new UniTaskCompletionSource<EventResult<GE>>();
            void handlerE1(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                Unsubscribe<object>(e3, handlerE3);
                tcs.TrySetResult(new EventResult<GE> { Event = e1, Arg = arg });
            }

            void handlerE2(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                Unsubscribe<object>(e3, handlerE3);
                tcs.TrySetResult(new EventResult<GE> { Event = e2, Arg = arg });
            }

            void handlerE3(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                Unsubscribe<object>(e3, handlerE3);
                tcs.TrySetResult(new EventResult<GE> { Event = e3, Arg = arg });
            }

            Subscribe<object>(e1, handlerE1);
            Subscribe<object>(e2, handlerE2);
            Subscribe<object>(e3, handlerE3);
            return tcs.Task;
        }

        public UniTask<EventResult<GE>> WaitForEventOneOf(GE e1, GE e2, GE e3, GE e4)
        {
            var tcs = new UniTaskCompletionSource<EventResult<GE>>();
            void handlerE1(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                Unsubscribe<object>(e3, handlerE3);
                Unsubscribe<object>(e4, handlerE4);
                tcs.TrySetResult(new EventResult<GE> { Event = e1, Arg = arg });
            }

            void handlerE2(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                Unsubscribe<object>(e3, handlerE3);
                Unsubscribe<object>(e4, handlerE4);
                tcs.TrySetResult(new EventResult<GE> { Event = e2, Arg = arg });
            }

            void handlerE3(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                Unsubscribe<object>(e3, handlerE3);
                Unsubscribe<object>(e4, handlerE4);
                tcs.TrySetResult(new EventResult<GE> { Event = e3, Arg = arg });
            }

            void handlerE4(object arg)
            {
                Unsubscribe<object>(e1, handlerE1);
                Unsubscribe<object>(e2, handlerE2);
                Unsubscribe<object>(e3, handlerE3);
                Unsubscribe<object>(e4, handlerE4);
                tcs.TrySetResult(new EventResult<GE> { Event = e4, Arg = arg });
            }

            Subscribe<object>(e1, handlerE1);
            Subscribe<object>(e2, handlerE2);
            Subscribe<object>(e3, handlerE3);
            Subscribe<object>(e4, handlerE4);
            return tcs.Task;
        }

        public void Trigger(GE e)
        {
            (eventMap[e] as Action<object>)?.Invoke(null);
        }

        public void Trigger<T>(GE e, T arg)
        {
            (eventMap[e] as Action<object>)?.Invoke(arg);
        }
    }
}

