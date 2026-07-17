using UnityEngine;

public class IntersectionTrigger : MonoBehaviour
{
    private Material screenMaterial;
    private float rippleTime = -0.1f;
    private bool isColliding = false;

    [Header("Configuración de la Onda")]
    [Tooltip("Cuánto tarda cada aro en expandirse y desaparecer antes de que salga el siguiente")]
    [SerializeField] private float ringDuration = 0.5f;

    void Start()
    {
        // Buscamos el renderer en este objeto o en los hijos
        Renderer renderer = GetComponentInChildren<Renderer>();
        if (renderer != null)
        {
            screenMaterial = renderer.material;
        }
    }

    // Se ejecuta una sola vez cuando el Player entra en contacto
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            isColliding = true;
            if (screenMaterial != null)
            {
                // Clavamos el impacto en el centro
                screenMaterial.SetVector("_ImpactUV", new Vector4(0.4f, 0.5f, 0f, 0f));
            }
        }
    }

    // Se ejecuta una sola vez cuando el Player deja de tocar la pantalla
    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            isColliding = false;
            rippleTime = 0f; // Reseteamos el contador

            if (screenMaterial != null)
            {
                // Apagamos el shader al toque poniendo el tiempo en 0
                screenMaterial.SetFloat("_RippleTime", -0.1f);
            }
        }
    }

    void Update()
    {
        // Mientras el jugador esté colisionando, corremos y loopeamos el efecto
        if (isColliding && screenMaterial != null)
        {
            rippleTime += Time.deltaTime;

            // Si el aro actual ya completó su recorrido, lo reiniciamos a 0 para que nazca otro nuevo
            if (rippleTime > ringDuration)
            {
                rippleTime = -0.1f;
            }

            screenMaterial.SetFloat("_RippleTime", rippleTime);
        }
    }
}