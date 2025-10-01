using System.IO;
using System.Threading.Tasks;
using Newtonsoft.Json;
using UnityEngine;

namespace BlueOyster.Json
{
    public static class JsonPersistence
    {
        private static Task<string> ReadFromFile(string relativePath)
        {
            return File.ReadAllTextAsync(GetPersistencePath(relativePath));
        }

        private static Task WriteToFile(string relativePath, string json)
        {
            return File.WriteAllTextAsync(GetPersistencePath(relativePath), json);
        }

        private static void WriteToFileSync(string relativePath, string json)
        {
            File.WriteAllText(GetPersistencePath(relativePath), json);
        }

        public static string GetPersistencePath(string relativePath)
        {
            return Path.Combine(Application.persistentDataPath, relativePath);
        }

        public static async Task<string> PersistJson<T>(
            T item,
            string relativePath,
            JsonSerializerSettings settings
        )
        {
            string json = JsonConvert.SerializeObject(item, settings);
            await WriteToFile(relativePath, json);
            return json;
        }

        public static async Task<string> PersistJson<T>(
            T item,
            string relativePath,
            params JsonConverter[] converters
        )
        {
            string json = JsonConvert.SerializeObject(item, converters);
            await WriteToFile(relativePath, json);
            return json;
        }

        public static string PersistJsonSync<T>(
            T item,
            string relativePath,
            JsonSerializerSettings settings
        )
        {
            string json = JsonConvert.SerializeObject(item, settings);
            WriteToFileSync(relativePath, json);
            return json;
        }

        public static string PersistJsonSync<T>(
            T item,
            string relativePath,
            params JsonConverter[] converters
        )
        {
            string json = JsonConvert.SerializeObject(item, converters);
            WriteToFileSync(relativePath, json);
            return json;
        }

        public static async Task<T> FromJson<T>(
            string relativePath,
            JsonSerializerSettings settings
        )
        {
            return JsonConvert.DeserializeObject<T>(await ReadFromFile(relativePath), settings);
        }

        public static async Task<T> FromJson<T>(
            string relativePath,
            params JsonConverter[] converters
        )
        {
            return JsonConvert.DeserializeObject<T>(await ReadFromFile(relativePath), converters);
        }

        public static bool JsonExists(string relativePath)
        {
            return File.Exists(GetPersistencePath(relativePath));
        }

        public static void DeleteJson(string relativePath)
        {
            if (!JsonExists(relativePath))
            {
                return;
            }

            File.Delete(GetPersistencePath(relativePath));
        }
    }
}
