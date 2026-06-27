using UnityEngine;

public class MouseRotateObject : MonoBehaviour
{
    [SerializeField] private float maxAngle = 15f;
    [SerializeField] private float smoothness = 10f;
    [SerializeField] private float sensitivity = 1f;

    private Camera cam;

    private void Awake()
    {
        cam = Camera.main;
    }

    private void Update()
    {
        Vector3 cardScreenPos = cam.WorldToScreenPoint(transform.position);

        float mouseX = (Input.mousePosition.x - cardScreenPos.x) / (Screen.width * 0.5f);
        float mouseY = (Input.mousePosition.y - cardScreenPos.y) / (Screen.height * 0.5f);

        mouseX = Mathf.Clamp(mouseX * sensitivity, -1f, 1f);
        mouseY = Mathf.Clamp(mouseY * sensitivity, -1f, 1f);

        float targetX = -mouseY * maxAngle;
        float targetY = mouseX * maxAngle;

        Quaternion targetRotation = Quaternion.Euler(targetX, targetY, 0f);

        transform.localRotation = Quaternion.Slerp(
            transform.localRotation,
            targetRotation,
            smoothness * Time.deltaTime
        );

        if (Input.GetKeyDown(KeyCode.R))
        {
            transform.localRotation = Quaternion.identity;
        }
    }
}