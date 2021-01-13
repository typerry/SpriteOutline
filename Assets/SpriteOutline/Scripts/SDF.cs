using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SDF
{
    public class Generator
    {


        public static RenderTexture GenerateDistanceField(Texture2D input, float maxDistance = 1f)
        {
            var seed = GetRenderTexture(input.width, input.height, RenderTextureFormat.RGFloat, FilterMode.Point);
            Graphics.Blit(input, seed, new Material(Shader.Find("Hidden/SeedInside")));
            return GetDistance(JumpFlood(seed), maxDistance);
        }

        static RenderTexture GetDistance(RenderTexture input, float maxDistance)
        {
            var mt = new Material(Shader.Find("Hidden/DistanceFieldOutside"));
            mt.SetFloat("_MaxDistance", maxDistance);
            var result = GetRenderTexture(input.width, input.height, RenderTextureFormat.RFloat, FilterMode.Bilinear);//RFLOAT FOR HIGHER QUALITY 
            Graphics.Blit(input, result, mt);
            return result;
        }

        //Gets nearest seed pixel UV coords
        public static RenderTexture JumpFlood(RenderTexture input)
        {
            int width = input.width;
            RenderTexture[] textures = new RenderTexture[2];
            textures[0] = input;
            textures[1] = GetRenderTexture(width, input.height, RenderTextureFormat.RGFloat, FilterMode.Point);//CHANGE TO RENDER TEXTURE FORMAT RGFLOAT
            var mt = new Material(Shader.Find("Hidden/JumpFloodPass"));
            int max = (int)Mathf.Log(width, 2f) + 1;//no plus 1?
            for (int i = 0; i < max; i++)
            {
                float offset = Mathf.Pow(2f, (Mathf.Log(width, 2f) - i - 1));
                mt.SetFloat("_Offset", offset / width);
                int index = i % 2;
                Graphics.Blit(textures[index], textures[1 - index], mt);
            }
            return textures[max % 2];//CHECK IT"S NOT 1-max%2
        }

        static RenderTexture GetRenderTexture(int width, int height, RenderTextureFormat format, FilterMode filterMode)
        {
            var rt = new RenderTexture(width, height, 16, format);
            rt.filterMode = filterMode;
            rt.wrapMode = TextureWrapMode.Clamp;
            rt.Create();
            return rt;
        }
    }
}