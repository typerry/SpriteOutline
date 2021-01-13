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

            float frag(v2f i): SV_Target
            {

                float4 value = tex2D(_MainTex, i.uv);
                float dist = distance(i.uv, value.rg) / _MaxDistance;//0.1 is max distance, the texture is to low quality to store the whole thing
                dist = clamp(dist, 0.0, 1.0);
                float col = dist;
                return col;
            }
            ENDCG
            
        }
    }
}
