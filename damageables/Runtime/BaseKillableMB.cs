using System;
using UnityEngine;

namespace BlueOyster.Damageables
{
    public abstract class BaseKillableMB : MonoBehaviour, IKillable
    {
        private HealthMB health;

        protected void OnEnable()
        {
            health = GetComponentInParent<HealthMB>();
            if (health == null)
            {
                Debug.LogError("oops!", gameObject);
                throw new Exception("added an IKillable to a component without a HealthMB as a parent somewhere");
            }

            health.AddKillable(this);
        }

        protected void OnDisable()
        {
            health.RemoveKillable(this);
        }

        public abstract void OnKill();
        public virtual int Priority => 0;
    }
}
