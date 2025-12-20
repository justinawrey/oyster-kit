using System;
using System.Collections.Generic;
using BlueOyster.Reactive;
using UnityEngine;
using UnityEngine.EventSystems;

namespace BlueOyster.Damageables
{
    public struct DamageHit
    {
        public int HitDamage;
        public int PrevHealth;
        public int CurrHealth;
        public Vector3 HitDir;
        public int? MaxHealth;
        public GameObject SourceGameObject;
    }

    public struct HealHit
    {
        public int HealAmount;
        public int PrevHealth;
        public int CurrHealth;
        public int? MaxHealth;
    }

    public interface IDamageable : IEventSystemHandler
    {
        public void OnDamage(DamageHit hit);
    }

    public interface IHealable : IEventSystemHandler
    {
        public void OnHeal(HealHit hit);
    }

    public interface IKillable : IEventSystemHandler
    {
        // low number = higher priority
        public int Priority => 0;
        public void OnKill();
    }

    public class HealthMB : MonoBehaviour
    {
        // TODO: memory leak?
        public static Dictionary<Collider, HealthMB> Healths = new();

        [SerializeField]
        private Collider col;

        [SerializeField]
        private int maxHealth;

        [SerializeField]
        private int initialHealth;

        public bool MaxHealthUncapped = false;
        public Reactive<bool> Invulnerable = new(false);

        public List<IDamageable> damageables = new();
        public List<IHealable> healables = new();
        public List<IKillable> killables = new();

        [NonSerialized]
        public Reactive<int> CurrHealth = new(0);

        public Computed<bool> Dead = new();
        public Computed<float> CurrHealthPct = new();

        private Action unsub;
        private Action unsub2;

        private void OnEnable()
        {
            CurrHealth.Value = initialHealth;
            Healths[col] = this;

            unsub = Dead.React(CurrHealth, Invulnerable, (currHealth, invulnerable) =>
            {
                if (invulnerable)
                {
                    return false;
                }

                return currHealth <= 0;
            });

            unsub2 = CurrHealthPct.React(CurrHealth, (currHealth) =>
            {
                return (float)currHealth / maxHealth;
            });
        }

        private void OnDisable()
        {
            unsub?.Invoke();
            unsub2?.Invoke();
            damageables.Clear();
            killables.Clear();
            healables.Clear();
            Healths.Remove(col);
        }

        public void AddDamageable(IDamageable damageable)
        {
            damageables.Add(damageable);
        }

        public void RemoveDamageable(IDamageable damageable)
        {
            damageables.Remove(damageable);
        }

        public void AddHealable(IHealable healable)
        {
            healables.Add(healable);
        }

        public void RemoveHealable(IHealable healable)
        {
            healables.Remove(healable);
        }

        public void AddKillable(IKillable killable)
        {
            killables.Add(killable);
            killables.Sort((a, b) => a.Priority.CompareTo(b.Priority));
        }

        public void RemoveKillable(IKillable killable)
        {
            killables.Remove(killable);
        }

        public void ForceSetHealth(int health)
        {
            CurrHealth.Value = Mathf.Min(maxHealth, health);
        }

        public void ForceSetMaxHealth(int maxHealth)
        {
            this.maxHealth = maxHealth;
        }

        public void Heal(int amt)
        {
            int prevHealth = CurrHealth.Value;
            if (MaxHealthUncapped)
            {
                CurrHealth.Value += amt;
            }
            else
            {
                CurrHealth.Value = Mathf.Min(maxHealth, CurrHealth.Value + amt);
            }

            for (int i = 0; i < healables.Count; i++)
            {
                healables[i].OnHeal(
                    new HealHit()
                    {
                        HealAmount = amt,
                        PrevHealth = prevHealth,
                        CurrHealth = CurrHealth.Value,
                        MaxHealth = maxHealth,
                    }
                );
            }
        }

        public void TakeDamage(int amt, GameObject sourceGo)
        {
            amt = Invulnerable.Value ? 0 : amt;
            int prevHealth = CurrHealth.Value;
            CurrHealth.Value = Mathf.Max(0, CurrHealth.Value - amt);

            for (int i = 0; i < damageables.Count; i++)
            {
                damageables[i].OnDamage(
                    new DamageHit()
                    {
                        HitDamage = amt,
                        PrevHealth = prevHealth,
                        CurrHealth = CurrHealth.Value,
                        MaxHealth = maxHealth,
                        SourceGameObject = sourceGo,
                    }
                );
            }

            if (CurrHealth.Value <= 0)
            {
                for (int i = 0; i < killables.Count; i++)
                {
                    killables[i].OnKill();
                }
            }
        }
    }
}
