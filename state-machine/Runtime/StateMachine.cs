using System;
using UnityEngine;
using StructuredLogger = BlueOyster.Logger;
using BlueOyster.Reactive;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace BlueOyster.StateMachine
{
    [ExecuteAlways]
    public class StateMachine : MonoBehaviour
    {
        private static StateMachine _instance = null;
        public static StateMachine Instance => _instance;

        [Header("Options")]
        [SerializeField] private StructuredLogger.Logger Logger;

        [SerializeField]
        private bool persistAcrossScenes = false;

        [NonSerialized]
        public Reactive<BaseStateMB> CurrentState = new(null);

        private BaseStateMB[] statesCache = null;

        protected void Awake()
        {
            if (!Application.isPlaying)
            {
                return;
            }

            if (_instance == null)
            {
                _instance = this;
                if (persistAcrossScenes)
                {
                    DontDestroyOnLoad(gameObject);
                }
                return;
            }

            if (_instance == this) return;
            Destroy(gameObject);
        }

        private void OnEnable()
        {
            if (!Application.isPlaying)
            {
                return;
            }

            CacheStates();

            if (CurrentState.Value != null)
            {
                CurrentState.Value.OnEnter();
            }
        }

        private void OnDisable()
        {
            if (CurrentState.Value != null)
            {
                CurrentState.Value.OnExit();
            }
        }

        private void Update()
        {
            if (!Application.isPlaying)
            {
                return;
            }

            CurrentState.Value.OnUpdate();
        }

        private void FixedUpdate()
        {
            if (!Application.isPlaying)
            {
                return;
            }

            CurrentState.Value.OnFixedUpdate();
        }


#if UNITY_EDITOR
        private void OnDestroy()
        {
            // not sure why this works but honestly fuck it
            if (EditorApplication.isPlaying || EditorApplication.isPlayingOrWillChangePlaymode)
            {
                return;
            }

            BaseStateMB[] states = GetComponents<BaseStateMB>();
            for (int i = 0; i < states.Length; i++)
            {
                DestroyImmediate(states[i]);
            }
            statesCache = null;
        }
#endif

        private void CacheStates()
        {
            statesCache = GetComponents<BaseStateMB>();
        }

        // dict would be faster but its too annoying to serialize,
        // this is negligible perf wise since we wont have a ton of states,
        // and way easier to implement
        public T GetState<T>() where T : BaseStateMB
        {
            return (T)GetState(typeof(T));
        }

        public BaseStateMB GetState(Type stateType)
        {
            if (statesCache == null)
            {
                CacheStates();
            }

            for (int i = 0; i < statesCache.Length; i++)
            {
                if (statesCache[i].GetType() == stateType)
                {
                    return statesCache[i];
                }
            }

            throw new System.Exception("state controller: no state of type " + stateType.Name);
        }

        // NOTE: initial state is set in GameMB~
        public void ChangeState<T>() where T : BaseStateMB
        {
            ChangeState(typeof(T));
        }

        public void ChangeState(Type stateType)
        {
            // The initial state is not set until the first call to ChangeState,
            // so currentState will be null on the first call
            CurrentState.Value?.OnExit();
            CurrentState.Value = GetState(stateType);
            CurrentState.Value.OnEnter();

            Logger.Info("entered " + CurrentState.Value.GetType().Name);
        }
    }

    [ExecuteAlways]
    public class StateMachine<T> : StateMachine
        where T : BaseStateMB
    {
        protected void OnEnable()
        {
            if (!gameObject.TryGetComponent(out T _))
            {
                gameObject.AddComponent<T>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2> : StateMachine<T1>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T2 _))
            {
                gameObject.AddComponent<T2>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3> : StateMachine<T1, T2>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T3 _))
            {
                gameObject.AddComponent<T3>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4> : StateMachine<T1, T2, T3>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T4 _))
            {
                gameObject.AddComponent<T4>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5> : StateMachine<T1, T2, T3, T4>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T5 _))
            {
                gameObject.AddComponent<T5>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6> : StateMachine<T1, T2, T3, T4, T5>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T6 _))
            {
                gameObject.AddComponent<T6>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7> : StateMachine<T1, T2, T3, T4, T5, T6>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T7 _))
            {
                gameObject.AddComponent<T7>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8> : StateMachine<T1, T2, T3, T4, T5, T6, T7>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T8 _))
            {
                gameObject.AddComponent<T8>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T9 _))
            {
                gameObject.AddComponent<T9>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T10 _))
            {
                gameObject.AddComponent<T10>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T11 _))
            {
                gameObject.AddComponent<T11>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T12 _))
            {
                gameObject.AddComponent<T12>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T13 _))
            {
                gameObject.AddComponent<T13>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
        where T14 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T14 _))
            {
                gameObject.AddComponent<T14>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
        where T14 : BaseStateMB
        where T15 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T15 _))
            {
                gameObject.AddComponent<T15>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
        where T14 : BaseStateMB
        where T15 : BaseStateMB
        where T16 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T16 _))
            {
                gameObject.AddComponent<T16>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
        where T14 : BaseStateMB
        where T15 : BaseStateMB
        where T16 : BaseStateMB
        where T17 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T17 _))
            {
                gameObject.AddComponent<T17>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
        where T14 : BaseStateMB
        where T15 : BaseStateMB
        where T16 : BaseStateMB
        where T17 : BaseStateMB
        where T18 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T18 _))
            {
                gameObject.AddComponent<T18>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
        where T14 : BaseStateMB
        where T15 : BaseStateMB
        where T16 : BaseStateMB
        where T17 : BaseStateMB
        where T18 : BaseStateMB
        where T19 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T19 _))
            {
                gameObject.AddComponent<T19>();
            }
        }
    }

    [ExecuteAlways]
    public class StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20> : StateMachine<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
        where T1 : BaseStateMB
        where T2 : BaseStateMB
        where T3 : BaseStateMB
        where T4 : BaseStateMB
        where T5 : BaseStateMB
        where T6 : BaseStateMB
        where T7 : BaseStateMB
        where T8 : BaseStateMB
        where T9 : BaseStateMB
        where T10 : BaseStateMB
        where T11 : BaseStateMB
        where T12 : BaseStateMB
        where T13 : BaseStateMB
        where T14 : BaseStateMB
        where T15 : BaseStateMB
        where T16 : BaseStateMB
        where T17 : BaseStateMB
        where T18 : BaseStateMB
        where T19 : BaseStateMB
        where T20 : BaseStateMB
    {
        protected new void OnEnable()
        {
            base.OnEnable();
            if (!gameObject.TryGetComponent(out T20 _))
            {
                gameObject.AddComponent<T20>();
            }
        }
    }
}
