using UnityEngine;
using UnityEngine.EventSystems;
using BlueOyster.ProceduralAnimations;
using System.Collections.Generic;

namespace BlueOyster.UIListeners
{
    public class TriggerImpulseMoveListener : MonoBehaviour, IMoveHandler
    {
        [SerializeField]
        private BaseImpulse baseImpulse;

        [SerializeField]
        private List<MoveDirection> triggerableDirections = new List<MoveDirection> { MoveDirection.Left, MoveDirection.Right };

        public void OnMove(AxisEventData eventData)
        {
            if (triggerableDirections.Contains(eventData.moveDir))
            {
                baseImpulse.Trigger();
            }
        }
    }
}
