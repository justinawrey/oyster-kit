using System.Collections.Generic;
using OysterKit;
using UnityEngine;
using UnityEngine.EventSystems;

public class Slider : MonoBehaviour, IMoveHandler
{
    [SerializeField]
    private GameObject selectionMarker;

    [SerializeField]
    private List<Transform> potentialSpots;

    [SerializeField]
    private FloatDataBinding data;

    // called by data binding unity event
    public void SetSelectionMarker(float value)
    {
        int index = Mathf.RoundToInt(value * (potentialSpots.Count - 1));

        if (index >= 0 && index < potentialSpots.Count)
        {
            selectionMarker.transform.position = potentialSpots[index].position;
        }
    }

    public void OnMove(AxisEventData eventData)
    {
        if (eventData.moveDir != MoveDirection.Left && eventData.moveDir != MoveDirection.Right)
        {
            return;
        }

        var currSliderVal = data.Data;
        var right = eventData.moveDir == MoveDirection.Right;

        float nextVal = right ? currSliderVal.Value + 0.1f : currSliderVal.Value - 0.1f;
        currSliderVal.Value = Mathf.Clamp01(nextVal);
    }
}
