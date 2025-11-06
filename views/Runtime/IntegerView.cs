using TMPro;
using UnityEngine;

namespace BlueOyster.Views
{
    [ExecuteAlways]
    public class IntegerView : BaseViewMB<int>
    {
        [SerializeField]
        private TextMeshProUGUI text;

        [SerializeField]
        private string prefix;

        protected override void OnChange(int value)
        {
            text.text = $"{prefix}{value}";
        }
    }
}
