#nullable enable
using System;
using UnityEngine;

namespace BlueOyster.Reactive
{
    [Serializable]
    public class Computed<TOut> : ReactiveBase<TOut>
    {
        private Action? _unsub = null;

        public Action React<TIn1>(IReactiveCallbackOwner<TIn1?> tracked, Func<TIn1?, TOut> cb)
        {
            Set(cb(tracked.Value));
            return CacheUnsubCb(tracked.OnChange(curr => Set(cb(curr))));
        }

        private Action CacheUnsubCb(Action unsub)
        {
            if (_unsub != null)
            {
                _unsub();
                Debug.LogWarning(
                    "reactive-unity (computed): computed variable unsubscribe hooks have been overwritten.  Did you call 'React' twice?"
                );
            }
            _unsub = unsub;
            return _unsub;
        }

        public Action React<TIn1, TIn2>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            Func<TIn1?, TIn2?, TOut> cb
        )
        {
            Set(cb(tracked1.Value, tracked2.Value));

            Action unsub1 = tracked1.OnChange(curr => Set(cb(curr, tracked2.Value)));
            Action unsub2 = tracked2.OnChange(curr => Set(cb(tracked1.Value, curr)));

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
            });
        }

        public Action React<TIn1, TIn2, TIn3>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            Func<TIn1?, TIn2?, TIn3?, TOut> cb
        )
        {
            Set(cb(tracked1.Value, tracked2.Value, tracked3.Value));

            Action unsub1 = tracked1.OnChange(curr =>
                Set(cb(curr, tracked2.Value, tracked3.Value))
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(cb(tracked1.Value, curr, tracked3.Value))
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(cb(tracked1.Value, tracked2.Value, curr))
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
            });
        }

        public Action React<TIn1, TIn2, TIn3, TIn4>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            IReactiveCallbackOwner<TIn4> tracked4,
            Func<TIn1?, TIn2?, TIn3?, TIn4?, TOut> cb
        )
        {
            Set(cb(tracked1.Value, tracked2.Value, tracked3.Value, tracked4.Value));

            Action unsub1 = tracked1.OnChange(curr =>
                Set(cb(curr, tracked2.Value, tracked3.Value, tracked4.Value))
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(cb(tracked1.Value, curr, tracked3.Value, tracked4.Value))
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(cb(tracked1.Value, tracked2.Value, curr, tracked4.Value))
            );
            Action unsub4 = tracked4.OnChange(curr =>
                Set(cb(tracked1.Value, tracked2.Value, tracked3.Value, curr))
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
                unsub4();
            });
        }

        public Action React<TIn1, TIn2, TIn3, TIn4, TIn5>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            IReactiveCallbackOwner<TIn4?> tracked4,
            IReactiveCallbackOwner<TIn5?> tracked5,
            Func<TIn1?, TIn2?, TIn3?, TIn4?, TIn5?, TOut> cb
        )
        {
            Set(cb(tracked1.Value, tracked2.Value, tracked3.Value, tracked4.Value, tracked5.Value));

            Action unsub1 = tracked1.OnChange(curr =>
                Set(cb(curr, tracked2.Value, tracked3.Value, tracked4.Value, tracked5.Value))
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(cb(tracked1.Value, curr, tracked3.Value, tracked4.Value, tracked5.Value))
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(cb(tracked1.Value, tracked2.Value, curr, tracked4.Value, tracked5.Value))
            );
            Action unsub4 = tracked4.OnChange(curr =>
                Set(cb(tracked1.Value, tracked2.Value, tracked3.Value, curr, tracked5.Value))
            );
            Action unsub5 = tracked5.OnChange(curr =>
                Set(cb(tracked1.Value, tracked2.Value, tracked3.Value, tracked4.Value, curr))
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
                unsub4();
                unsub5();
            });
        }

        public Action React<TIn1, TIn2, TIn3, TIn4, TIn5, TIn6>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            IReactiveCallbackOwner<TIn4?> tracked4,
            IReactiveCallbackOwner<TIn5?> tracked5,
            IReactiveCallbackOwner<TIn6?> tracked6,
            Func<TIn1?, TIn2?, TIn3?, TIn4?, TIn5?, TIn6?, TOut> cb
        )
        {
            Set(
                cb(
                    tracked1.Value,
                    tracked2.Value,
                    tracked3.Value,
                    tracked4.Value,
                    tracked5.Value,
                    tracked6.Value
                )
            );

            Action unsub1 = tracked1.OnChange(curr =>
                Set(
                    cb(
                        curr,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value
                    )
                )
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        curr,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value
                    )
                )
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        curr,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value
                    )
                )
            );
            Action unsub4 = tracked4.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        curr,
                        tracked5.Value,
                        tracked6.Value
                    )
                )
            );
            Action unsub5 = tracked5.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        curr,
                        tracked6.Value
                    )
                )
            );
            Action unsub6 = tracked6.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        curr
                    )
                )
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
                unsub4();
                unsub5();
                unsub6();
            });
        }

        public Action React<TIn1, TIn2, TIn3, TIn4, TIn5, TIn6, TIn7>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            IReactiveCallbackOwner<TIn4?> tracked4,
            IReactiveCallbackOwner<TIn5?> tracked5,
            IReactiveCallbackOwner<TIn6?> tracked6,
            IReactiveCallbackOwner<TIn7?> tracked7,
            Func<TIn1?, TIn2?, TIn3?, TIn4?, TIn5?, TIn6?, TIn7?, TOut> cb
        )
        {
            Set(
                cb(
                    tracked1.Value,
                    tracked2.Value,
                    tracked3.Value,
                    tracked4.Value,
                    tracked5.Value,
                    tracked6.Value,
                    tracked7.Value
                )
            );

            Action unsub1 = tracked1.OnChange(curr =>
                Set(
                    cb(
                        curr,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value
                    )
                )
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        curr,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value
                    )
                )
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        curr,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value
                    )
                )
            );
            Action unsub4 = tracked4.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        curr,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value
                    )
                )
            );
            Action unsub5 = tracked5.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        curr,
                        tracked6.Value,
                        tracked7.Value
                    )
                )
            );
            Action unsub6 = tracked6.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        curr,
                        tracked7.Value
                    )
                )
            );

            Action unsub7 = tracked7.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        curr
                    )
                )
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
                unsub4();
                unsub5();
                unsub6();
                unsub7();
            });
        }

        public Action React<TIn1, TIn2, TIn3, TIn4, TIn5, TIn6, TIn7, TIn8>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            IReactiveCallbackOwner<TIn4?> tracked4,
            IReactiveCallbackOwner<TIn5?> tracked5,
            IReactiveCallbackOwner<TIn6?> tracked6,
            IReactiveCallbackOwner<TIn7?> tracked7,
            IReactiveCallbackOwner<TIn8?> tracked8,
            Func<TIn1?, TIn2?, TIn3?, TIn4?, TIn5?, TIn6?, TIn7?, TIn8?, TOut> cb
        )
        {
            Set(
                cb(
                    tracked1.Value,
                    tracked2.Value,
                    tracked3.Value,
                    tracked4.Value,
                    tracked5.Value,
                    tracked6.Value,
                    tracked7.Value,
                    tracked8.Value
                )
            );

            Action unsub1 = tracked1.OnChange(curr =>
                Set(
                    cb(
                        curr,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value
                    )
                )
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        curr,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value
                    )
                )
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        curr,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value
                    )
                )
            );
            Action unsub4 = tracked4.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        curr,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value
                    )
                )
            );
            Action unsub5 = tracked5.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        curr,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value
                    )
                )
            );
            Action unsub6 = tracked6.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        curr,
                        tracked7.Value,
                        tracked8.Value
                    )
                )
            );

            Action unsub7 = tracked7.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        curr,
                        tracked8.Value
                    )
                )
            );

            Action unsub8 = tracked8.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        curr
                    )
                )
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
                unsub4();
                unsub5();
                unsub6();
                unsub7();
                unsub8();
            });
        }

        public Action React<TIn1, TIn2, TIn3, TIn4, TIn5, TIn6, TIn7, TIn8, TIn9>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            IReactiveCallbackOwner<TIn4?> tracked4,
            IReactiveCallbackOwner<TIn5?> tracked5,
            IReactiveCallbackOwner<TIn6?> tracked6,
            IReactiveCallbackOwner<TIn7?> tracked7,
            IReactiveCallbackOwner<TIn8?> tracked8,
            IReactiveCallbackOwner<TIn9?> tracked9,
            Func<TIn1?, TIn2?, TIn3?, TIn4?, TIn5?, TIn6?, TIn7?, TIn8?, TIn9?, TOut> cb
        )
        {
            Set(
                cb(
                    tracked1.Value,
                    tracked2.Value,
                    tracked3.Value,
                    tracked4.Value,
                    tracked5.Value,
                    tracked6.Value,
                    tracked7.Value,
                    tracked8.Value,
                    tracked9.Value
                )
            );

            Action unsub1 = tracked1.OnChange(curr =>
                Set(
                    cb(
                        curr,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value
                    )
                )
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        curr,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value
                    )
                )
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        curr,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value
                    )
                )
            );
            Action unsub4 = tracked4.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        curr,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value
                    )
                )
            );
            Action unsub5 = tracked5.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        curr,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value
                    )
                )
            );
            Action unsub6 = tracked6.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        curr,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value
                    )
                )
            );

            Action unsub7 = tracked7.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        curr,
                        tracked8.Value,
                        tracked9.Value
                    )
                )
            );

            Action unsub8 = tracked8.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        curr,
                        tracked9.Value
                    )
                )
            );

            Action unsub9 = tracked9.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        curr
                    )
                )
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
                unsub4();
                unsub5();
                unsub6();
                unsub7();
                unsub8();
                unsub9();
            });
        }

        public Action React<TIn1, TIn2, TIn3, TIn4, TIn5, TIn6, TIn7, TIn8, TIn9, TIn10>(
            IReactiveCallbackOwner<TIn1?> tracked1,
            IReactiveCallbackOwner<TIn2?> tracked2,
            IReactiveCallbackOwner<TIn3?> tracked3,
            IReactiveCallbackOwner<TIn4?> tracked4,
            IReactiveCallbackOwner<TIn5?> tracked5,
            IReactiveCallbackOwner<TIn6?> tracked6,
            IReactiveCallbackOwner<TIn7?> tracked7,
            IReactiveCallbackOwner<TIn8?> tracked8,
            IReactiveCallbackOwner<TIn9?> tracked9,
            IReactiveCallbackOwner<TIn10?> tracked10,
            Func<TIn1?, TIn2?, TIn3?, TIn4?, TIn5?, TIn6?, TIn7?, TIn8?, TIn9?, TIn10?, TOut> cb
        )
        {
            Set(
                cb(
                    tracked1.Value,
                    tracked2.Value,
                    tracked3.Value,
                    tracked4.Value,
                    tracked5.Value,
                    tracked6.Value,
                    tracked7.Value,
                    tracked8.Value,
                    tracked9.Value,
                    tracked10.Value
                )
            );

            Action unsub1 = tracked1.OnChange(curr =>
                Set(
                    cb(
                        curr,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );
            Action unsub2 = tracked2.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        curr,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );
            Action unsub3 = tracked3.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        curr,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );
            Action unsub4 = tracked4.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        curr,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );
            Action unsub5 = tracked5.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        curr,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );
            Action unsub6 = tracked6.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        curr,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );

            Action unsub7 = tracked7.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        curr,
                        tracked8.Value,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );

            Action unsub8 = tracked8.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        curr,
                        tracked9.Value,
                        tracked10.Value
                    )
                )
            );

            Action unsub9 = tracked9.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        curr,
                        tracked10.Value
                    )
                )
            );

            Action unsub10 = tracked10.OnChange(curr =>
                Set(
                    cb(
                        tracked1.Value,
                        tracked2.Value,
                        tracked3.Value,
                        tracked4.Value,
                        tracked5.Value,
                        tracked6.Value,
                        tracked7.Value,
                        tracked8.Value,
                        tracked9.Value,
                        curr
                    )
                )
            );

            return CacheUnsubCb(() =>
            {
                unsub1();
                unsub2();
                unsub3();
                unsub4();
                unsub5();
                unsub6();
                unsub7();
                unsub8();
                unsub9();
                unsub10();
            });
        }
    }
}
#nullable disable
