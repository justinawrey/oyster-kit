using System;
using UnityEngine;

public class SinBounceRaw : MonoBehaviour
{
    [SerializeField]
    private float freq = 2f * Mathf.PI;

    [SerializeField]
    private float amplitude = 0.1f;

    [SerializeField]
    private float scaleAmplitude = 0.1f;

    private float phase = 0;
    private Vector3 originalScale;
    private float originalY;

    private void Awake()
    {
        originalScale = transform.localScale;
        originalY = transform.localPosition.y;
        phase = UnityEngine.Random.Range(0, Mathf.PI * 2f);
    }

    private void Update()
    {
        float y = Mathf.Sin(Time.time * freq + phase) * amplitude;
        transform.localPosition = new Vector3(
            transform.localPosition.x,
            originalY + y,
            transform.localPosition.z
        );

        float scale = Mathf.Sin(Time.time * freq + phase) * scaleAmplitude;
        transform.localScale = new Vector3(
            originalScale.x + scale,
            originalScale.y + scale,
            originalScale.z + scale
        );
    }
}