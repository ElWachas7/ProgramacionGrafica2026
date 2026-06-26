using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneManagerSingleton : MonoBehaviour
{
    public static SceneManagerSingleton Instance { get; private set; }

    [Header("Nombres de las 11 escenas (deben coincidir con Build Settings)")]
    [SerializeField] private string _scene1;
    [SerializeField] private string _scene2;
    [SerializeField] private string _scene3;
    [SerializeField] private string _scene4;
    [SerializeField] private string _scene5;
    [SerializeField] private string _scene7;
    [SerializeField] private string _scene8;
    [SerializeField] private string _scene9;
    [SerializeField] private string _scene11;

    [Header("Botones del Canvas")]
    [SerializeField] private Button botonAnterior;
    [SerializeField] private Button botonSiguiente;

    private string[] _scenes;
    private int _index;
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        DontDestroyOnLoad(gameObject);

        _scenes = new string[] { _scene8, _scene1, _scene2, _scene3, _scene4, _scene5, _scene7, _scene9, _scene11 };
    }

    /*private void Start()
    {
        botonAnterior.onClick.AddListener(PreviousScene);
        botonSiguiente.onClick.AddListener(NextScene);
    }*/
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && _scenes != null)
        {
            NextScene();
        }
        else if (Input.GetKeyDown(KeyCode.Q))
        {
            PreviousScene();
        }
            
    }

    public void LoadScene(int num)
    {
        _index = ((_index + num) % _scenes.Length + _scenes.Length) % _scenes.Length;
        SceneManager.LoadScene(_scenes[_index]);
    }

    public void NextScene() => LoadScene(1);
    public void PreviousScene() => LoadScene(-1);
}
