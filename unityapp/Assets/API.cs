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
    [DllImport("__Internal")]
    public static extern void sendUnityStateUpdate(string state);
}


public class API : MonoBehaviour
{
    void Start()
    {
        #if UNITY_IOS
        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            HostNativeAPI.sendUnityStateUpdate("ready");
        }
        #endif
    }
}
