using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine.UI;
using UnityEngine;
using AOT;

/// <summary>
/// ホストが公開するC-API、すなわちUnity -> Host API。
/// </summary>
public class HostNativeAPI
{
    public delegate void TestDelegate(string name);

    [DllImport("__Internal")]
    public static extern void sendUnityStateUpdate(string state);

    [DllImport("__Internal")]
    public static extern void setTestDelegate(TestDelegate cb);
}

/// <summary>
/// Unityが公開するC-API、つまりホスト -> Unity API。
/// </summary>
public class UnityNativeAPI
{
    [MonoPInvokeCallback(typeof(HostNativeAPI.TestDelegate))]
    public static void test(string name)
    {
        Debug.Log("This static function has been called from iOS!");
        Debug.Log(name);
    }
}


public class API : MonoBehaviour
{
    void Start()
    {
        #if UNITY_IOS
        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            HostNativeAPI.setTestDelegate(UnityNativeAPI.test);
            HostNativeAPI.sendUnityStateUpdate("ready");
        }
        #endif
    }
}
