using System;
using UnityEngine;

namespace BlueOyster.SerializableNullableValue
{
    [Serializable]
    public struct SerializableNullable<T>
        where T : struct
    {
        public T Value
        {
            get
            {
                if (!_hasValue)
                {
                    throw new System.InvalidOperationException(
                        "SerializableNullable<T> object must have a value."
                    );
                }

                return _val;
            }
        }

        public bool HasValue => _hasValue;

        [SerializeField]
        private T _val;

        [SerializeField]
        private bool _hasValue;

        public override string ToString()
        {
            return _hasValue ? _val.ToString() : "Null";
        }

        public SerializableNullable(T initialVal)
        {
            _val = initialVal;
            _hasValue = true;
        }

        public SerializableNullable(T initialVal, bool hasValue)
        {
            _val = initialVal;
            _hasValue = hasValue;
        }

        public static implicit operator SerializableNullable<T>(T? value)
        {
            if (value is T notNullValue)
            {
                return new SerializableNullable<T>(notNullValue, true);
            }

            return new SerializableNullable<T>(default(T), false);
        }

        public static implicit operator T?(SerializableNullable<T> value)
        {
            return value.HasValue ? (T?)value.Value : null;
        }
    }
}
