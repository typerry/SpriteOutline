Shader "Hidden/JumpFloodPass"
{

    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Offset ("Number", Float) = 0.0
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
            float _Offset;

            float4 frag(v2f i): SV_Target
            {
                float bestDistance = 9999.0;
                float4 bestData = float4(0, 0, 0, 0);
                for (int y = -1; y <= 1; y++)
                {
                    for (int x = -1; x <= 1; x++)
                    {
                        float2 xy = float2(x, y) * _Offset;
                        float2 sampleuv = i.uv + xy;
                        float4 value = tex2D(_MainTex, sampleuv);
                        float dist = distance(i.uv, value.rg);
                        if (dist < bestDistance && length(value.rg) > 0)//(value.r != 0.0 || value.g != 0.0)
                        {
                            bestDistance = dist;
                            bestData = value;
                        }
                    }
                }
                float4 col = bestData;
                return col;
            }
            ENDCG
            
        }
    }
}
