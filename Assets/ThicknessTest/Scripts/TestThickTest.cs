using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
//[ExecuteInEditMode]
public class TestThickTest : MonoBehaviour {
    private Material material;
    private Camera m_Camera;
    public int pass;
    public RenderTexture passCullFrontTex;
    public RenderTexture passCullBackTex;
    private void Awake()
    {
        material = new Material(Shader.Find("Hidden/CalcThicknessShader"));
        m_Camera = GetComponent<Camera>();
        m_Camera.CopyFrom(Camera.main);
        m_Camera.depthTextureMode = m_Camera.depthTextureMode | DepthTextureMode.Depth;
        material.SetTexture("_ThicknessTex", passCullFrontTex);
        //m_Camera.SetTargetBuffers(colorRenderTexture.colorBuffer, depthRenderTexture.depthBuffer);
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //switch(pass)
        //{
        //    case 0:
        //        Graphics.Blit(source, m_Camera.activeTexture, material, 0);
        //        break;
        //    case 1:
        //        Graphics.Blit(m_Camera.activeTexture, destination, material, 1);
        //        break;
        //}

        switch(pass)
        {
            case 0:
                Graphics.Blit(source, passCullFrontTex, material, pass);
                break;
            case 1:
                Graphics.Blit(source, passCullBackTex, material, pass);
                break;

        }

    }
}
