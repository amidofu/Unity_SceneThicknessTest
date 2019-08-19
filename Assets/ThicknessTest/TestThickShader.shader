//Shader "Hidden/TestThickShader"
//{
//	Properties
//	{
//		_MainTex ("Texture", 2D) = "white" {}
//	}
//	SubShader
//	{
//		// No culling or depth
//		Cull Off ZWrite Off ZTest Always
//
//		Pass
//		{
//			CGPROGRAM
//			#pragma vertex vert
//			#pragma fragment frag
//			
//			#include "UnityCG.cginc"
//
//			sampler2D _CameraDepthTexture;
//
//			struct appdata
//			{
//				float4 vertex : POSITION;
//				float2 uv : TEXCOORD0;
//			};
//
//			struct v2f
//			{
//				float2 uv : TEXCOORD0;
//				float4 vertex : SV_POSITION;
//			};
//
//			v2f vert (appdata v)
//			{
//				v2f o;
//				o.vertex = UnityObjectToClipPos(v.vertex);
//				o.uv = v.uv;
//				return o;
//			}
//			
//			sampler2D _MainTex;
//
//			float4 frag (v2f i) : SV_Target
//			{
//				//float depth01 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv)));
//				//float depth01 = Linear01Depth(tex2D(_CameraDepthTexture, i.uv));
//
//				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
//				float depth01 = pow(Linear01Depth(depth), 2);
//				fixed4 col = tex2D(_MainTex, i.uv);
//				// just invert the colors
//				col.rgb = 1 - col.rgb;
//				//return col;
//				//depth01 = pow(depth01, 0.5);
//				return float4(depth01, depth01, depth01, 1);
//				//return float4(col.rgb, 1);
//			}
//			ENDCG
//		}
//	}
//}


Shader "Hidden/TestThickShader"
{
	Properties
	{
		_ThicknessTex("Thickness", 2D) = "white" {}
		_MainTex ("Texture", 2D) = "white" {}
	
	}

	SubShader
	{
		//Tags{ "Queue" = "Transparent" }

		Pass
		{
			//Lighting Off
			//Fog{ Mode Off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			sampler2D _ThicknessTex;

			sampler2D _CameraDepthTexture;
			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				//COMPUTE_EYEDEPTH(o.dist);

				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				//float depth01 = pow(Linear01Depth(depth), 1);
				float depth01 = Linear01Depth(depth);
				//return float4(0, 1, 0, 1);
				//return tex2D(_MainTex, i.uv);
				return float4(depth01, depth01, depth01, 1);
			}
				ENDCG
		}

		Pass
		{
			//Lighting Off
			//Fog{ Mode Off }
			//Cull Front
			//Blend One One
			//ZTest Always

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
				
			sampler2D _ThicknessTex;

			sampler2D _CameraDepthTexture;
			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				//COMPUTE_EYEDEPTH(o.dist);

				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				float curDepth = tex2D(_ThicknessTex, i.uv);
				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				//float depth01 = pow(Linear01Depth(depth), 1);
				float depth01 = Linear01Depth(depth);
				float thickness = curDepth - depth01;
				//return float4(0, 1, 0, 1);
				return float4(thickness, thickness, thickness, 1);
				//return float4(curDepth, curDepth, curDepth, 1);
			}
			ENDCG
		}
	}

	FallBack Off
}