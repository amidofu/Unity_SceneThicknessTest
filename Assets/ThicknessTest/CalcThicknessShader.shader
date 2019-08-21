Shader "Hidden/CalcThicknessShader"
{
	Properties
	{
		_ThicknessTex("Thickness", 2D) = "white" {}
		_MainTex ("Texture", 2D) = "white" {}
	
	}

	SubShader
	{
		Pass
		{
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
				return o;
			}

			float4 frag(v2f i) : Color
			{
				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				return EncodeFloatRGBA(Linear01Depth(depth));
			}
				ENDCG
		}

		Pass
		{
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
				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				float curDepth = DecodeFloatRGBA(tex2D(_ThicknessTex, i.uv));
				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				float depthLinear = Linear01Depth(depth);
				return EncodeFloatRGBA(curDepth - depthLinear);
			}
			ENDCG
		}
	}

	FallBack Off
}