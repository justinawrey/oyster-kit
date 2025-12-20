using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;

namespace BlueOyster.UIListeners
{
    [RequireComponent(typeof(InputSystemUIInputModule))]
    public class LastSelectedGameObjectTracker : MonoBehaviour
    {
        private InputSystemUIInputModule inputModule;
        public static GameObject LastSelected;
        public static bool IsUsingMouse = true;

        [SerializeField]
        private GameObject initialSelectedWhenSceneLoadsAndThereIsAGamepad;

        private void OnEnable()
        {
            LastSelected = initialSelectedWhenSceneLoadsAndThereIsAGamepad;
            inputModule = GetComponent<InputSystemUIInputModule>();
            inputModule.move.action.performed += MaybeReselectLastSelected;
        }

        private void OnDisable()
        {
            inputModule.move.action.performed -= MaybeReselectLastSelected;
        }

        // Do this in Start so that all the handlers on the buttons and shit
        // call their OnEnable() before we try to set the initial selection.
        private void Start()
        {
            // Set initial selection if it hasn't been set yet,
            // and a gamepad is connected.
            if (Gamepad.all.Count > 0)
            {
                IsUsingMouse = false;
                EventSystem.current.SetSelectedGameObject(initialSelectedWhenSceneLoadsAndThereIsAGamepad);
            }
        }

        private void MaybeReselectLastSelected(InputAction.CallbackContext context)
        {
            // If we register a move input, we're not using mouse.
            IsUsingMouse = false;

            // Something is selected already, which means we cant reselect.
            if (EventSystem.current.currentSelectedGameObject != null)
            {
                return;
            }

            // We werent able to track last selected for whatever reason, dont even try.
            // This COULD be the case depending on what the InputModule is doing behind the
            // scenes; nonetheless its safe to just no-op in this case.
            if (LastSelected == null)
            {
                return;
            }

            EventSystem.current.SetSelectedGameObject(LastSelected);
        }
    }
}


