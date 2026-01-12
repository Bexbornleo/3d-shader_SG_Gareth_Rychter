Shader "striped/HorizontalStripes"
{
    Properties
    {
        _Color1 ("Band colour 1", Color) = (1,0,0,1)
        _Color2 ("Band colour 2", Color) = (1,1,1,1)
        _BandThickness ("Band thickness", Float) = 10
        _Transparency ("Bands transparency", Range(0,1)) = 1
        _Speed ("Bands speed", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _Color1;
            float4 _Color2;
            float _BandThickness;
            float _Transparency;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                float offset = _Time.y * _Speed;

                
                float stripes = sin((i.uv.y + offset) * _BandThickness * 3.14159);

                
                float mask = step(0, stripes);

                
                fixed4 col = lerp(_Color1, _Color2, mask);

                
                col.a *= _Transparency;

                return col;
            }
            ENDCG
        }
    }
}
