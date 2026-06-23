using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShinyItemsManager : MonoBehaviour
{
    [SerializeField] private Transform _player;
    [SerializeField] private List<Material> _items = new List<Material>();
    void Update()
    {
        foreach (Material mat in _items)
        {
            mat.SetVector("_Player", _player.position);
        }
    }
}
