using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grid : MonoBehaviour
{
    #region Prefabs
    [Header("Prefabs")]
    public GameObject item1;
    #endregion

    #region GridSize
    [Header("Grid Size")]
    [SerializeField] private int _width = 10;
    [SerializeField] private int _height = 10;
    [SerializeField] private int _addGrid;
    public int offset = 5;
    #endregion

    #region Parameters
    private GameObject[,] _grid;
    #endregion
    public void Awake()
    {
        GenerateGrid();
    }

    public void GenerateGrid()
    {
        _grid = new GameObject[_width, _height];

        for (int x = 0; x < _width; x++)
        {
            for (int y = 0; y < _height; y++)
            {
                GameObject go = Instantiate(item1, new Vector3(x * offset, y * offset, 0), Quaternion.identity);
                go.name = $"Point_{x},{y}";
                _grid[x, y] = go;
            }
        }
    }
    public void SwitchItems()
    {

    }
}
