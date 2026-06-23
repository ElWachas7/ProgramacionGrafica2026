using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Photo : MonoBehaviour
{
    [SerializeField] private Camera _captureCamera;
    [SerializeField] private int _photoWidth = 1920;
    [SerializeField] private int _photoHeight = 1080;
    public Texture2D TakePhoto()
    {
        RenderTexture renderTexture = new RenderTexture(_photoWidth, _photoHeight, 24);
        _captureCamera.targetTexture = renderTexture;
        _captureCamera.Render();

        RenderTexture.active = renderTexture;
        Texture2D photo = new Texture2D(_photoWidth, _photoHeight, TextureFormat.RGB24, false);
        photo.ReadPixels(new Rect(0, 0, _photoWidth, _photoHeight), 0, 0);
        photo.Apply();

        _captureCamera.targetTexture = null;
        RenderTexture.active = null;
        Destroy(renderTexture);

        Gallery.Instance.AddPhoto(photo);

        return photo;
    }
}
