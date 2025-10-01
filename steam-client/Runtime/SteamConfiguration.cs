using UnityEngine;

namespace BlueOyster.SteamClient
{
  [CreateAssetMenu(fileName = "steam-configuration", menuName = "Steam Management/Steam Configuration")]
  public class SteamConfiguration : ScriptableObject
  {
    public int SteamAppId;
  }
}