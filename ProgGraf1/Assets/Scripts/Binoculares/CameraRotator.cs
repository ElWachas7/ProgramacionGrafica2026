using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotator : MonoBehaviour
{
    public Vector2 turn;
    public float sensitivity = 0.5f;
    private Rigidbody _parentRb;

    private void Start()
    {
        UnityEngine.Cursor.visible = false;
        UnityEngine.Cursor.lockState = CursorLockMode.Locked;
        _parentRb = transform.parent.GetComponent<Rigidbody>();
    }

    private void Update()
    {
        turn.y += Input.GetAxis("Mouse Y") * sensitivity;
        turn.x += Input.GetAxis("Mouse X") * sensitivity;
        transform.localRotation = Quaternion.Euler(-turn.y, 0, 0);

        if (_parentRb != null)
            _parentRb.MoveRotation(Quaternion.Euler(0, turn.x, 0));
        else
            transform.parent.localRotation = Quaternion.Euler(0, turn.x, 0);
    }
}
