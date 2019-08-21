Shader "Custom/ThickCullBackReplaceShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader 
	{
			//Tags{"RenderType" = "Opaque" "MyTag" = "Thickness"}
			Tags{"Queue" = "Geometry" "MyTag" = "Thickness"}
		Pass
		{
			Tags{ "LightMode" = "ShadowCaster"}

			Cull Back ZWrite On ZTest LEqual
			//Lighting On
			Material
			{
				Diffuse(1,1,1,1)
			}
		}
		//Pass
		//{
		//	Cull Back ZWrite Off ZTest LEqual
		//	//Cull Front ZWrite On ZTest LEqual
		//	Lighting On
		//	Material
		//	{
		//		Diffuse(1,1,1,1)
		//	}

		//}
	
		//ENDCG
	}
	FallBack "Diffuse"
}
