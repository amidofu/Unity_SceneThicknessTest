using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class TestCullFront : MonoBehaviour {
    private Material material;
    private Camera m_Camera;
    public RenderTexture thicknessRT;
    private void Awake()
    {
        material = new Material(Shader.Find("Hidden/TestCullFrontShader"));
        m_Camera = GetComponent<Camera>();
        m_Camera.depthTextureMode = DepthTextureMode.Depth;
        material.SetTexture("_ThicknessTex", thicknessRT);
    }

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}
