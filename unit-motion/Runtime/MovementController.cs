using UnityEngine;
using UnityEngine.InputSystem;
using BlueOyster.Dynamics;
using BlueOyster.Toggleables;

namespace BlueOyster.UnitMotion
{
    public class MovementController : BaseToggleable, IMotionProvider
    {
        [SerializeField]
        private DynamicLocalRotation3 tiltMesh;

        [SerializeField]
        private float maxTiltAngle = 10f;

        [SerializeField]
        private InputActionReference moveActionReference;

        private Vector2 motionInput;

        private Vector3 mouseWorldPos;
        private Plane basePlane = new(Vector3.up, Vector3.zero);

        private Camera cam;

        private new void OnEnable()
        {
            base.OnEnable();
            cam = Camera.main;
        }

        private void Update()
        {
            ReadInput();
            ApplyMeshTilt();
        }

        public Vector3 GetNormalizedMotionDir()
        {
            if (!Enabled.Value)
            {
                return Vector3.zero;
            }

            var inputDirection = new Vector3(motionInput.x, 0, motionInput.y).normalized;

            // Get the rotation of the camera on the Y axis only
            var cameraRotation = Quaternion.Euler(0, cam.transform.rotation.eulerAngles.y, 0);

            // Rotate the input direction by the camera's rotation
            return (cameraRotation * inputDirection).normalized;
        }

        public Vector3 GetNormalizedTargetDir()
        {
            if (!Enabled.Value)
            {
                return Vector3.zero;
            }

            Vector3 v = mouseWorldPos - transform.position;
            return new Vector3(v.x, 0, v.z).normalized;
        }

        private void ApplyMeshTilt()
        {
            Vector3 motionDir = GetNormalizedMotionDir();
            tiltMesh.EulerAngles = new Vector3(
                motionDir.z * maxTiltAngle,
                0,
                -motionDir.x * maxTiltAngle
            );
        }

        private void ReadInput()
        {
            motionInput = moveActionReference.action.ReadValue<Vector2>();

            // TODO: what about controller support?
            Vector2 mouseScreenPos = Mouse.current.position.ReadValue();
            Vector2 mouseScreenPosN = mouseScreenPos / 4;
            Ray ray = cam.ScreenPointToRay(mouseScreenPosN);
            if (basePlane.Raycast(ray, out float enter))
            {
                mouseWorldPos = ray.GetPoint(enter);
            }
        }

        private void OnDrawGizmos()
        {
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(mouseWorldPos, 0.5f);
        }
    }
}
