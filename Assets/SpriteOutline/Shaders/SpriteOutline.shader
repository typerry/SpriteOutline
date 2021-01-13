Shader "Sprites/Outline"
{
    Properties
    {
        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" { }
        _DistanceField ("Distance field", 2D) = "white" { }
        _Width ("outline width", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull off
        LOD 100

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float2 uv2: TEXCOORD1;
                float4 vertex: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DistanceField;
            float4 _DistanceField_ST;
            float _Width;
            fixed4 _OutlineColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv, _DistanceField);


                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                float dist = tex2D(_DistanceField, i.uv2);
                float alpha = 1 - smoothstep(_Width - fwidth(dist), _Width, dist);
                float4 outline = _OutlineColor;
                outline.a = alpha;
                float4 main = tex2D(_MainTex, i.uv);

                fixed4 col = lerp(outline, main, main.a);
                col.a = max(alpha, col.a);

                return col;
            }
            ENDCG
            
        }
    }
}
