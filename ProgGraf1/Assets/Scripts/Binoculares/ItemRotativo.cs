using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemRotativo : MonoBehaviour
{
    [SerializeField] private float _minRotationSpeed;
    [SerializeField] private float _maxRotationSpeed;
    [SerializeField] private float _minSize;
    [SerializeField] private float _maxSize;
    [SerializeField] private float _PingPongTime;

    private float _rotationSpeed;
    private Vector3 _minScale;
    private Vector3 _maxScale;
    private float _duration;

    private void Awake()
    {
        _minScale = new Vector3(_minSize, _minSize, _minSize);
        _maxScale = new Vector3(_maxSize, _maxSize, _maxSize);
        _duration = _PingPongTime + Random.Range(-0.5f, 0.5f);
        _rotationSpeed = Random.Range(_minRotationSpeed, _maxRotationSpeed);
        StartCoroutine(ScaleItem());
    }
    private void Update()
    {
        transform.Rotate(Vector3.up * _rotationSpeed * Time.deltaTime);
    }
    private IEnumerator ScaleItem()
    {
        float elapsed = 0f;
        while (true)
        {
            elapsed += Time.deltaTime;
            float t = Mathf.PingPong(elapsed / _duration, 1f);
            t = t * t * (3f - 2f * t); // smoothstep
            transform.localScale = Vector3.Lerp(_minScale, _maxScale, t);
            yield return null;
        }
    }
}
