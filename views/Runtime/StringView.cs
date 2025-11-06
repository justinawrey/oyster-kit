using TMPro;
using UnityEngine;

namespace BlueOyster.Views
{
    [ExecuteAlways]
    public class StringView : BaseViewMB<string>
    {
        [SerializeField]
        private TextMeshProUGUI text;

        [SerializeField]
        private string prefix;

        protected override void OnChange(string value)
        {
            text.text = $"{prefix}{value}";
        }
    }
}

