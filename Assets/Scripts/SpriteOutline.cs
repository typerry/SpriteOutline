﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SpriteOutline
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(SpriteRenderer))]
    public class SpriteOutline : MonoBehaviour
    {
        void Start()
        {
            var sr = GetComponent<SpriteRenderer>();
            var df = SDF.GenerateDistanceField(sr.sprite.texture, 1f);
            sr.sharedMaterial.SetTexture("_DistanceField", df);
        }
    }
}