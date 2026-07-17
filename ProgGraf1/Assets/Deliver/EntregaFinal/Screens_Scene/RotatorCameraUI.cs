using System.Collections;
using UnityEngine;

public class RotatorCameraUI : MonoBehaviour
{
    [Header("Configuración de Cámara")]
    [SerializeField] private Transform cameraTransform; // Arrastrá tu cámara acá
    [SerializeField] private float duration = 0.5f;      // Cuánto tarda en rotar (en segundos)

    private Coroutine rotationCoroutine;

    /// <summary>
    /// Método público para llamar desde los botones de la UI
    /// </summary>
    /// <param name="targetYRotation">El ángulo en Y al que querés que vaya</param>
    public void RotateToY(float targetYRotation)
    {
        // Si ya se está moviendo, frenamos la rotación anterior para que no apilen
        if (rotationCoroutine != null)
        {
            StopCoroutine(rotationCoroutine);
        }

        // Iniciamos la nueva rotación suave
        rotationCoroutine = StartCoroutine(DoRotationY(targetYRotation));
    }

    private IEnumerator DoRotationY(float targetAngle)
    {
        float elapsedTime = 0f;

        // Guardamos las rotaciones quaternion actuales y de destino
        Quaternion startRotation = cameraTransform.rotation;

        // Mantener las rotaciones actuales de X y Z para que solo cambie la Y
        Vector3 currentAngles = startRotation.eulerAngles;
        Quaternion targetRotation = Quaternion.Euler(currentAngles.x, targetAngle, currentAngles.z);

        while (elapsedTime < duration)
        {
            elapsedTime += Time.deltaTime;
            float t = elapsedTime / duration;

            // Suaviza el inicio y el final de la rotación (Ease-In-Out)
            t = Mathf.SmoothStep(0f, 1f, t);

            cameraTransform.rotation = Quaternion.Slerp(startRotation, targetRotation, t);
            yield return null;
        }

        // Aseguramos que quede exactamente en el ángulo final
        cameraTransform.rotation = targetRotation;
        rotationCoroutine = null;
    }
}