using OysterKit;
using UnityEngine;
using UnityEngine.EventSystems;

public class Toggle : MonoBehaviour, ISubmitHandler, IPointerClickHandler
{
    [SerializeField]
    private BoolDataBinding binding;

    public void OnSubmit(BaseEventData eventData)
    {
        binding.Data.Value = !binding.Data.Value;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        binding.Data.Value = !binding.Data.Value;
    }
}
