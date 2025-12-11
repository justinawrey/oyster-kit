using System.Collections.Generic;
using UnityEngine;

namespace BlueOyster.ProceduralAnimations
{
    public class MaterialFlasher : BaseImpulse
    {
        [SerializeField]
        private Material flashMaterial;

        [SerializeField]
        private float flashDuration = 0.1f;

        private List<MeshRenderer> renderers = new();
        private List<Material> originalMaterials = new();
        private float timer;

        private void OnEnable()
        {
            renderers.Clear();
            originalMaterials.Clear();

            GetComponentsInChildren(renderers);
            foreach (var renderer in renderers)
            {
                originalMaterials.Add(renderer.material);
            }

            timer = 0;
        }

        private void OnDisable()
        {
            originalMaterials.Clear();
        }

        public override void Trigger()
        {
            timer += flashDuration;
        }

        private void Update()
        {
            timer -= Time.deltaTime;
            if (timer < 0)
            {
                timer = 0;
            }

            if (timer > 0)
            {
                for (int i = 0; i < renderers.Count; i++)
                {
                    renderers[i].material = flashMaterial;
                }
            }
            else
            {
                for (int i = 0; i < renderers.Count; i++)
                {
                    renderers[i].material = originalMaterials[i];
                }
            }
        }
    }
}

