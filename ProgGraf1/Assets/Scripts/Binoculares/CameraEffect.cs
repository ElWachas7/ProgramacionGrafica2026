using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraEffect : MonoBehaviour
{
    [SerializeField] private Photo _photoCapture;
    [SerializeField] private Transform _pivot3rd;
    [SerializeField] private Transform _pivot1ft;
    [SerializeField] private float _posSpeed = 5f;
    [SerializeField] private float _rotSpeed = 5f;
    [SerializeField] private Canvas _canvas;
    [SerializeField] private AudioClip _audioClip;
    private AudioSource _audioSource;
    private bool _canvasEnabled;
    private bool _enabledFocus;

    public Material viewfinderMaterial;
    public float openRadius = 0.5f;
    public float closedRadius = 0f;
    public float closeDuration = 0.1f;

    public void Start()
    {
        _audioSource = GetComponent<AudioSource>();
        viewfinderMaterial.SetFloat("_FadeStart", 0.6f );
        viewfinderMaterial.SetFloat("_FadeEnd", 0.4f);
        _canvas.gameObject.SetActive(false);
        _canvasEnabled = false;
    }
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Material activeMaterial = _enabledFocus ? viewfinderMaterial : null;

        if (activeMaterial != null)
            Graphics.Blit(src, dest, activeMaterial);
        else
            Graphics.Blit(src, dest);
    }

    public void CloseEffect()
    {
        StartCoroutine(AnimateRadius(openRadius, closedRadius));
    }

    public void OpenEffect()
    {
        StartCoroutine(AnimateRadius(closedRadius, openRadius));
    }

    void Update()
    {
        if (_enabledFocus)
        {
            transform.position = Vector3.Lerp(transform.position, _pivot1ft.position, 20 * Time.deltaTime);
            transform.rotation = Quaternion.Lerp(transform.rotation, _pivot1ft.rotation, _rotSpeed * Time.deltaTime);
        }
        else
        {
            transform.position = Vector3.Lerp(transform.position, _pivot3rd.position, _posSpeed * Time.deltaTime);
            transform.rotation = Quaternion.Lerp(transform.rotation, _pivot3rd.rotation, _rotSpeed * Time.deltaTime);
        }

        if (Input.GetMouseButtonDown(1))
        {
            _enabledFocus = true;
        }

        if (Input.GetMouseButtonUp(1))
        {
            _enabledFocus = false;
        }

        if (_enabledFocus && Input.GetMouseButtonDown(0))
        {
            CloseEffect();
            Texture2D photo = _photoCapture.TakePhoto();
            _audioSource.PlayOneShot(_audioClip);
            Debug.Log("Foto sacada: " + photo.width + "x" + photo.height);
            OpenEffect();
        }
        else if(!_enabledFocus && Input.GetMouseButtonDown(0)) 
        {
            ToggleCanvas();
        }
    }

    private IEnumerator AnimateRadius(float from, float to)
    {
        if (viewfinderMaterial == null) yield break;
        float elapsed = 0f;
        while (elapsed < closeDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / closeDuration;
            t = t * t * (3f - 2f * t);
            float currentRadius = Mathf.Lerp(from, to, t);
            viewfinderMaterial.SetFloat("_FadeStart", currentRadius + 0.1f);
            viewfinderMaterial.SetFloat("_FadeEnd", currentRadius - 0.1f);
            yield return null;
        }
        // Asegurar el valor final exacto
        viewfinderMaterial.SetFloat("_FadeStart", to + 0.1f);
        viewfinderMaterial.SetFloat("_FadeEnd", to - 0.1f);
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, transform.position + transform.forward * 30f);
    }
    public void ToggleCanvas()
    {
        _canvasEnabled = !_canvasEnabled;
        _canvas.gameObject.SetActive(_canvasEnabled);
    }
}
