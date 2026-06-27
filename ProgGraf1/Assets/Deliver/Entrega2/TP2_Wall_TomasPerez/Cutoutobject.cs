using System.Collections;
using System.Collections.Generic;
using System.Runtime.ExceptionServices;
using UnityEngine;

public class Cutoutobject : MonoBehaviour
{
    public static int PosID = Shader.PropertyToID("_Player");

    [SerializeField] private Transform targetObject;
    [SerializeField] Material material;
    public LayerMask mask;

    [SerializeField] private Camera _mainCamera;

    private void Update()
    {
        var dir = _mainCamera.transform.position - transform.position;
        var ray = new Ray(transform.position, dir.normalized);

        if (Physics.Raycast(ray, 20000, mask))
        {
            material.SetFloat("_CutoutSize", 0.1f);
            material.SetFloat("_FalloffSize", 0.05f);
            Debug.Log("Por detras");
        }
        else
        {
            material.SetFloat("_CutoutSize", 0f);
            material.SetFloat("_FalloffSize", 0f);
            Debug.Log("Por delante");
        }
        Vector3 view = _mainCamera.WorldToViewportPoint(targetObject.position);
        material.SetVector(PosID, view);
    }
}
