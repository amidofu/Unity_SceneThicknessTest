//https://forum.unity.com/threads/depth-only-shader.590620/
Shader "DepthOnlyForReplace" {
	SubShader{
		//Pass 
		//{
		//	Cull Front ZWrite On ZTest LEqual
		//	//Lighting On
		//	Tags{ "LightMode" = "ShadowCaster" }
		//	Material 
		//	{
		//		Diffuse(1,1,1,1)
		//	}

		//}

		//Pass
		//{
		//	Cull Front ZWrite Off ZTest LEqual
		//	//Cull Front ZWrite On ZTest LEqual
		//	Lighting On
		//	Material
		//	{
		//		Diffuse(1,1,1,1)
		//	}

		//}



		////Tags{"RenderType" = "Opaque" "MyTag" = "Thickness"}
		////Pass
		////{
		////	Blend SrcAlpha OneMinusSrcAlpha

		////	Cull Back ZWrite On ZTest LEqual

		////	//Lighting On
		////	//Tags{ "LightMode" = "ShadowCaster" }
		////	Material
		////	{
		////		Diffuse(1,1,1,1)
		////	}

		////}

		
		Tags {"Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" "DepthTag" = "Thickness"}

		Pass {
			Tags { "LightMode" = "ShadowCaster" }
			ColorMask 0

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 vert() : SV_POSITION
			{
				return float4(0,0,0,1);
			}

			void frag() {}
			ENDCG
		}
	}
	//Fallback "Diffuse"
}