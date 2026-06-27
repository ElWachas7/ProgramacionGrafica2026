using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayMov2 : MonoBehaviour
{
    public float speed = 3f;

    void Update()
    {
        float input = 0f;
        if (Input.GetKey(KeyCode.W)) input = 1f;
        if (Input.GetKey(KeyCode.S)) input = -1f;

        transform.Translate(Vector3.up * input * speed * Time.deltaTime);
    }
}
