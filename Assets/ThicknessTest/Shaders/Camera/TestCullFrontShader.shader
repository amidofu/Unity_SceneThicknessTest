Shader "Hidden/TestCullFrontShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ThicknessTex ("Thickness", 2D) = "white" {}
		
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			sampler2D _CameraDepthTexture;
			sampler2D _ThicknessTex;
			sampler2D _MainTex;

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			

			float4 frag (v2f i) : SV_Target
			{
				//float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				//float depth01 = pow(Linear01Depth(depth), 1);
				//fixed4 col = tex2D(_MainTex, i.uv);
				//// just invert the colors
				//col.rgb = 1 - col.rgb;
				////return col;
				//return float4(depth01, depth01, depth01, 1);

				float thickness = tex2D(_ThicknessTex, i.uv).r;
				float thickAlpha = thickness * _ProjectionParams.w * 20;
				float4 col = tex2D(_MainTex, i.uv);
				float4 fog = float4(1, 0, 1, 1);
				col = fog * thickAlpha + col * 1 * (1 - thickAlpha);
				return col;
				// just invert the colors
				col.rgb = 1 - col.rgb;
				//return col;
				//return float4(depth01, depth01, depth01, 1);
			}
			ENDCG
		}
	}
}
