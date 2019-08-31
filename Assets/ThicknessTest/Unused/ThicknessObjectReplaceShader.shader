Shader "Camera/ThicknessObjectReplaceShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader 
	{
		Tags{ "LightMode" = "ShadowCaster" "RenderType" = "CullFront"}
		Pass
		{
			Cull Front ZWrite On ZTest LEqual
			//Lighting On
			Material
			{
				Diffuse(1,1,1,1)
			}

		}
		Pass
		{
			Cull Front ZWrite Off ZTest LEqual
			//Cull Front ZWrite On ZTest LEqual
			Lighting On
			Material
			{
				Diffuse(1,1,1,1)
			}

		}
	}

	SubShader
	{
		Tags{ "LightMode" = "ShadowCaster" "RenderType" = "CullBack"}
		Pass
		{
			Cull Back ZWrite On ZTest LEqual
			//Lighting On
			Material
			{
				Diffuse(1,1,1,1)
			}

		}
		Pass
		{
			Cull Front ZWrite Off ZTest LEqual
			//Cull Front ZWrite On ZTest LEqual
			Lighting On
			Material
			{
				Diffuse(1,1,1,1)
			}

		}
	}
	FallBack "Diffuse"
}
