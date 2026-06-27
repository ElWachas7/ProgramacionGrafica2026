using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIPostProcessController : MonoBehaviour
{
    [SerializeField] private MyPostProcess myPostPro;

    [SerializeField] private Shader cameraShader;
    [SerializeField] private Shader flashbangShader;
    [SerializeField] private Shader drunkShader;

    private void Awake()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }
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
