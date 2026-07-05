using UnityEngine;

public class LookAtCamera : MonoBehaviour
{
    [SerializeField] Camera _cam;
    private void Start()
    {
        _cam = Camera.main;
    }
    private void Update()
    {
        transform.forward = _cam.transform.position - transform.position;
    }
}
