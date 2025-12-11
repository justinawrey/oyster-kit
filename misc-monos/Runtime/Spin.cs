using UnityEngine;

public class Spin : MonoBehaviour
{
    [SerializeField]
    private float speed = 1f;

    [SerializeField]
    private Vector3 aroundVector = Vector3.up;

    private void Update()
    {
        transform.Rotate(aroundVector, speed * Time.deltaTime);
    }
}