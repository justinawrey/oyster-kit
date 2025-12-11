using UnityEngine;
using BlueOyster.Singletons;

public class PopupTextController : NonScenePersistenSingleton<PopupTextController>
{
    [SerializeField]
    private PopupText popupText;

    private Camera mainCam;

    private void OnEnable()
    {
        mainCam = Camera.main;
    }

    public void ShowAtWorldPosition(string text, Vector3 worldPos)
    {
        // Project world position onto camera near plane
        // For orthographic camera, maintain x,y relative position but place at near plane distance
        // Vector3 nearPlaneCenter = mainCam.transform.position + mainCam.transform.forward * mainCam.nearClipPlane;

        // // Project the point onto the plane defined by the camera's forward vector
        // Vector3 toPoint = worldPos - mainCam.transform.position;
        // float distanceAlongForward = Vector3.Dot(toPoint, mainCam.transform.forward);
        // Vector3 projectedPos = worldPos - mainCam.transform.forward * (distanceAlongForward - mainCam.nearClipPlane);

        // TODO: bit of a hack...
        // projectedPos.z += 1f;

        var res = Instantiate(popupText, worldPos, Quaternion.identity, transform);
        res.Pin(text);
    }

    [ContextMenu("test table")]
    private void Test()
    {
        ShowAtWorldPosition("2", new Vector3(0, 0, 0));
    }

    [ContextMenu("test table 2")]
    private void Test2()
    {
        ShowAtWorldPosition("4", new Vector3(4, 0, 8));
    }
}
