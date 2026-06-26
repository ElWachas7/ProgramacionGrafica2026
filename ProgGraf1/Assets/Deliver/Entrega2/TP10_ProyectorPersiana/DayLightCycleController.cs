using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DayLightCycleController : MonoBehaviour
{
    [Range(0f, 24f)]
    public float timeOfDay = 12f;
    
    private Material surfaceMaterial;
    
    void Start()
    {
        surfaceMaterial = GetComponent<Renderer>().material;
    }
    
    void Update()
    {
        // Normalizar a 0-1 (0 = medianoche, 0.5 = mediodía)
        float normalizedTime = timeOfDay / 24f;
        surfaceMaterial.SetFloat("_TimeOfDay", normalizedTime);
        
        // Opcional: auto-avance
        // timeOfDay += Time.deltaTime * 0.5f; // velocidad de día
        // if (timeOfDay >= 24f) timeOfDay = 0f;
    }
}
