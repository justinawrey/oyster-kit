using UnityEngine;

namespace BlueOyster.ShaderGlobals
{
    public abstract class ShaderGlobals : ScriptableObject
    {
        private const string assetFolder = "Shader Globals";

        protected abstract void UpdateShaderGlobals();

        protected void OnEnable()
        {
            UpdateShaderGlobals();
        }

        protected void OnValidate()
        {
            UpdateShaderGlobals();
        }

        public static void Prime()
        {
            ShaderGlobals[] sgs = Resources.LoadAll<ShaderGlobals>(assetFolder);
            foreach (ShaderGlobals sg in sgs)
            {
                sg.UpdateShaderGlobals();
            }
        }
    }
}