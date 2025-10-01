using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace BlueOyster.IdentifiableSOs
{
    public class IdentifiableSOJsonConverter<T> : JsonConverter
        where T : IdentifiableSO
    {
        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(T);
        }

        public override object ReadJson(
            JsonReader reader,
            Type objectType,
            object existingValue,
            JsonSerializer serializer
        )
        {
            JToken token = JToken.Load(reader);

            if (token.Type == JTokenType.Object)
            {
                JObject jo = (JObject)token;
                return IdentifiableSO.GetById<T>((string)jo["Uuid"]);
            }

            return null;
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer) { }
        public override bool CanWrite => false;
    }

    [JsonObject(MemberSerialization.OptIn)]
    public class IdentifiableSO : ScriptableObject
    {
        private static readonly string assetFolder = "Identifiables";
        private static readonly Dictionary<string, IdentifiableSO> identifiableCache = new();

        [ScriptableObjectId]
        [JsonProperty]
        public string Uuid;

        public static T GetById<T>(string id)
            where T : IdentifiableSO
        {
            if (identifiableCache.ContainsKey(id))
            {
                return identifiableCache[id] as T;
            }

            IdentifiableSO[] identifiableSOs = Resources.LoadAll<IdentifiableSO>(assetFolder);
            for (int i = 0; i < identifiableSOs.Length; i++)
            {
                identifiableCache[identifiableSOs[i].Uuid] = identifiableSOs[i];
            }

            if (!identifiableCache.ContainsKey(id))
            {
                throw new Exception($"Tried to get an identifiable that doesnt exist: {id}.  Did you create it in the right folder?");
            }

            return identifiableCache[id] as T;
        }
    }
}

