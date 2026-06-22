using UnityEngine;

[RequireComponent(typeof(Camera))]
public class MyPostProcess : MonoBehaviour
{
    [SerializeField] private Shader myShader;
    private Material material;

    private void Awake()
    {
        if (myShader != null)
        {
            material = new Material(myShader);
        }
        else
        {
            Debug.LogError("falta asignar el shader en inspector");
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}

