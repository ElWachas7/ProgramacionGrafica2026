using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(SpriteRenderer))]
public class Sprite2DWater_Behaviour : MonoBehaviour
{
    [Header("Nivel del agua")]
    public float waterRiseAmount = 8f;
    public float smoothSpeedEnter = 4f;
    public float smoothSpeedExit = 1.5f;

    [Header("Splash de entrada")]
    public float splashStrength = 0.12f;

    [Tooltip("Duración del splash en segundos")]
    public float splashDuration = 0.5f;

    [Header("Bajada al salir")]
    public float exitDipAmount = 0.02f;
    public float exitDipDuration = 0.8f;

    private Material mat;
    private float currentLevel = 0f;
    private float splashTimer = 0f;
    private float exitDipTimer = 0f;
    private bool somethingInside = false;

    private static int WaterLevelID = Shader.PropertyToID("_WaterLevel");
    private static int SplashID = Shader.PropertyToID("_SplashAmount");

    void Start()
    {
        mat = GetComponent<SpriteRenderer>().material;
        mat.SetFloat(WaterLevelID, 0f);
        mat.SetFloat(SplashID, 0f);
    }

    void Update()
    {
        float targetLevel;
        float speed;

        if (somethingInside)
        {
            targetLevel = waterRiseAmount;
            speed = smoothSpeedEnter;
        }
        else if (exitDipTimer > 0f)
        {
            exitDipTimer -= Time.deltaTime;
            float timeDivision = exitDipTimer / exitDipDuration; 
            targetLevel = -exitDipAmount * timeDivision;
            speed = smoothSpeedExit;
        }
        else
        {
            targetLevel = 0f;
            speed = smoothSpeedExit;
        }

        currentLevel = Mathf.Lerp(currentLevel, targetLevel, Time.deltaTime * speed);
        mat.SetFloat(WaterLevelID, currentLevel);

        if (splashTimer > 0f)
        {
            splashTimer -= Time.deltaTime;
            float t = splashTimer / splashDuration;
            mat.SetFloat(SplashID, Mathf.Sin(t * Mathf.PI) * splashStrength);
        }
        else
        {
            mat.SetFloat(SplashID, 0f);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (!other.CompareTag("Player")) return;
        somethingInside = true;
        splashTimer = splashDuration;
        exitDipTimer = 0f;
    }

    void OnTriggerExit(Collider other)
    {
        if (!other.CompareTag("Player")) return;
        somethingInside = false;
        splashTimer = 0f;
        exitDipTimer = exitDipDuration;
    }

}
