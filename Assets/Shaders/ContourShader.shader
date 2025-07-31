Shader "Unlit/ContourShader"
{
    Properties
    {
        _EdgeColor("Edge Color", Color) = (0,0,0,1)
        _SurfaceColor("Surface Color", Color) = (1,1,1,1)
        _Threshold("Edge Threshold", Range(0,1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // Variabili uniformi
            fixed4 _EdgeColor;
            fixed4 _SurfaceColor;
            float _Threshold;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);

                o.worldPos = worldPos;
                o.worldNormal = worldNormal;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float edgeStrength = abs(dot(normalize(i.worldNormal), viewDir));

                float edge = step(_Threshold, edgeStrength);
                return lerp(_EdgeColor, _SurfaceColor, edge);
            }
            ENDCG
        }
    }
}
