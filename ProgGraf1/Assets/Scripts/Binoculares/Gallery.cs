using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gallery : MonoBehaviour
{
    public static Gallery Instance { get; private set; }

    private List<Texture2D> _photos = new List<Texture2D>();

    public List<Texture2D> Photos => _photos;

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
        _photos.Add(photo);
        Debug.Log($"Foto agregada. Total: {_photos.Count}");
    }

    public Texture2D GetLastPhoto()
    {
        if (_photos.Count == 0) return null;
        return _photos[_photos.Count - 1];
    }

    public Texture2D GetPhoto(int index)
    {
        if (index < 0 || index >= _photos.Count) return null;
        return _photos[index];
    }
}
