using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterImpact : MonoBehaviour
{
    private Renderer render;
    private MaterialPropertyBlock propBlock;
    private int IDImpact;

    void Start()
    {
        render = GetComponent<Renderer>();
        propBlock = new MaterialPropertyBlock();
        IDImpact = Shader.PropertyToID("ImpactPosition");
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("¡ALGO tocó el agua! Fue el objeto: " + other.gameObject.name);

        if (other.CompareTag("Player"))
        {
            GenerarOnda(other.transform.position);
            Debug.Log("Objeto ENTRÓ al agua");
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            GenerarOnda(other.transform.position);
            Debug.Log("Objeto SALIÓ del agua");
        }
    }
    private void GenerarOnda(Vector3 posicion)
    {
        render.GetPropertyBlock(propBlock);

        propBlock.SetVector(IDImpact, posicion);

        render.SetPropertyBlock(propBlock);
    }
}
