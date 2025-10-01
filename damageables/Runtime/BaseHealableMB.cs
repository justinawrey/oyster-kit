using System;
using UnityEngine;

namespace BlueOyster.Damageables
{
    public abstract class BaseHealableMB : MonoBehaviour, IHealable
    {
        protected HealthMB health;

        protected void OnEnable()
        {
            health = GetComponentInParent<HealthMB>();
            if (health == null)
            {
                Debug.LogError("oops!", gameObject);
                throw new Exception("added an IHealable to a component without a HealthMB as a parent somewhere");
            }

            health.AddHealable(this);
        }

        protected void OnDisable()
        {
            health.RemoveHealable(this);
        }

        public abstract void OnHeal(HealHit hit);
    }
}