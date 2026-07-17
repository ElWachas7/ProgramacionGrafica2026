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
    bool _shieldOn;
    Coroutine _disolveCoroutine;
    void Start()
    {
        _renderer = GetComponent<Renderer>();
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
        StopAllCoroutines();
        StartCoroutine(Coroutine_HitDisplacement());
    }

    public void OpenCloseShield()
    {
        float target = 2f;

        if (_shieldOn)
        {
            target = -1f;
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

        while (lerp < 1)
        {
            _renderer.material.SetFloat("_displacementStrenght", _DisplacementCurve.Evaluate(lerp) * _DisplacementMagnitude);
            lerp += Time.deltaTime * _LerpSpeed;
            yield return null;
        }
        float valorActual = _renderer.material.GetFloat("_displacementStrenght");
        float lerpRegreso = 0;
        float velocidadRegreso = 4f;

        while (lerpRegreso < 1)
        {
            float nuevoValor = Mathf.Lerp(valorActual, 0f, lerpRegreso);
            _renderer.material.SetFloat("_displacementStrenght", nuevoValor);

            lerpRegreso += Time.deltaTime * velocidadRegreso;
            yield return null;
        }
        _renderer.material.SetFloat("_displacementStrenght", 0f);
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
