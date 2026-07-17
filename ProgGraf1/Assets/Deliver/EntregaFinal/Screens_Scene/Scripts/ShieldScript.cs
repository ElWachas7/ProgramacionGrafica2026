using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShieldScript : MonoBehaviour
{
    Renderer _renderer;
    [SerializeField] AnimationCurve _DisplacementCurve;
    [SerializeField] float _DisplacementMagnitude;
    [SerializeField] float _LerpSpeed;
    [SerializeField] float _DisolveSpeed;

    [Header("Configuración de Colores")]
    [SerializeField] Color[] _shieldColors = new Color[3];
    private int _currentColorIndex = 0;

    bool _shieldOn;
    Coroutine _disolveCoroutine;
    Coroutine _hitCoroutine; 

    void Start()
    {
        _renderer = GetComponent<Renderer>();
        if (_shieldColors.Length > 0)
        {
            _renderer.material.SetColor("_shieldColor", _shieldColors[0]);
        }
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(1))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                HitShield(hit.point);
            }
        }
        if (Input.GetKeyDown(KeyCode.F))
        {
            OpenCloseShield();
        }
    }

    public void HitShield(Vector3 hitPos)
    {
        _renderer.material.SetVector("_hitPos", hitPos);

        _currentColorIndex++;
        if (_currentColorIndex >= _shieldColors.Length)
        {
            OpenCloseShield();
            return;
        }
        _renderer.material.SetColor("_shieldColor", _shieldColors[_currentColorIndex]);

        if (_hitCoroutine != null) StopCoroutine(_hitCoroutine);
        _hitCoroutine = StartCoroutine(Coroutine_HitDisplacement());
    }

    public void OpenCloseShield()
    {
        float target = 2f;

        if (!_shieldOn)
        {
            target = -1f;

            _currentColorIndex = 0;
            if (_shieldColors.Length > 0)
            {
                _renderer.material.SetColor("_shieldColor", _shieldColors[0]);
            }
        }

        _shieldOn = !_shieldOn;

        if (_disolveCoroutine != null)
        {
            StopCoroutine(_disolveCoroutine);
        }
        _disolveCoroutine = StartCoroutine(Coroutine_DisolveShield(target));
    }

    IEnumerator Coroutine_HitDisplacement()
    {
        float lerp = 0;
        float valorInicial = 0f;
        float valorMaximo = _DisplacementMagnitude;

        while (lerp < 1)
        {
            float tiempoCurva = Mathf.Clamp01(lerp);
            float factorInterpolacion = _DisplacementCurve.Evaluate(tiempoCurva);
            float valorFinal = Mathf.Lerp(valorInicial, valorMaximo, factorInterpolacion);

            _renderer.material.SetFloat("_displacementStrenght", valorFinal);

            lerp += Time.deltaTime * _LerpSpeed;
            yield return null;
        }

        _renderer.material.SetFloat("_displacementStrenght", valorInicial);
    }

    IEnumerator Coroutine_DisolveShield(float target)
    {
        float start = _renderer.material.GetFloat("_disolve");
        float lerp = 0;

        while (lerp < 1)
        {
            lerp += Time.deltaTime * _DisolveSpeed;
            float tiempoLerp = Mathf.Clamp01(lerp);
            _renderer.material.SetFloat("_disolve", Mathf.Lerp(start, target, tiempoLerp));

            yield return null;
        }
    }
}
