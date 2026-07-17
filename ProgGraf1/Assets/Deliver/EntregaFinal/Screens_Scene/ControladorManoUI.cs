using System.Collections;
using UnityEngine;

public class ControladorManoUI : MonoBehaviour
{
    [Header("Referencias")]
    [SerializeField] private Transform manoTransform; // Arrastrá el FBX de tu mano acá

    [Header("Configuración de Rotación (Eje Y)")]
    [SerializeField] private float anguloYAlSacar = 0f;    // Ángulo en Y cuando la mano NO está en pantalla
    [SerializeField] private float anguloYAlPoner = 90f;   // Ángulo en Y cuando la mano SÍ está en pantalla
    [SerializeField] private float duracion = 0.5f;        // Tiempo que tarda el movimiento (en segundos)

    private Coroutine rotacionCoroutine;
    private float anguloActualObjetivo;

    private void Start()
    {
        // Opcional: Inicializar la mano en la posición de "sacar" al empezar el juego
        if (manoTransform != null)
        {
            Vector3 angles = manoTransform.rotation.eulerAngles;
            manoTransform.rotation = Quaternion.Euler(angles.x, anguloYAlSacar, angles.z);
            anguloActualObjetivo = anguloYAlSacar;
        }
    }

    // Método para el botón "Poner Mano"
    public void PonerMano()
    {
        CalcularRotacion(anguloYAlPoner);
    }

    // Método para el botón "Sacar Mano"
    public void SacarMano()
    {
        CalcularRotacion(anguloYAlSacar);
    }

    private void CalcularRotacion(float anguloDestino)
    {
        // Si ya está yendo a ese ángulo o ya llegó, no hace falta recalcular nada
        if (Mathf.Approximately(anguloActualObjetivo, anguloDestino)) return;

        anguloActualObjetivo = anguloDestino;

        if (rotacionCoroutine != null)
        {
            StopCoroutine(rotacionCoroutine);
        }

        rotacionCoroutine = StartCoroutine(DoRotacionMano(anguloDestino));
    }

    private IEnumerator DoRotacionMano(float targetAngle)
    {
        float elapsedTime = 0f;
        Quaternion startRotation = manoTransform.rotation;

        // Conservamos los ejes X y Z originales del FBX para no deformar su postura
        Vector3 currentAngles = startRotation.eulerAngles;
        Quaternion targetRotation = Quaternion.Euler(currentAngles.x, targetAngle, currentAngles.z);

        while (elapsedTime < duracion)
        {
            elapsedTime += Time.deltaTime;
            float t = elapsedTime / duracion;

            // Suavizado Ease-In-Out para que el movimiento sea orgánico
            t = Mathf.SmoothStep(0f, 1f, t);

            manoTransform.rotation = Quaternion.Slerp(startRotation, targetRotation, t);
            yield return null;
        }

        manoTransform.rotation = targetRotation;
        rotacionCoroutine = null;
    }
}