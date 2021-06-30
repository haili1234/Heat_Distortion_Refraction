
Shader "Heat_Distortion_Refraction" {
	Properties {
 
		_MainTex ("Particle Texture", 2D) = "white" {}
		_Cut ("Cut", Range(0.01,0.1)) = 0.1
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Multiplier("Multiplier", Range(0.01, 10.0)) = 1
		
		[HideInInspector] _SrcBlend ("__src", float) = 1.0
		[HideInInspector] _DstBlend ("__dst", float) = 0.0
		[HideInInspector] _ZWrite ("__zwrite", float) = 1.0
		[HideInInspector] _ZTest ("__ztest", float) = 4.0
	}
 
	SubShader {
	
		Tags{
            "RenderPipeline" = "UniversalRenderPipeline"            
			"Queue" = "Transparent+1" 
			"RenderType" = "Transparent" 
        }
		Pass {

			Tags {"LightMode"="Grab"}
			
			Fog { Color (0,0,0,0) }
			Lighting Off
			Cull Off
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			ZTest [_ZTest] 

			HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			
				CBUFFER_START(UnityPerMaterial)

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _Multiplier;
				
				float _Cut;
				float _InvFade;
				
				CBUFFER_END
				
				SAMPLER(_AfterPostProcessTexture);
				SAMPLER(_CameraColorTexture);
 
				struct data {
 
					half4 vertex : POSITION;
					half4 color : COLOR;
					float4 texcoord : TEXCOORD0;
				};
 
				struct v2f {
					half4 vertex : SV_POSITION;
					half4 color : COLOR;
					float4 screenPos : TEXCOORD0;
					float2 uvmain : TEXCOORD2;

				};
 
				v2f vert(data v)
				{
					v2f o = (v2f)0;
					o.vertex = TransformObjectToHClip(v.vertex);    
					float depth = -mul( UNITY_MATRIX_MV, v.vertex ).z;  
					o.color = v.color / (depth*0.01); 
					o.uvmain = TRANSFORM_TEX(v.texcoord, _MainTex);   
					o.screenPos = o.vertex;
					return o;
				}

				half4 frag( v2f i ) : SV_Target
				{  

					half4 texColor = tex2D(_MainTex, i.uvmain);
					float amount = _Multiplier * i.color.a * texColor.a * 0.1;
					clip(amount-_Cut);
	
	
					float2 screenPos = i.screenPos.xy / i.screenPos.w;
					screenPos.x = (screenPos.x + 1) * 0.5;
					screenPos.y = (screenPos.y + 1) * 0.5;
 
					screenPos.x += (texColor.r - 0.5) * amount;
					screenPos.y += (texColor.g - 0.5) * amount;
					
					screenPos.y = 1 -  screenPos.y;
					
					half4 bgColor = tex2D(_AfterPostProcessTexture, screenPos);
					
					return bgColor;
 
				}
            ENDHLSL
		}
	}
	CustomEditor "MyShaderGUI"
	
}