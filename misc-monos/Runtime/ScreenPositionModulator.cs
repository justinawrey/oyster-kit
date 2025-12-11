using UnityEngine;
using Unity.Cinemachine;
using UnityEngine.InputSystem;
using Unity.Mathematics;
using BlueOyster.Dynamics;

public class ScreenPositionModulator : MonoBehaviour
{
    [SerializeField]
    private Vector2 xBounds;

    [SerializeField]
    private Vector2 yBounds;

    [SerializeField]
    private CinemachinePositionComposer composer;

    [SerializeField]
    private DynamicsPresetSO preset;

    private Dynamics2 dynamics;
    private Vector2 target = Vector2.zero;

    public float Intensity = 1;

    private void OnEnable()
    {
        target = Vector2.zero;
        composer.Composition.ScreenPosition = target;
        dynamics = new Dynamics2(preset, target);
    }

    private void Update()
    {
        target = ComputeScreenOffset();
        composer.Composition.ScreenPosition = dynamics.Update(Time.deltaTime, target);
    }

    private Vector2 ComputeScreenOffset()
    {
        Vector2 mousePosition = Mouse.current.position.ReadValue();
        float normalizedX = math.remap(0, Screen.width, -0.5f, 0.5f, mousePosition.x);
        float normalizedY = math.remap(0, Screen.height, -0.5f, 0.5f, mousePosition.y);

        float mappedX = math.remap(-0.5f, 0.5f, xBounds.x, xBounds.y, normalizedX);
        float mappedY = math.remap(-0.5f, 0.5f, yBounds.x, yBounds.y, normalizedY);

        return new Vector2(-mappedX, mappedY) * Intensity;
    }
}
