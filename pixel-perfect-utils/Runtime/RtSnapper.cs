using UnityEngine;

namespace BlueOyster.PixelPerfectUtils
{
    [RequireComponent(typeof(RectTransform))]
    [ExecuteAlways]
    public class RtSnapper : MonoBehaviour
    {
        private RectTransform rt;

        private void OnEnable()
        {
            rt = GetComponent<RectTransform>();
        }

        public void LateUpdate()
        {
            rt.anchoredPosition = new Vector2(Mathf.Round(rt.anchoredPosition.x), Mathf.Round(rt.anchoredPosition.y));
            rt.sizeDelta = new Vector2(Mathf.Round(rt.sizeDelta.x), Mathf.Round(rt.sizeDelta.y));
        }
    }
}