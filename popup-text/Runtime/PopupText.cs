using BlueOyster.Dweens;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;

public class PopupText : MonoBehaviour
{
    [SerializeField]
    private TextMeshProUGUI text;

    [SerializeField]
    private float lifetime = 1;

    [SerializeField]
    private DweenOrchestrator upwardsMotionDweenOrchestrator;

    [SerializeField]
    private DweenOrchestrator scaleDweenOrchestrator;

    // [SerializeField]
    // private int pinnedScreenOffsetYMin = 5;

    // [SerializeField]
    // private int pinnedScreenOffsetYMax = 10;

    // [SerializeField]
    // private int pinnedScreenOffsetXMin = -5;

    // [SerializeField]
    // private int pinnedScreenOffsetXMax = 5;

    private Camera mainCam;

    // private Vector3 pinnedWorldPos;
    // private Vector2 pinnedScreenOffset;

    private void OnEnable()
    {
        mainCam = Camera.main;
        upwardsMotionDweenOrchestrator.ForceOff();
        scaleDweenOrchestrator.ForceOff();

        // pinnedScreenOffset = new Vector2(
        //     Random.Range(pinnedScreenOffsetXMin, pinnedScreenOffsetXMax + 1),
        //     Random.Range(pinnedScreenOffsetYMin, pinnedScreenOffsetYMax + 1)
        // );
    }

    public void Pin(string text)
    {
        this.text.text = text;
        // pinnedWorldPos = worldPos;
        // UpdatePos();


        Routine().Forget();
    }

    private async UniTaskVoid Routine()
    {
        scaleDweenOrchestrator.TurnOn();
        upwardsMotionDweenOrchestrator.TurnOn();
        await UniTask.WaitForSeconds(lifetime);
        scaleDweenOrchestrator.TurnOff();

        // give some time to animate away
        await UniTask.WaitForSeconds(0.5f);
        Destroy(gameObject);
    }

    // private void Update()
    // {
    // UpdatePos();
    // }

    // private void UpdatePos()
    // {
    //     Vector3 screenPos = mainCam.WorldToScreenPoint(pinnedWorldPos);
    //     Vector2 screenPos2 = new(screenPos.x, screenPos.y);
    //     transform.localPosition = screenPos2 + pinnedScreenOffset;
    // }
}
