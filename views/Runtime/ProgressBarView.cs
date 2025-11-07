using UnityEngine;

namespace BlueOyster.Views
{
    public class ProgressBarView : BaseViewMB<float>
    {
        [SerializeField]
        private RectTransform containerRt;

        [SerializeField]
        private RectTransform fillRt;

        [SerializeField]
        private bool scaleX = true;

        protected override void OnChange(float value)
        {
            if (scaleX)
            {
                fillRt.localScale = new Vector3(value, 1, 1);
            }
            else
            {
                fillRt.localScale = new Vector3(1, value, 1);
            }
        }
    }
}