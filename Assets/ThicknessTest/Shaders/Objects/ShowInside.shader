Shader "Show Insides" {
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



		Tags{"RenderType" = "Opaque" "MyTag" = "Thickness"}
		Pass
		{
			Cull Back ZWrite On ZTest LEqual
			//Lighting On
			//Tags{ "LightMode" = "ShadowCaster" }
			Material
			{
				Diffuse(1,1,1,1)
			}

		}
	}
	//Fallback "Diffuse"
}