using UnityEngine;

[ExecuteAlways]
public class Billboard : MonoBehaviour
{
    private Camera mainCam;

    private void OnEnable()
    {
        mainCam = Camera.main;
    }

    private void Update()
    {
        transform.forward = mainCam.transform.forward;
    }
}