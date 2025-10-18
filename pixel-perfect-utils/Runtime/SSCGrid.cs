using UnityEngine;
using UnityEditor;
using UnityEngine.UI;
using UnityEngine.InputSystem;
using System;
using BlueOyster.Singletons;

/// <summary>
/// This is meant to be given the EditorOnly tag!
/// </summary>
namespace BlueOyster.PixelPerfectUtils
{
    [RequireComponent(typeof(Canvas)), RequireComponent(typeof(CanvasScaler))]
    [ExecuteAlways]
    public class SSCGrid : NonScenePersistenSingleton<SSCGrid>
    {
        [Header("Grid Settings")]
        public Color gridColor = new Color(1f, 1f, 1f, 0.1f);

        private Canvas canvas;
        private Camera canvasCamera;
        private CanvasScaler scaler;

        [SerializeField]
        private bool showGrid = false;

        private void OnEnable()
        {
            canvas = GetComponent<Canvas>();
            scaler = GetComponent<CanvasScaler>();
            if (canvas.renderMode == RenderMode.ScreenSpaceCamera)
            {
                canvasCamera = canvas.worldCamera;
            }
        }

        public void AlignCamera()
        {
            if (canvas == null || canvas.renderMode != RenderMode.ScreenSpaceCamera || canvasCamera == null)
                return;

            // Get the current scene view camera
            SceneView sceneView = SceneView.lastActiveSceneView;
            if (sceneView == null) return;

            // Set the camera's position and rotation to look directly at the canvas
            sceneView.AlignViewToObject(transform);

            // Adjust the camera's distance to match the canvas size
            float canvasSize = Mathf.Max(canvas.pixelRect.width, canvas.pixelRect.height);
            float distance = canvasSize / Mathf.Tan(sceneView.camera.fieldOfView * 0.5f * Mathf.Deg2Rad);
            sceneView.pivot = transform.position - sceneView.rotation * Vector3.forward * distance;

            // Force the scene view to repaint
            sceneView.Repaint();
        }

        private void OnDrawGizmos()
        {
            if (!enabled || canvas == null || !showGrid)
                return;

            Camera sceneCamera = Camera.current;
            if (sceneCamera == null || sceneCamera.name != "SceneCamera")
                return;

            // Get the canvas plane
            Plane plane = new Plane(transform.forward, transform.position);
            float distance;
            Ray ray = new Ray(sceneCamera.transform.position, sceneCamera.transform.forward);

            if (!plane.Raycast(ray, out distance))
                return;


            // Calculate the grid's right and up vectors in world space
            Vector3 right = transform.right;
            Vector3 up = transform.up;

            // Calculate the grid's origin (bottom-left corner of the canvas)
            RectTransform rectTransform = canvas.GetComponent<RectTransform>();
            Vector3 bottomLeft = rectTransform.TransformPoint(rectTransform.rect.min);
            Vector3 origin = bottomLeft;

            // In OnDrawGizmos, after getting the rectTransform:
            Vector2 canvasSize = rectTransform.rect.size;
            Vector2 scaleFactor = new Vector2(
                canvas.transform.localScale.x,
                canvas.transform.localScale.y
            );

            Vector2 referenceResolution = scaler.referenceResolution;

            // Calculate grid dimensions in world space
            float width = referenceResolution.x * scaleFactor.x;
            float height = referenceResolution.y * scaleFactor.y;

            // Draw vertical lines
            for (int x = 0; x <= referenceResolution.x; x++)
            {
                float xPos = x * scaleFactor.x;
                Vector3 lineStart = origin + right * xPos;
                Vector3 lineEnd = lineStart + up * height;

                Handles.color = gridColor;
                Handles.DrawLine(lineStart, lineEnd);
            }

            // Draw horizontal lines
            for (int y = 0; y <= referenceResolution.y; y++)
            {
                float yPos = y * scaleFactor.y;
                Vector3 lineStart = origin + up * yPos;
                Vector3 lineEnd = lineStart + right * width;

                Handles.color = gridColor;
                Handles.DrawLine(lineStart, lineEnd);
            }
        }
    }
}