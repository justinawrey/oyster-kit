using TMPro;
using UnityEngine;

namespace BlueOyster.Views
{
    [ExecuteAlways]
    public class FloatView : BaseViewMB<float>
    {
        [SerializeField]
        private TextMeshProUGUI text;

        [SerializeField]
        private string prefix;

        protected override void OnChange(float value)
        {
            text.text = $"{prefix}{value}";
        }
    }
}

