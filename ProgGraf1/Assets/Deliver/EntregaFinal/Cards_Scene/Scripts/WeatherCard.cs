using UnityEngine;

public class WeatherCard : MonoBehaviour
{
    [Header("Clima de esta carta")]
    [SerializeField] private WeatherManager.WeatherState weatherState;

    [Header("Movimiento")]
    [SerializeField] private Transform selectedPos;
    private float moveSpeed = 8f;

    [Header("Hover")]
    private float hoverHeight = 0.35f;

    [Header("Rotación")]
    private float rotationSmoothness = 8f;
    private float sensitivity = 5f;
    private float maxHorizontalAngle = 3f;
    private float maxVerticalAngle = 2f;

    private Vector3 initialLocalPosition;
    private Quaternion initialLocalRotation;

    private bool isSelected;
    private bool isHovered;

    public WeatherManager.WeatherState WeatherState => weatherState;

    private void Awake()
    {
        initialLocalPosition = transform.localPosition;
        initialLocalRotation = transform.localRotation;
    }

    private void Update()
    {
        UpdatePosition();
        UpdateRotation();

        if (Input.GetKeyDown(KeyCode.R) && isSelected)
        {
            WeatherManager.Instance.ClearSelection();
        }
    }

    private void UpdatePosition()
    {
        Vector3 targetPosition = initialLocalPosition;

        if (isHovered)
        {
            targetPosition += Vector3.up * hoverHeight;
        }

        if (isSelected && selectedPos != null)
        {
            targetPosition = selectedPos.localPosition;
        }

        transform.localPosition = Vector3.Lerp(
            transform.localPosition,
            targetPosition,
            moveSpeed * Time.deltaTime
        );
    }

    private void UpdateRotation()
    {
        if (isSelected)
        {
            RotateCard();
        }
        else
        {
            transform.localRotation = Quaternion.Slerp(
                transform.localRotation,
                initialLocalRotation,
                rotationSmoothness * Time.deltaTime
            );
        }
    }

    public void Select()
    {
        isSelected = true;
        isHovered = false;
    }

    public void Deselect()
    {
        isSelected = false;
    }

    private void OnMouseEnter()
    {
        if (!isSelected)
        {
            isHovered = true;
        }
    }

    private void OnMouseExit()
    {
        isHovered = false;
    }

    private void RotateCard()
    {
        float mouseX = (Input.mousePosition.x / Screen.width - 0.5f) * 2f;
        float mouseY = (Input.mousePosition.y / Screen.height - 0.5f) * 2f;

        float targetY = Mathf.Clamp(
            mouseX * sensitivity,
            -maxHorizontalAngle,
            maxHorizontalAngle
        );

        float targetX = Mathf.Clamp(
            -mouseY * sensitivity,
            -maxVerticalAngle,
            maxVerticalAngle
        );

        Quaternion targetRotation =
            initialLocalRotation *
            Quaternion.Euler(targetX, targetY, 0f);

        transform.localRotation = Quaternion.Slerp(
            transform.localRotation,
            targetRotation,
            rotationSmoothness * Time.deltaTime
        );
    }
}