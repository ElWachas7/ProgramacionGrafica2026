using UnityEngine;

[RequireComponent(typeof(Camera))]
public class MyPostProcess : MonoBehaviour
{
    private Material material;

    public void SetShader(Shader newShader)
    {
        if (newShader != null)
        {
            material = new Material (newShader);
        }
        else
        {
            Debug.LogError("shader nulo");
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

