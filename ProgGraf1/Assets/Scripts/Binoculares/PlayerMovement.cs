using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerMovement : MonoBehaviour
{
    [SerializeField] private Animator _animator;
    [SerializeField] private float _movementSpeed = 5f;
    private Rigidbody _rb;
    private Vector3 _movementInput;

    public void Awake()
    {
        _rb = GetComponent<Rigidbody>();
        _rb.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
    }

    public void FixedUpdate()
    {
        var horizontalInput = Input.GetAxisRaw("Horizontal");
        var verticalInput = Input.GetAxisRaw("Vertical");

        _movementInput = (transform.forward * verticalInput) + (transform.right * horizontalInput);
        _movementInput.Normalize();

        Vector3 newVelocity = _movementInput * _movementSpeed;
        newVelocity.y = _rb.velocity.y;
        _rb.velocity = newVelocity;

        float speed = new Vector3(_rb.velocity.x, 0, _rb.velocity.z).magnitude;
        _animator.SetFloat("Speed", speed);
    }
}
