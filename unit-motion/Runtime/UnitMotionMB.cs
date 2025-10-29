using UnityEngine;
using BlueOyster.Dynamics;
using BlueOyster.Toggleables;

namespace BlueOyster.UnitMotion
{
    // Provides somethings current normalized motion direction and rotation.
    public interface IMotionProvider
    {
        Vector3 GetNormalizedMotionDir();
        Vector3 GetNormalizedTargetDir();
    }

    // A seperate component for controlling motion because we want some SPACEY-ASS looking motion.
    [RequireComponent(typeof(IMotionProvider))]
    public class UnitMotionMB : BaseToggleable
    {
        [Header("Movement Options")]
        public Rigidbody Rb;

        public float MaxSpeed = 10f;

        [SerializeField]
        private float accel = 5f;

        [SerializeField]
        private float deccel = 5f;

        [Header("Rotation Options")]
        [SerializeField]
        private DynamicLocalRotation3 rotation;

        private IMotionProvider motionProvider;
        private Vector3 motionDir;
        private Vector3 targetDir;

        private void Awake()
        {
            motionProvider = GetComponent<IMotionProvider>();
            targetDir = motionProvider.GetNormalizedTargetDir();
        }

        private void Update()
        {
            ReadMotionVectors();
            HandleRotation();
        }

        private void FixedUpdate()
        {
            HandleMovement();
        }

        private void ReadMotionVectors()
        {
            motionDir = motionProvider.GetNormalizedMotionDir();
            targetDir = motionProvider.GetNormalizedTargetDir();
        }

        private void HandleMovement()
        {
            if (!Enabled.Value)
            {
                return;
            }

            float GetForceSingleAxis(float motion, float rbVel)
            {
                float targetSpeed = motion * MaxSpeed;
                float speedDiff = targetSpeed - rbVel;
                float accelRate = (Mathf.Abs(targetSpeed) > 0.01f) ? accel : deccel;
                float movement = speedDiff * accelRate;
                return movement;
            }

            float xForce = GetForceSingleAxis(motionDir.x, Rb.linearVelocity.x);
            float zForce = GetForceSingleAxis(motionDir.z, Rb.linearVelocity.z);

            Rb.AddForce(new Vector3(xForce, 0, zForce));
        }

        private void HandleRotation()
        {
            if (!Enabled.Value)
            {
                return;
            }

            if (rotation == null)
            {
                return;
            }

            if (targetDir == Vector3.zero)
            {
                return;
            }

            // Get the current and target Y rotation
            float currentY = rotation.EulerAngles.y;
            float targetY = Quaternion.LookRotation(targetDir).eulerAngles.y;

            // Calculate the new target Y angle, taking the shortest path
            float newTargetY = currentY + Mathf.DeltaAngle(currentY, targetY);

            // Set the new Euler angles
            rotation.EulerAngles = new Vector3(0, newTargetY, 0);
        }

        public void ForceStopMovement()
        {
            Rb.linearVelocity = Vector3.zero;
            Rb.angularVelocity = Vector3.zero;
        }

        public override void OnToggle(bool on)
        {
            if (!on)
            {
                ForceStopMovement();
            }
        }
    }
}
