using UnityEngine;

[RequireComponent(typeof(Camera))]
public class WeatherPostProcessEffect : MonoBehaviour
{
    [Header("Shaders")]
    [SerializeField] private Shader sunnyShader;
    [SerializeField] private Shader rainyShader;
    [SerializeField] private Shader snowyShader;

    [Header("Sunny Settings")]
    [SerializeField] private Color sunnyColor = Color.white;
    [SerializeField] private Color rayColor = new Color(1f, 0.95f, 0.7f);

    [SerializeField, Range(0.5f, 2f)]
    private float sunnyBrightness = 1.1f;

    [SerializeField, Range(0f, 0.8f)]
    private float rayIntensity = 0.05f;

    [SerializeField, Range(0f, 2f)]
    private float raySpeed = 0.3f;

    [SerializeField, Range(1f, 20f)]
    private float rayFrequency = 15f;

    private Material sunnyMaterial;
    private Material rainyMaterial;
    private Material snowyMaterial;

    [Header("Rainy Settings")]
    [SerializeField] private Color rainyColor = Color.white;
    [SerializeField, Range(0.5f, 2f)]
    private float rainyBrightness = 1.1f;
    [SerializeField, Range(2f, 3f)]
    private float rainSpeed = 2.5f;

    [Header("Snowy Settings")]
    [SerializeField] private Color snowyColor = Color.white;
    [SerializeField, Range(0.5f, 2f)]
    private float snowyBrightness = 1.1f;
    [SerializeField, Range(0f, 2f)]
    private float snowSpeed = 0.5f;
    private void Awake()
    {
        if (sunnyShader != null)
            sunnyMaterial = new Material(sunnyShader);

        if (rainyShader != null)
            rainyMaterial = new Material(rainyShader);

        if (snowyShader != null)
            snowyMaterial = new Material(snowyShader);
    }

    private void Update()
    {
        UpdateSunnyProperties();
        UpdateRainyProperties();
        UpdateSnowyProperties();
    }

    private void UpdateSunnyProperties()
    {
        if (sunnyMaterial == null)
            return;

        sunnyMaterial.SetColor("_SunnyColor", sunnyColor);
        sunnyMaterial.SetColor("_RayColor", rayColor);
        sunnyMaterial.SetFloat("_Brightness", sunnyBrightness);
        sunnyMaterial.SetFloat("_RayIntensity", rayIntensity);
        sunnyMaterial.SetFloat("_RaySpeed", raySpeed);
        sunnyMaterial.SetFloat("_RayFrequency", rayFrequency);
    }
    private void UpdateRainyProperties()
    {
        if (rainyMaterial == null)
            return;

        rainyMaterial.SetColor("_RainyColor", rainyColor);
        rainyMaterial.SetFloat("_RainyBrightness", rainyBrightness);
        rainyMaterial.SetFloat("_RainSpeed", rainSpeed);
    }
    private void UpdateSnowyProperties()
    {
        if (rainyMaterial == null)
            return;

        snowyMaterial.SetColor("_SnowColor", snowyColor);
        snowyMaterial.SetFloat("_SnowyBrightness", snowyBrightness);
        snowyMaterial.SetFloat("_SnowSpeed", snowSpeed);
    }

    private void OnRenderImage(
        RenderTexture source,
        RenderTexture destination)
    {
        Material currentMaterial = GetCurrentWeatherMaterial();

        if (currentMaterial != null)
        {
            Graphics.Blit(source, destination, currentMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private Material GetCurrentWeatherMaterial()
    {
        if (WeatherManager.Instance == null)
            return null;

        switch (WeatherManager.Instance.CurrentWeather)
        {
            case WeatherManager.WeatherState.Sunny:
                return sunnyMaterial;

            case WeatherManager.WeatherState.Rainy:
                return rainyMaterial;

            case WeatherManager.WeatherState.Snowy:
                return snowyMaterial;

            case WeatherManager.WeatherState.None:
            default:
                return null;
        }
    }

    private void OnDestroy()
    {
        DestroyMaterial(sunnyMaterial);
        DestroyMaterial(rainyMaterial);
        DestroyMaterial(snowyMaterial);
    }

    private void DestroyMaterial(Material materialToDestroy)
    {
        if (materialToDestroy != null)
        {
            Destroy(materialToDestroy);
        }
    }
}