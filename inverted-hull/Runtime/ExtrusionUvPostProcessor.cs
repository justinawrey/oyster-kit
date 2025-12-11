using UnityEngine;
using UnityEditor;

namespace BlueOyster.InvertedHull
{
    public class ExtrusionUvPostProcessor : AssetPostprocessor
    {
        void OnPostprocessModel(GameObject root)
        {
            // Filter: only act on .blend files (or adjust to .fbx/.obj as needed)
            if (!assetPath.EndsWith(".blend", System.StringComparison.OrdinalIgnoreCase))
                return;

            // Walk all MeshFilters
            foreach (var mf in root.GetComponentsInChildren<MeshFilter>(true))
            {
                var mesh = mf.sharedMesh;
                if (mesh == null) continue;

                CustomExtrusion.Compute(mesh);
            }
        }
    }
}


