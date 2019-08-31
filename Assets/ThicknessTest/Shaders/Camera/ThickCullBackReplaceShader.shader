Shader "Replace/ThickCullBackReplaceShader" {
	SubShader 
	{
		Tags{"Queue" = "Geometry" "DepthTag" = "Thickness"}
		Pass
		{
			Tags{ "LightMode" = "ShadowCaster"}

			Cull Back ZWrite On ZTest LEqual
			Material
			{
				Diffuse(1,1,1,1)
			}
		}
	}
	FallBack "Diffuse"
}
