using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WriterController : MonoBehaviour
{
    [SerializeField] private GameObject[] writerObjects;
    [SerializeField] private float writerSize;

    private void Start()
    {
        ChangeWriterSize();
    }
    private void Update()
    {
        ChangeWriterSize();
    }
    public void SetWriterSize(float newSize)
    {
        Debug.Log("nuevo tamaño: " + newSize);
        writerSize = newSize;
        ChangeWriterSize();
    }
    void ChangeWriterSize()
    {
        foreach (var writer in writerObjects)
        {
            writer.transform.localScale = new Vector3(writerSize,writerSize,writerSize);
        }
        
    }
}
