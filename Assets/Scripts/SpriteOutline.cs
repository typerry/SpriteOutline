using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SpriteOutline
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(SpriteRenderer))]
    public class SpriteOutline : MonoBehaviour
    {
        [SerializeField]
        Material material;

        void Start()
        {
            var sr = GetComponent<SpriteRenderer>();
            var df = SDF.GenerateDistanceField(sr.sprite.texture, 0.05f);
            sr.sharedMaterial.SetTexture("_DistanceField", df);
        }
    }
}