using UnityEngine;
using UnityEditor;
using System;

public class MyShaderGUI : ShaderGUI
{

    MaterialProperty srcMode = null;
    MaterialProperty dstMode = null;
    MaterialProperty zTest = null;
    MaterialProperty zWrite = null;

    MaterialEditor m_MaterialEditor;

    public void FindProperties(MaterialProperty[] props)
    {
        srcMode = FindProperty("_SrcBlend", props, false);
        dstMode = FindProperty("_DstBlend", props, false);
        zTest = FindProperty("_ZTest", props, false);
        zWrite = FindProperty("_ZWrite", props, false);
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        // render the default gui
        base.OnGUI(materialEditor, props);

        FindProperties(props);
       
        m_MaterialEditor = materialEditor;
        Material material = materialEditor.target as Material;

        EditorGUI.BeginChangeCheck();

        EditorGUILayout.Space();

        MaterialZWriteTestMode();
        MaterialBlendMode();

    }


    void MaterialZWriteTestMode()
    {

        //ZWrite
        EditorGUILayout.BeginHorizontal();

        EditorGUI.showMixedValue = zWrite.hasMixedValue;

        bool zwrite = zWrite.floatValue == 1f;

        EditorGUI.BeginChangeCheck();
        zwrite = EditorGUILayout.Toggle("ZWrite", zwrite);
        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo("Z Write");
            zWrite.floatValue = zwrite ? 1f : 0f;
        }
        EditorGUI.showMixedValue = false;
        EditorGUILayout.EndHorizontal();

        //ZTest
        EditorGUILayout.BeginHorizontal();
        GUILayout.Label("ZTest:");

        EditorGUI.showMixedValue = zTest.hasMixedValue;

        var modeSrc = (UnityEngine.Rendering.CompareFunction)zTest.floatValue;

        EditorGUI.BeginChangeCheck();
        string[] opt0 = Enum.GetNames(typeof(UnityEngine.Rendering.CompareFunction));
        modeSrc = (UnityEngine.Rendering.CompareFunction)EditorGUILayout.Popup((int)modeSrc, opt0);
        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo("Z Test");
            zTest.floatValue = (float)modeSrc;
        }
        EditorGUI.showMixedValue = false;
        EditorGUILayout.EndHorizontal();
    }


    void MaterialBlendMode() {
        EditorGUILayout.BeginHorizontal();
        
        //Src block
        EditorGUILayout.BeginVertical();
        GUILayout.Label("Src mode:");
        EditorGUI.showMixedValue = srcMode.hasMixedValue;
        var modeSrc = (UnityEngine.Rendering.BlendMode)srcMode.floatValue;
        EditorGUI.BeginChangeCheck();
        string[] opt0 = Enum.GetNames(typeof(UnityEngine.Rendering.BlendMode));
        modeSrc = (UnityEngine.Rendering.BlendMode)EditorGUILayout.Popup((int)modeSrc, opt0);
        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo("Src Mode");
            srcMode.floatValue = (float)modeSrc;
        }
        EditorGUI.showMixedValue = false;
        EditorGUILayout.EndVertical();

        //DstBlock
        EditorGUILayout.BeginVertical();
        GUILayout.Label("Dst mode:");
        EditorGUI.showMixedValue = dstMode.hasMixedValue;
        var modeDst = (UnityEngine.Rendering.BlendMode)dstMode.floatValue;

        EditorGUI.BeginChangeCheck();
        string[] opt1 = Enum.GetNames(typeof(UnityEngine.Rendering.BlendMode));
        modeDst = (UnityEngine.Rendering.BlendMode)EditorGUILayout.Popup((int)modeDst, opt1);
        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo("Src Mode");
            dstMode.floatValue = (float)modeDst;
        }
        EditorGUI.showMixedValue = false;
        EditorGUILayout.EndVertical();

        EditorGUILayout.EndHorizontal();
    }

}
