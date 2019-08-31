using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class RenderThicknessToTexture : MonoBehaviour {
    public Shader cullFrontReplaceShader;
    public Shader cullBackReplaceShader;
    public Shader calcThicknessShader;
    public RenderTexture passCullFrontTex;
    public RenderTexture passCullBackTex;
    public Camera thicknessCamera;
    public TestThickTest testThick;
    private Material materialCalcThickness;
    public int pass;
    private void Awake()
    {
        if(calcThicknessShader == null) { calcThicknessShader = Shader.Find("Hidden/CalcThicknessShader"); }
        if(cullFrontReplaceShader == null) { cullFrontReplaceShader = Shader.Find("Replace/ThickCullFrontReplaceShader"); }
        if(cullBackReplaceShader == null) { cullBackReplaceShader = Shader.Find("Replace/ThickBackFrontReplaceShader"); }
        materialCalcThickness = new Material(calcThicknessShader);
        if (thicknessCamera == null) { thicknessCamera = GetComponent<Camera>(); }
        thicknessCamera.CopyFrom(Camera.main);
        thicknessCamera.depthTextureMode = thicknessCamera.depthTextureMode | DepthTextureMode.Depth;
        materialCalcThickness.SetTexture("_ThicknessTex", passCullFrontTex);
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
	}

    private void LateUpdate()
    {
        thicknessCamera.SetReplacementShader(cullFrontReplaceShader, "DepthTag");
        pass = 0;
        thicknessCamera.Render();

        thicknessCamera.SetReplacementShader(cullBackReplaceShader, "DepthTag");
        pass = 1;
        thicknessCamera.Render();
    }

    private void OnDisable()
    {
        thicknessCamera.ResetReplacementShader();
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        switch (pass)
        {
            case 0:
                Graphics.Blit(source, passCullFrontTex, materialCalcThickness, pass);
                break;
            case 1:
                Graphics.Blit(source, passCullBackTex, materialCalcThickness, pass);
                break;
        }

    }
}
