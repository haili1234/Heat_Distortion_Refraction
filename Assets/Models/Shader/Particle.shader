Shader "Particle" {
    Properties {
        [HDR]_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Cutoff("Alpha Cutoff",Range(0,1)) = 0.5

		_AlphaScale("Alpha Scale", Range(0, 1)) = 1
		
        _Intensity ("Intensity", Range(-3,10)) = 1

		_Saturation("Saturation", Range(0,10)) = 1
		
		
		[HideInInspector] _SrcBlend ("__src", float) = 1.0
		[HideInInspector] _DstBlend ("__dst", float) = 0.0
		[HideInInspector] _ZWrite ("__zwrite", float) = 1.0
		[HideInInspector] _ZTest ("__ztest", float) = 4.0

    }
    SubShader {

		Tags{
            "RenderPipeline" = "UniversalRenderPipeline"            //一定要加这个，用于指明使用URP来渲染
            "RenderType"="Transparent"
			"Queue" = "Transparent"
        }

        Pass
        {
			Tags {"LightMode"="UniversalForward"}

			ZWrite [_ZWrite]
			ZTest [_ZTest] 
			Cull Off //Front Back
			Blend [_SrcBlend] [_DstBlend]

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			#pragma multi_compile _ _SHADOWS_SOFT

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
			
            CBUFFER_START(UnityPerMaterial)
			
            half4 _Color;
            half _Cutoff;
            half _CutColor;
            half _AlphaScale;
			half _Intensity;
			
			half _Brightness;
			half _Saturation;
			
			

            CBUFFER_END
			
            struct a2v
            {
                half4 pos : POSITION;
                half4 texcoord : TEXCOORD0;
				half4 color : COLOR;
				
            };

            struct v2f
            {
                half4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
				half4 color : COLOR;

            };

            v2f vert(a2v v)
            {
                v2f o = (v2f)0;
                o.uv = v.texcoord;

			    o.color = v.color;
                o.pos = TransformObjectToHClip(v.pos);

                return o;

            }

            half4 frag(v2f i) : SV_Target
            {

                half4 texcolor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
				
                clip(texcolor.a - _Cutoff);

				// 亮度
                half3 finalColor = texcolor.rgb * i.color.rgb * _Color * _Intensity;
				
				// 饱和度
                // 特定系数
                half luminance = 0.2125 * texcolor.r + 0.7154 * texcolor.g + 0.0721 * texcolor.b;
                half3 luminanceColor = half3(luminance, luminance, luminance);
                finalColor = lerp(luminanceColor, finalColor, _Saturation);
				
				half finalAlpha = texcolor.a * i.color.a;

				return half4(finalColor.rgb, finalAlpha * _AlphaScale);

            }
            ENDHLSL
        } 
		
    }
	CustomEditor "MyShaderGUI"
}