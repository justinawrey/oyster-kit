using System;
using System.Collections.Generic;
using UnityEngine;
using BlueOyster.StateMachine;
using BlueOyster.Toggleables;
using BlueOyster.Dweens;

[Serializable]
public class StateRule
{
    public BaseStateMB State;
    public List<BaseToggleable> Toggleables;
}

public class StateMachineToggleableCoordinatorMB : MonoBehaviour
{
    public StateMachine StateMachine;

    [SerializeField]
    private List<StateRule> rules = new();

    private List<BaseToggleable> allToggleables = new();

    private Action unsub;

    private void OnEnable()
    {
        allToggleables.Clear();
        foreach (StateRule rule in rules)
        {
            for (int i = 0; i < rule.Toggleables.Count; i++)
            {
                if (!allToggleables.Contains(rule.Toggleables[i]))
                {
                    allToggleables.Add(rule.Toggleables[i]);
                }
            }
        }

        unsub = StateMachine.CurrentState.OnChange(CheckToggleables);
        CheckToggleables(null, StateMachine.CurrentState.Value);
    }

    private void OnDisable()
    {
        unsub?.Invoke();
    }

    // normally id turn everything off and then selectively turn things back on,
    // but that may introduce some unwanted behaviour if my dweens are enabling/disabling
    // gameobjects (that shit happens IMMEDIATELY).
    // so, be real careful!
    // this is a mess, fuck it!
    private void CheckToggleables(BaseStateMB prevState, BaseStateMB currState)
    {
        for (int i = 0; i < allToggleables.Count; i++)
        {
            BaseToggleable toggleable = allToggleables[i];

            // was already off, should i turn it on? 
            if (!toggleable.Enabled.Value)
            {
                for (int j = 0; j < rules.Count; j++)
                {
                    List<BaseToggleable> onToggleables = rules[j].Toggleables;
                    BaseStateMB state = rules[j].State;

                    if (state == currState && onToggleables.Contains(toggleable))
                    {
                        toggleable.Enabled.Value = true;
                        break;
                    }
                }
            }
            // was already on, should i turn it off?
            else
            {
                bool shouldTurnOff = true;
                for (int j = 0; j < rules.Count; j++)
                {
                    List<BaseToggleable> onToggleables = rules[j].Toggleables;
                    BaseStateMB state = rules[j].State;

                    if (state == currState && onToggleables.Contains(toggleable))
                    {
                        shouldTurnOff = false;
                        break;
                    }
                }
                if (shouldTurnOff)
                {
                    toggleable.Enabled.Value = false;
                }
            }
        }
    }

    // not dry but fuck you.  also hardcoded for dweens
    // until I have a reason not to lol
    public void SimulateStateChange(BaseStateMB state)
    {
        List<BaseToggleable> allToggleablesEditor = new();
        foreach (StateRule rule in rules)
        {
            for (int i = 0; i < rule.Toggleables.Count; i++)
            {
                if (!allToggleablesEditor.Contains(rule.Toggleables[i]))
                {
                    allToggleablesEditor.Add(rule.Toggleables[i]);
                }
            }
        }

        for (int i = 0; i < allToggleablesEditor.Count; i++)
        {
            BaseToggleable toggleable = allToggleablesEditor[i];

            if (toggleable is DweenOrchestrator dween)
            {
                dween.ForceOff();
            }
        }

        for (int i = 0; i < allToggleablesEditor.Count; i++)
        {
            BaseToggleable toggleable = allToggleablesEditor[i];

            for (int j = 0; j < rules.Count; j++)
            {
                List<BaseToggleable> onToggleables = rules[j].Toggleables;
                BaseStateMB onState = rules[j].State;

                if (onState == state && onToggleables.Contains(toggleable))
                {
                    if (toggleable is DweenOrchestrator dween)
                    {
                        dween.ForceOn();
                        break;
                    }
                }
            }
        }
    }
}

