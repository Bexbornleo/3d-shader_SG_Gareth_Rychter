Shader "Fading/WaveTopDownDissolve"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Cutoff ("Dissolve Amount", Range(0,1)) = 0

        _WaveAmplitude ("Wave Amplitude", Range(0,0.2)) = 0.05
        _WaveFrequency ("Wave Frequency", Range(1,30)) = 10
        _WaveSpeed ("Wave Speed", Range(0,10)) = 3

        _EdgeFade ("Edge Fade", Range(0.001,0.2)) = 0.05
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;
            float _Cutoff;

            float _WaveAmplitude;
            float _WaveFrequency;
            float _WaveSpeed;

            float _EdgeFade;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float height : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.height = v.vertex.y;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                float h = saturate(i.height + 0.5);

                
                float wave =
                    sin(i.worldPos.x * _WaveFrequency + _Time.y * _WaveSpeed) *
                    _WaveAmplitude;

                
                float waveCutoff = _Cutoff + wave;

                float edge = smoothstep(waveCutoff, waveCutoff + _EdgeFade, h);

                
                float alpha = 1.0 - edge;

                return float4(_Color.rgb, _Color.a * alpha);
            }
            ENDCG
        }
    }
}
