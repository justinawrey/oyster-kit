using BlueOyster.Stores;
using UnityEngine;

namespace BlueOyster.Views
{
    [RequireComponent(typeof(RectTransform))]
    public abstract class BaseProgressBarView<T> : BaseViewMB<T, float> where T : Store
{
    private RectTransform containerRt;

    [SerializeField]
    private RectTransform fillRt;

    private float initialWidth;

    protected new void OnEnable()
    {
        containerRt = GetComponent<RectTransform>();
        // left side + right side are 2px, so the "inner"
        // fill max width is 2px smaller
        initialWidth = containerRt.sizeDelta.x - 2;
        base.OnEnable();
    }

    protected override void OnChange(float value)
    {
        // round to int! no jitters here!
        int roundedWidth = Mathf.RoundToInt(initialWidth * value);
        fillRt.sizeDelta = new Vector2(roundedWidth, fillRt.sizeDelta.y);
    }
    }
}