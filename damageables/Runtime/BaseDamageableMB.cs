using System;
using UnityEngine;

namespace BlueOyster.Damageables
{
    public abstract class BaseDamageableMB : MonoBehaviour, IDamageable
    {
        private HealthMB health;

        protected void OnEnable()
        {
            health = GetComponentInParent<HealthMB>();
            if (health == null)
            {
                Debug.LogError("oops!", gameObject);
                throw new Exception("added an IDamageable to a component without a HealthMB as a parent somewhere");
            }

            health.AddDamageable(this);
        }

        protected void OnDisable()
        {
            health.RemoveDamageable(this);
        }

        public abstract void OnDamage(DamageHit hit);
    }
}
