using BlueOyster.Views;
using UnityEngine;
using UnityEngine.UI;

public class ProgressBarColorView : BaseViewMB<float>
{
    [SerializeField]
    private Color fullColor;

    [SerializeField]
    private Color emptyColor;

    [SerializeField]
    private Image fillImage;

    protected override void OnChange(float value)
    {
        fillImage.color = Color.Lerp(emptyColor, fullColor, value);
    }
}
