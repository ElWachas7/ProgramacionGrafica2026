using UnityEngine;

public class WeatherManager : MonoBehaviour
{
    public enum WeatherState
    {
        None,
        Sunny,
        Rainy,
        Snowy
    }

    public static WeatherManager Instance { get; private set; }

    [Header("Referencias")]
    [SerializeField] private Camera mainCamera;

    [Header("Estado actual")]
    [SerializeField]
    private WeatherState currentWeather = WeatherState.None;

    private WeatherCard selectedCard;

    public WeatherState CurrentWeather => currentWeather;

    private void Awake()
    {
        Instance = this;

        currentWeather = WeatherState.None;

        if (mainCamera == null)
        {
            mainCamera = Camera.main;
        }
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            CheckMouseClick();
        }
    }

    private void CheckMouseClick()
    {
        if (mainCamera == null)
            return;

        Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out RaycastHit hit))
        {
            WeatherCard clickedCard =
                hit.collider.GetComponentInParent<WeatherCard>();

            if (clickedCard != null)
            {
                SelectCard(
                    clickedCard,
                    clickedCard.WeatherState
                );

                return;
            }
        }

        // Si no tocó una carta, limpiamos la selección.
        ClearSelection();
    }

    public void SelectCard(
        WeatherCard card,
        WeatherState weatherState)
    {
        if (card == null)
            return;

        if (selectedCard != null && selectedCard != card)
        {
            selectedCard.Deselect();
        }

        selectedCard = card;
        selectedCard.Select();

        currentWeather = weatherState;

        Debug.Log("Estado actual: " + currentWeather);
    }

    public void ClearSelection()
    {
        if (selectedCard != null)
        {
            selectedCard.Deselect();
            selectedCard = null;
        }

        currentWeather = WeatherState.None;

        Debug.Log("Estado actual: " + currentWeather);
    }
}