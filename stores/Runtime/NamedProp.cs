using System;
using System.Reflection;
using BlueOyster.Stores;
using UnityEngine;

public interface INamedPropSourceProvider
{
    object Source { get; }
}

[Serializable]
public class NamedProp
{
    [SerializeField]
    private UnityEngine.Object source;

    [SerializeField]
    private string propertyName;

    private object ComputedSource
    {
        get
        {
            if (source is INamedPropSourceProvider provider)
            {
                return provider.Source;
            }

            return source;
        }
    }

    private object Property
    {
        get
        {
            if (string.IsNullOrEmpty(propertyName))
            {
                return default;
            }

            if (ComputedSource == null)
            {
                return default;
            }

            // disgusting. but fuck it
            Type type = ComputedSource.GetType();
            if (type.BaseType == typeof(Store))
            {
                Store.GetDynamic(type);
            }

            var prop = type.GetField(
                propertyName,
                BindingFlags.Public | BindingFlags.Instance | BindingFlags.NonPublic
            );

            if (prop == null)
            {
                return default;
            }

            return prop.GetValue(ComputedSource);
        }
    }

    public T ReadValue<T>()
    {
        return (T)Property;
    }
}