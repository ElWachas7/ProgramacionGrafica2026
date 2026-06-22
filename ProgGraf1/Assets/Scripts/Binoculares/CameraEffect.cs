using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraEffect : MonoBehaviour
{
    [SerializeField] private Transform _pivot3rd;
    [SerializeField] private Transform _pivot1ft;
    [SerializeField] private float _posSpeed = 5f;
    [SerializeField] private float _rotSpeed = 5f;
    private bool _enabledFocus;

    public Material viewfinderMaterial;
    public float openRadius = 0.5f;
    public float closedRadius = 0f;
    public float closeDuration = 0.5f;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (viewfinderMaterial != null)
            Graphics.Blit(src, dest, viewfinderMaterial);
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
            transform.position = Vector3.Lerp(transform.position, _pivot1ft.position, _posSpeed * Time.deltaTime);
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
            CloseEffect();
        }

        if (Input.GetMouseButtonUp(1))
        {
            _enabledFocus = false;
            OpenEffect();
        }

        if (_enabledFocus && Input.GetMouseButtonDown(0))
        {
            Debug.Log("Sacar Foto");
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
            viewfinderMaterial.SetFloat("_Radius", currentRadius);
            yield return null;
        }
        viewfinderMaterial.SetFloat("_Radius", to);
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, transform.forward * 30f);
    }
}
