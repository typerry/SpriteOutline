Shader "Hidden/DistanceFieldOutside"
{
    Properties
    {
        _MaxDistance ("Max Distance", Float) = 0.1
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _MaxDistance;
            float4 _MainTex_TexelSize;

            float4 frag(v2f i): SV_Target
            {

                float4 fv = tex2D(_MainTex, i.uv);
                float2 value = float2(DecodeFloatRG(fv.rg), DecodeFloatRG(fv.ba));
                //float2 ar = float2(_MainTex_TexelSize.w / _MainTex_TexelSize.z, 1);
                float mx = min(_MainTex_TexelSize.x, _MainTex_TexelSize.y);
                float2 s = _MainTex_TexelSize.zw * mx;

                //float dist = distance(i.uv * ar, value.rg * ar) / ar.y / _MaxDistance;//0.1 is max distance, the texture is to low quality to store the whole thing

                float dist = distance(i.uv * s, value * s) / _MaxDistance;//0.1 is max distance, the texture is to low quality to store the whole thing
                //dist = clamp(dist, 0.0, 1.0);
                float4 col = EncodeFloatRGBA(dist);// float4(dist, 0, 0, 0);
                return col;
            }
            ENDCG
            
        }
    }
}
