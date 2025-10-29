using BlueOyster.Stores;
using TMPro;
using UnityEngine;

namespace BlueOyster.Views
{
    public abstract class BaseIntegerView<T> : BaseViewMB<T, int> where T : Store
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
