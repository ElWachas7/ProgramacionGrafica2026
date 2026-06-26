using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(SpriteRenderer))]
public class Sprite2DWater_Behaviour : MonoBehaviour
{
    [Header("Nivel del agua")]
    [Tooltip("Cuánto sube el agua cuando el objeto está adentro (0 a 0.2 recomendado)")]
    public float waterRiseAmount = 8f;

    [Tooltip("Qué tan suave es la transición al subir")]
    public float smoothSpeedEnter = 4f;

    [Tooltip("Qué tan suave baja al salir (más bajo = más lento)")]
    public float smoothSpeedExit = 1.5f;

    [Header("Splash de entrada")]
    [Tooltip("Pico extra al entrar (0 a 0.2 recomendado)")]
    public float splashStrength = 0.12f;

    [Tooltip("Duración del splash en segundos")]
    public float splashDuration = 0.5f;

    [Header("Bajada al salir")]
    [Tooltip("Cuánto baja el agua respecto al nivel base al salir (valor pequeño, ej: 0.02)")]
    public float exitDipAmount = 0.02f;

    [Tooltip("Cuánto dura la bajada en segundos antes de volver a 0")]
    public float exitDipDuration = 0.8f;


    // Internas
    private Material _mat;
    private float _currentLevel = 0f;
    private float _splashTimer = 0f;
    private float _exitDipTimer = 0f;
    private bool _somethingInside = false;

    private static readonly int WaterLevelID = Shader.PropertyToID("_WaterLevel");
    private static readonly int SplashID = Shader.PropertyToID("_SplashAmount");

    void Start()
    {
        _mat = GetComponent<SpriteRenderer>().material;
        _mat.SetFloat(WaterLevelID, 0f);
        _mat.SetFloat(SplashID, 0f);
    }

    void Update()
    {
        float targetLevel;
        float speed;

        if (_somethingInside)
        {
            // Adentro: sube al nivel configurado
            targetLevel = waterRiseAmount;
            speed = smoothSpeedEnter;
        }
        else if (_exitDipTimer > 0f)
        {
            // Saliendo: baja un poquito y vuelve a 0 suavemente
            _exitDipTimer -= Time.deltaTime;
            float t = _exitDipTimer / exitDipDuration; // 1 → 0
            targetLevel = -exitDipAmount * t;           // negativo = baja
            speed = smoothSpeedExit;
        }
        else
        {
            // Reposo: vuelve a 0
            targetLevel = 0f;
            speed = smoothSpeedExit;
        }

        _currentLevel = Mathf.Lerp(_currentLevel, targetLevel, Time.deltaTime * speed);
        _mat.SetFloat(WaterLevelID, _currentLevel);

        if (_splashTimer > 0f)
        {
            _splashTimer -= Time.deltaTime;
            float t = _splashTimer / splashDuration;
            _mat.SetFloat(SplashID, Mathf.Sin(t * Mathf.PI) * splashStrength);
        }
        else
        {
            _mat.SetFloat(SplashID, 0f);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (!other.CompareTag("Player")) return;
        _somethingInside = true;
        _splashTimer = splashDuration;
        _exitDipTimer = 0f;
    }

    void OnTriggerExit(Collider other)
    {
        if (!other.CompareTag("Player")) return;
        _somethingInside = false;
        _splashTimer = 0f;
        _exitDipTimer = exitDipDuration;
    }

}
