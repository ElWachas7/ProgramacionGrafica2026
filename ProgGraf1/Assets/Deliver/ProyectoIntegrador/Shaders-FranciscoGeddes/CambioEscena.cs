using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
   

public class CambioEscena : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            // Reemplaza "NombreDeTuEscena" por el nombre exacto de tu escena
            SceneManager.LoadScene("PI_01");
        }
    }
}