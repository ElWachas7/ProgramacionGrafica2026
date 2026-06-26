using UnityEngine;

[RequireComponent(typeof(SpriteRenderer))]
public class WaterInteraction : MonoBehaviour
{
    public Transform character;
    private Material mat;
    private SpriteRenderer sr;

    void Start()
    {
        sr = GetComponent<SpriteRenderer>();
        mat = sr.material;
    }

    void Update()
    {
        Vector3 local = transform.InverseTransformPoint(character.position);
        Bounds b = sr.localBounds;

        float u = (local.x - b.min.x) / b.size.x;
        float v = (local.y - b.min.y) / b.size.y;

        mat.SetVector("_InteractorUV", new Vector4(u, v, 0, 0));
    }
}