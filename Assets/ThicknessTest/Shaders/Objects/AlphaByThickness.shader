Shader "Unlit/AlphaByThickness"
{
	Properties
	{
		_ThicknessTex ("Thickness Texture", 2D) = "white" {}
		_Color("Main Color", COLOR) = (1,1,1,1)
		_ThicknessMultiplier("Thickness Multiplier", Float) = 1
	}
	SubShader
	{
		Tags{"Queue" = "Transparent" "MyTag" = "Thickness"}
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
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
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _ThicknessTex;
			float4 _ThicknessTex_ST;
			float4 _Color;
			float _ThicknessMultiplier;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _ThicknessTex);
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				i.screenPos = ComputeScreenPos(i.vertex);
				float2 screenUV = i.screenPos.xy / i.screenPos.w;
				// sample the texture
				//float thickness = DecodeFloatRGBA(tex2D(_ThicknessTex, screenUV)) * _ProjectionParams.z * _ThicknessMultiplier;
				float thickness = DecodeFloatRGBA(tex2D(_ThicknessTex, screenUV)) * _ThicknessMultiplier;
				float4 col = fixed4(_Color.rgb, thickness);
				// apply fog
				//col.a = thickness + 0.5;
				return col;
			}
			ENDCG
		}
	}
}
