using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace BlueOyster.Reactive.JsonConverters
{
    public class ReactiveConverter<T> : JsonConverter<Reactive<T>>
    {
        public override Reactive<T> ReadJson(
            JsonReader reader,
            Type _,
            Reactive<T> __,
            bool ___,
            JsonSerializer ____
        )
        {
            JToken token = JToken.Load(reader);
            T val = token.ToObject<T>();
            return new Reactive<T>(val);
        }

        public override void WriteJson(JsonWriter writer, Reactive<T> value, JsonSerializer _)
        {
            new JValue(value.Value).WriteTo(writer);
        }

        public override bool CanRead => true;
        public override bool CanWrite => true;
    }
}
