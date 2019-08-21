using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderThicknessToTexture : MonoBehaviour {
    public Shader cullFrontReplace;
    public Shader cullBackReplace;
    public Camera thicknessCamera;
    public TestThickTest testThick;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
	}

    private void LateUpdate()
    {
        thicknessCamera.SetReplacementShader(cullFrontReplace, "MyTag");
        testThick.pass = 0;
        thicknessCamera.Render();

        thicknessCamera.SetReplacementShader(cullBackReplace, "MyTag");
        testThick.pass = 1;
        thicknessCamera.Render();
        thicknessCamera.ResetReplacementShader();
    }

    private void OnDisable()
    {
        thicknessCamera.ResetReplacementShader();
    }
}
