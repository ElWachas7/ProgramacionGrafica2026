using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIPostProcessController : MonoBehaviour
{
    [SerializeField] private MyPostProcess myPostPro;

    [SerializeField] private Shader cameraShader;
    [SerializeField] private Shader flashbangShader;
    [SerializeField] private Shader drunkShader;

    public void SetCameraShader()
    {
        myPostPro.SetShader(cameraShader);
    }
    public void SetFlashbangShader()
    {
        myPostPro.SetShader(flashbangShader);
    }
    public void SetDrunkShader()
    {
        myPostPro.SetShader(drunkShader);
    }
}
