using UnityEngine;
using UnityEngine.InputSystem;

namespace BlueOyster.WorldSelectables
{
    public class DefaultMousePositionProvider : MonoBehaviour, IMousePositionProvider
    {
        public Vector2 GetMousePosition()
        {
            return Mouse.current.position.ReadValue();
        }
    }
}


