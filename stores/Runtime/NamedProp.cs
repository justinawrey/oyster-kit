using System;
using System.Reflection;
using BlueOyster.Stores;
using UnityEngine;

[Serializable]
public class NamedProp
{
    [SerializeField]
    private UnityEngine.Object source;

    [SerializeField]
    private string propertyName;

    private object Property
    {
        get
        {
            if (string.IsNullOrEmpty(propertyName))
            {
                return default;
            }

            if (source == null)
            {
                return default;
            }

            // disgusting. but fuck it
            Type type = source.GetType();
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

            return prop.GetValue(source);
        }
    }

    public T ReadValue<T>()
    {
        return (T)Property;
    }
}