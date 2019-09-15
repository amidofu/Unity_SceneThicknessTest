Shader "Unlit/TestShadow"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		#include "Lighting.cginc"
		ENDCG

		Pass {
			Tags {
				"LightMode" = "ShadowCaster"
			}
			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma vertex shadowVert
			#pragma fragment shadowFrag
			//https://catlikecoding.com/unity/tutorials/rendering/part-7/
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
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase_fullshadows 

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};
			//https://alastaira.wordpress.com/2014/12/30/adding-shadows-to-a-unity-vertexfragment-shader-in-7-easy-steps/
			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				LIGHTING_COORDS(4, 5)
			};


			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				return float4(atten, atten, atten, 1);
			}
			ENDCG
		}
	}
}
