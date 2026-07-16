using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CambioEscena : MonoBehaviour
{
    [SerializeField] private string PI_01;

    // Se ejecuta cuando un objeto con Collider entra en el Trigger
    private void OnTriggerEnter(Collider other)
    {
        // Comparamos si el objeto que entró tiene la etiqueta "Player"
        if (other.CompareTag("Player"))
        {
            SceneManager.LoadScene(PI_01);
        }
    }
}
