using Cysharp.Threading.Tasks;
using Singletons;
using BlueOyster.EventBus;
using System;
using BlueOyster.Stores;
using UnityEngine;

namespace BlueOyster.SceneBooter
{
    public enum StartupHook
    {
        Awake,
        Enable,
        Start
    }

    public interface IBooterConfig<E> where E : Enum
    {
        public EventBus<E> EventBus { get; }
    }

    public abstract class SceneBooter<T, E> : NonScenePersistenSingleton<SceneBooter<T, E>>
        where T : IBooterConfig<E>
        where E : Enum
    {
        public StartupHook Hook = StartupHook.Start;
        public T Context;

        protected void OnEnable()
        {
            if (Hook != StartupHook.Enable) return;
            Run(Context).Forget();
        }

        protected new void Awake()
        {
            base.Awake();
            if (Hook != StartupHook.Awake) return;
            Run(Context).Forget();
        }

        protected void Start()
        {
            if (Hook != StartupHook.Start) return;
            Run(Context).Forget();
        }

        protected abstract UniTask Run(T config);
    }

    public abstract class SceneBooter<T, E, S1> : SceneBooter<T, E>
        where T : IBooterConfig<E>
        where E : Enum
        where S1 : Store
    {
        [HideInInspector]
        public S1 Store1;

        protected new void OnEnable()
        {
            Store1 = Store.Get<S1>();
            base.OnEnable();
        }

        private void OnApplicationPause()
        {
            SaveSync();
        }

        private void OnApplicationFocus()
        {
            SaveSync();
        }

        private void OnApplicationQuit()
        {
            SaveSync();
        }

        private void SaveSync()
        {
            if (Application.isEditor)
            {
                return;
            }

            Store.PersistToDiskSync(Store1);
        }
    }

    public abstract class SceneBooter<T, E, S1, S2> : SceneBooter<T, E>
        where T : IBooterConfig<E>
        where E : Enum
        where S1 : Store
        where S2 : Store
    {
        [HideInInspector]
        public S1 Store1;

        [HideInInspector]
        public S2 Store2;

        protected new void OnEnable()
        {
            Store1 = Store.Get<S1>();
            Store2 = Store.Get<S2>();
            base.OnEnable();
        }

        private void OnApplicationPause()
        {
            SaveSync();
        }

        private void OnApplicationFocus()
        {
            SaveSync();
        }

        private void OnApplicationQuit()
        {
            SaveSync();
        }

        private void SaveSync()
        {
            if (Application.isEditor)
            {
                return;
            }

            Store.PersistToDiskSync(Store1);
            Store.PersistToDiskSync(Store2);
        }
    }

    public abstract class SceneBooter<T, E, S1, S2, S3> : SceneBooter<T, E>
        where T : IBooterConfig<E>
        where E : Enum
        where S1 : Store
        where S2 : Store
        where S3 : Store
    {
        [HideInInspector]
        public S1 Store1;

        [HideInInspector]
        public S2 Store2;

        [HideInInspector]
        public S3 Store3;

        protected new void OnEnable()
        {
            Store1 = Store.Get<S1>();
            Store2 = Store.Get<S2>();
            Store3 = Store.Get<S3>();
            base.OnEnable();
        }

        private void OnApplicationPause()
        {
            SaveSync();
        }

        private void OnApplicationFocus()
        {
            SaveSync();
        }

        private void OnApplicationQuit()
        {
            SaveSync();
        }

        private void SaveSync()
        {
            if (Application.isEditor)
            {
                return;
            }

            Store.PersistToDiskSync(Store1);
            Store.PersistToDiskSync(Store2);
            Store.PersistToDiskSync(Store3);
        }
    }

    public abstract class SceneBooter<T, E, S1, S2, S3, S4> : SceneBooter<T, E>
        where T : IBooterConfig<E>
        where E : Enum
        where S1 : Store
        where S2 : Store
        where S3 : Store
        where S4 : Store
    {
        [HideInInspector]
        public S1 Store1;

        [HideInInspector]
        public S2 Store2;

        [HideInInspector]
        public S3 Store3;

        [HideInInspector]
        public S4 Store4;

        protected new void OnEnable()
        {
            Store1 = Store.Get<S1>();
            Store2 = Store.Get<S2>();
            Store3 = Store.Get<S3>();
            Store4 = Store.Get<S4>();
            base.OnEnable();
        }

        private void OnApplicationPause()
        {
            SaveSync();
        }

        private void OnApplicationFocus()
        {
            SaveSync();
        }

        private void OnApplicationQuit()
        {
            SaveSync();
        }

        private void SaveSync()
        {
            if (Application.isEditor)
            {
                return;
            }

            Store.PersistToDiskSync(Store1);
            Store.PersistToDiskSync(Store2);
            Store.PersistToDiskSync(Store3);
            Store.PersistToDiskSync(Store4);
        }
    }

    public abstract class SceneBooter<T, E, S1, S2, S3, S4, S5> : SceneBooter<T, E>
        where T : IBooterConfig<E>
        where E : Enum
        where S1 : Store
        where S2 : Store
        where S3 : Store
        where S4 : Store
        where S5 : Store
    {
        [HideInInspector]
        public S1 Store1;

        [HideInInspector]
        public S2 Store2;

        [HideInInspector]
        public S3 Store3;

        [HideInInspector]
        public S4 Store4;

        [HideInInspector]
        public S5 Store5;

        protected new void OnEnable()
        {
            Store1 = Store.Get<S1>();
            Store2 = Store.Get<S2>();
            Store3 = Store.Get<S3>();
            Store4 = Store.Get<S4>();
            Store5 = Store.Get<S5>();
            base.OnEnable();
        }

        private void OnApplicationPause()
        {
            SaveSync();
        }

        private void OnApplicationFocus()
        {
            SaveSync();
        }

        private void OnApplicationQuit()
        {
            SaveSync();
        }

        private void SaveSync()
        {
            if (Application.isEditor)
            {
                return;
            }

            Store.PersistToDiskSync(Store1);
            Store.PersistToDiskSync(Store2);
            Store.PersistToDiskSync(Store3);
            Store.PersistToDiskSync(Store4);
            Store.PersistToDiskSync(Store5);
        }
    }

    public abstract class SceneBooter<T, E, S1, S2, S3, S4, S5, S6> : SceneBooter<T, E>
        where T : IBooterConfig<E>
        where E : Enum
        where S1 : Store
        where S2 : Store
        where S3 : Store
        where S4 : Store
        where S5 : Store
        where S6 : Store
    {
        [HideInInspector]
        public S1 Store1;

        [HideInInspector]
        public S2 Store2;

        [HideInInspector]
        public S3 Store3;

        [HideInInspector]
        public S4 Store4;

        [HideInInspector]
        public S5 Store5;

        [HideInInspector]
        public S6 Store6;

        protected new void OnEnable()
        {
            Store1 = Store.Get<S1>();
            Store2 = Store.Get<S2>();
            Store3 = Store.Get<S3>();
            Store4 = Store.Get<S4>();
            Store5 = Store.Get<S5>();
            Store6 = Store.Get<S6>();
            base.OnEnable();
        }

        private void OnApplicationPause()
        {
            SaveSync();
        }

        private void OnApplicationFocus()
        {
            SaveSync();
        }

        private void OnApplicationQuit()
        {
            SaveSync();
        }

        private void SaveSync()
        {
            if (Application.isEditor)
            {
                return;
            }

            Store.PersistToDiskSync(Store1);
            Store.PersistToDiskSync(Store2);
            Store.PersistToDiskSync(Store3);
            Store.PersistToDiskSync(Store4);
            Store.PersistToDiskSync(Store5);
            Store.PersistToDiskSync(Store6);
        }
    }
}