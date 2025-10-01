using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.Damageables
{
    public struct DamageHit
    {
        public int HitDamage;
        public int PrevHealth;
        public int CurrHealth;
        public int? MaxHealth;
        public Vector3? CollisionPoint;
    }

    public struct HealHit
    {
        public int HealAmount;
        public int PrevHealth;
        public int CurrHealth;
        public int? MaxHealth;
    }

    public interface IDamageable
    {
        public void OnDamage(DamageHit hit);
    }

    public interface IHealable
    {
        public void OnHeal(HealHit hit);
    }

    public interface IKillable
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

        public bool Invulnerable = false;
        public bool MaxHealthUncapped = false;

        public List<IDamageable> damageables = new();
        public List<IHealable> healables = new();
        public List<IKillable> killables = new();

        private int currHealth;
        public int CurrHealth => currHealth;

        private void OnEnable()
        {
            currHealth = initialHealth;
            Healths[col] = this;
        }

        private void OnDisable()
        {
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
            currHealth = Mathf.Min(maxHealth, health);
        }

        public void ForceSetMaxHealth(int maxHealth)
        {
            this.maxHealth = maxHealth;
        }

        public void Heal(int amt)
        {
            int prevHealth = currHealth;
            if (MaxHealthUncapped)
            {
                currHealth += amt;
            }
            else
            {
                currHealth = Mathf.Min(maxHealth, currHealth + amt);
            }

            for (int i = 0; i < healables.Count; i++)
            {
                healables[i].OnHeal(
                    new HealHit()
                    {
                        HealAmount = amt,
                        PrevHealth = prevHealth,
                        CurrHealth = currHealth,
                        MaxHealth = maxHealth,
                    }
                );
            }
        }

        public void TakeDamage(int amt, Vector3? collisionPoint = null)
        {
            amt = Invulnerable ? 0 : amt;
            int prevHealth = currHealth;
            currHealth = Mathf.Max(0, currHealth - amt);

            for (int i = 0; i < damageables.Count; i++)
            {
                damageables[i].OnDamage(
                    new DamageHit()
                    {
                        HitDamage = amt,
                        PrevHealth = prevHealth,
                        CurrHealth = currHealth,
                        MaxHealth = maxHealth,
                        CollisionPoint = collisionPoint,
                    }
                );
            }

            if (currHealth <= 0)
            {
                for (int i = 0; i < killables.Count; i++)
                {
                    killables[i].OnKill();
                }
            }
        }
    }
}
