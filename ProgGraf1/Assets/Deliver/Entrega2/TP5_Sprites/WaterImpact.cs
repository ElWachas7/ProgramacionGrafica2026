using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterImpact : MonoBehaviour
{
    [Header("Detección del objeto dentro del agua")]
    [SerializeField] private Transform detectionOrigin;
    [SerializeField] private LayerMask objectsLayer;
    public Vector3 detectionOffset = new Vector3(0f, 0f, 1.2f);
    public Vector3 boxSize = new Vector3(10f, 1.2f, 2f);
    private bool useOriginRotation = false;
    private float outerRadius = 5f;
    private float innerRadius = 1f;
    private float smoothSpeed = 2f;

    [Header("Variables shader")]
    [SerializeField] private Color idleColor = Color.cyan;
    [SerializeField] private Color activeColor = Color.blue;
    [SerializeField] private string amplitudePropertyRef = "_WaveHeight";
    [SerializeField] private string waterColorRef = "_WaterColor";

    private float currentWaveIntensity;
    private Color currentWaterColor;

    [Header("Ajustes Visuales de Olas")]
    [SerializeField] private float minWaveHeight;
    [SerializeField] private float maxWaveHeight;

    [SerializeField] private Material waterMaterial;

    private void Awake()
    {
        currentWaterColor = idleColor;
        currentWaveIntensity = minWaveHeight;
    }

    void Update()
    {
        float proximity = ProximityFactor();
        float targetIntensity = Mathf.Lerp (minWaveHeight, maxWaveHeight, proximity);
        Color targetColor = Color.Lerp(idleColor, activeColor, proximity);

        currentWaveIntensity = Mathf.Lerp(currentWaveIntensity, targetIntensity, Time.deltaTime * smoothSpeed);
        currentWaterColor = Color.Lerp(currentWaterColor, targetColor, Time.deltaTime * smoothSpeed);

        ApplyToShader(currentWaveIntensity, currentWaterColor);
    }

    private Vector3 GetDetectionCenter()
    {
        Transform origin = detectionOrigin != null ? detectionOrigin : transform;
        return origin.position + origin.TransformDirection(detectionOffset);
    }

    private Quaternion GetDetectionRotation()
    {
        if (!useOriginRotation)
        {
            return Quaternion.identity;
        }

        Transform origin = detectionOrigin != null ? detectionOrigin : transform;
        return origin.rotation;
    }

    private float ProximityFactor()
    {
        Vector3 center = GetDetectionCenter();
        Quaternion rotation = GetDetectionRotation();

        Collider[] nearbyObjects = Physics.OverlapBox(center, boxSize * .5f, rotation, objectsLayer);

        if (nearbyObjects.Length == 0)
        {
            return 0f;
        }

        float closestDistance = outerRadius;

        foreach (Collider col in nearbyObjects)
        {
            float dist = Vector3.Distance(center, col.transform.position);
            if (dist < closestDistance)
            {
                closestDistance = dist;
            }
        }

        float t = Mathf.InverseLerp(outerRadius, innerRadius, closestDistance);
        return Mathf.Clamp01(t);
    }

    private void ApplyToShader(float level, Color color)
    {
        if (waterMaterial != null)
        {
            waterMaterial.SetFloat(amplitudePropertyRef, level);
            waterMaterial.SetColor(waterColorRef, color);
        }
    }

    void OnDrawGizmosSelected()

    {

        Vector3 center = GetDetectionCenter();

        Quaternion rotation = GetDetectionRotation();


        Gizmos.color = Color.yellow;

        Matrix4x4 oldMatrix = Gizmos.matrix;

        Gizmos.matrix = Matrix4x4.TRS(center, rotation, Vector3.one);

        Gizmos.DrawWireCube(Vector3.zero, boxSize);

        Gizmos.matrix = oldMatrix;

    }
}
