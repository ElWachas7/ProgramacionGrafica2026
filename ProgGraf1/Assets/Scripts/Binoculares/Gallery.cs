using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Gallery : MonoBehaviour
{
    public static Gallery Instance { get; private set; }

    public Texture2D[] _photos = new Texture2D[6];
    public RawImage[] _rawImages = new RawImage[6];
    public int index = 0;

    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    public void AddPhoto(Texture2D photo)
    {
        _photos[index] = photo;
        _rawImages[index].texture = _photos[index];
        index++;
        index = index % _photos.Length;
    }
}
