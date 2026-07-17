using UnityEngine;

public class WeatherCard : MonoBehaviour
{
    [Header("Clima de esta carta")]
    [SerializeField] private WeatherManager.WeatherState weatherState;

    [Header("Movimiento")]
    [SerializeField] private Transform selectedPos;
    [SerializeField] private float moveSpeed = 8f;

    [Header("Rotación")]
    [SerializeField] private float rotationSmoothness = 8f;
    [SerializeField] private float sensitivity = 20f;
    [SerializeField] private float maxHorizontalAngle = 20f;
    [SerializeField] private float maxVerticalAngle = 15f;

    private Vector3 initialLocalPosition;
    private Quaternion initialLocalRotation;
    private bool isSelected;

    public WeatherManager.WeatherState WeatherState => weatherState;

    private void Awake()
    {
        initialLocalPosition = transform.localPosition;
        initialLocalRotation = transform.localRotation;
    }

    private void Update()
    {
        Vector3 targetPosition = isSelected && selectedPos != null
            ? selectedPos.localPosition
            : initialLocalPosition;

        transform.localPosition = Vector3.Lerp(
            transform.localPosition,
            targetPosition,
            moveSpeed * Time.deltaTime
        );

        if (isSelected)
        {
            RotateCard();
        }
        else
        {
            transform.localRotation = Quaternion.Slerp(
                transform.localRotation,
                initialLocalRotation,
                moveSpeed * Time.deltaTime
            );
        }

        if (Input.GetKeyDown(KeyCode.R) && isSelected)
        {
            WeatherManager.Instance.ClearSelection();
        }
    }

    public void Select()
    {
        isSelected = true;
    }

    public void Deselect()
    {
        isSelected = false;
    }

    private void RotateCard()
    {
        float mouseX =
            (Input.mousePosition.x / Screen.width - 0.5f) * 2f;

        float mouseY =
            (Input.mousePosition.y / Screen.height - 0.5f) * 2f;

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