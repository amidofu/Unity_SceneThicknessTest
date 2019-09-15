// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/AlphaByThickness"
{
	Properties
	{
		_ThicknessTex ("Thickness Texture", 2D) = "white" {}
		_Color("Main Color", COLOR) = (1,1,1,1)
		_ThicknessMultiplier("Thickness Multiplier", Float) = 1
		_ShadowIntensity("Shadow Intensity", Range(0, 1)) = 0.6
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	#include "AutoLight.cginc"
	#include "Lighting.cginc"
	ENDCG
	SubShader
	{
		//https://forum.unity.com/threads/transparent-shader-receive-shadows.325877/
		//must be AlphaTest to make shadow receiver work
		Tags{"Queue" = "AlphaTest"}
		LOD 100

		Pass {
			Tags {
				"LightMode" = "ShadowCaster"
			}
			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma vertex shadowVert
			#pragma fragment shadowFrag
			struct appdata {
				float4 position : POSITION;
				float3 normal : NORMAL;
			};
			float4 shadowVert(appdata v) : SV_POSITION {
				float4 position =
					UnityClipSpaceShadowCasterPos(v.position.xyz, v.normal);
				return UnityApplyLinearShadowBias(position);
			}

			half4 shadowFrag() : SV_TARGET {
				return 0;
			}
			ENDCG
		}

		Pass
		{
			Lighting On
			Tags {"LightMode" = "ForwardBase"}
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			//#pragma multi_compile_fog
			#pragma multi_compile_fwdbase_fullshadows 

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float4 screenPos : TEXCOORD1;
				float3 normal : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				LIGHTING_COORDS(4, 5)
			};

			sampler2D _ThicknessTex;
			sampler2D _CameraDepthTexture;
			float4 _ThicknessTex_ST;
			float4 _Color;
			float _ThicknessMultiplier;
			float _ShadowIntensity;
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.pos);
				o.uv = TRANSFORM_TEX(v.uv, _ThicknessTex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				//https://forum.unity.com/threads/transparent-shader-receive-shadows.325877/
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{

				float2 screenUV = i.screenPos.xy / i.screenPos.w;
				float thickness = DecodeFloatRGBA(tex2D(_ThicknessTex, screenUV));
				float4 col = fixed4(_Color.rgb, thickness);
				col.a = thickness * _ProjectionParams.z * _ThicknessMultiplier;
				float3 lightColor = _LightColor0.rgb;
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);

				//sample shadow map and other light attenuation
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				float3 N = i.normal;
				float  NL = saturate(dot(N, lightDir));

				//float4 finalLightColor = float4(lightColor * atten, 1);
				//return col * finalLightColor + float4(ShadeSH9(float4(i.normal, 1)), 0);

				atten = clamp(atten, _ShadowIntensity, 1);
				float4 finalLightColor = float4(lightColor * atten, 1);
				return col * finalLightColor;


			}
			ENDCG
		}
	}
}
