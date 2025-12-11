using UnityEngine;

namespace BlueOyster.InvertedHull
{
    // Require a mesh filter component
    // This script, unfortunately, does not support skinned meshes
    [RequireComponent(typeof(MeshFilter))]
    public class ExtrusionMono : MonoBehaviour
    {
        // Store these outline normals in the specified UV/Texcoord channel
        // This corresponds to the TEXCOORD_ semantics in HLSL
        [SerializeField]
        private int storeInTexcoordChannel = 1;

        // The maximum distance apart two vertices must be to be merged
        [SerializeField]
        private float cospatialVertexDistance = 0.01f;

        [ContextMenu("Calculate custom extrusion vectors")]
        private void SetUVs()
        {
            Mesh mesh = GetComponent<MeshFilter>().sharedMesh;
            CustomExtrusion.Compute(
                mesh,
                storeInTexcoordChannel,
                cospatialVertexDistance
            );
        }
    }
}



