using BlueOyster.Singletons;
using Steamworks;
using UnityEngine;

namespace BlueOyster.SteamClient
{
  public class SteamManager : ScenePersistentSingleton<SteamManager>
  {
    private static SteamConfiguration _configuration;

    private void Awake()
    {
      _configuration = Resources.Load<SteamConfiguration>("steam-configuration");
      if (_configuration == null)
      {
        Debug.LogWarning("SteamManager: could not find steam configuration.  Create one at Resources/steam-configuration.");
        return;
      }

      try
      {
        SteamClient.Init((uint)_configuration.SteamAppId);
      }
      catch (System.Exception e)
      {
        print(e);
        return;
      }
    }

    private void Update()
    {
      if (_configuration == null)
      {
        return;
      }

      SteamClient.RunCallbacks();
    }

    private void OnDestroy()
    {
      if (_configuration == null)
      {
        return;
      }

      SteamClient.Shutdown();
    }
  }
}