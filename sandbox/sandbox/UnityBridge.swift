//
//  UnityBridge.swift
//  sandbox
//
//  Created by 長政輝 on 2023/06/29.
//

import Foundation
import UnityFramework

class API: NativeCallsProtocol {
    
    internal weak var bridge: UnityBridge!
    
    /**
     内部メソッドはUnityによって呼び出される
     このオブジェクトは、`FrameworkLibAPI.registerAPIforNativeCalls(api)`を使用して、
     これらの呼び出しのリスナーとして登録されます。
             これらの呼び出しはUnityからネイティブアプリに転送されます。
     */
    
    internal func onUnityStateChange(_ state: String) {
        switch (state) {
        case "ready":
            self.bridge.unityGotReady()
        default:
            return
        }
    }
    
    internal func onSetTestDelegate(_ delegate: TestDelegate!) {}
    
}

class UnityBridge: UIResponder, UIApplicationDelegate, UnityFrameworkListener {
    public internal(set) var isReady: Bool = false
    
    public var api: API
    
    public var onReady: () -> Void = {}
    
    private static var instance: UnityBridge?
    
    /// UnityFramework instance
    private let ufw: UnityFramework
    
    /// UnityFramework root view
    public var view: UIView? { ufw.appController()?.rootView }
    
    public static func getInstance() -> UnityBridge {
        if UnityBridge.instance == nil {
            UnityBridge.instance = UnityBridge()
        }
        return UnityBridge.instance!
    }
    
    /// Loads the UnityFramework from the bundle path
    ///
    /// - Returns: The UnityFramework instance
    private static func loadUnityFramework() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + "/Frameworks/UnityFramework.framework"
        let bundle = Bundle(path: bundlePath)
        if bundle?.isLoaded == false {
            bundle?.load()
        }
        
        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
            machineHeader.pointee = _mh_execute_header
            ufw!.setExecuteHeader(machineHeader)
        }
        return ufw
    }
    
    override internal init() {
        ufw = UnityBridge.loadUnityFramework()!
        ufw.setDataBundleId("com.unity3d.framework")
        api = API()
        
        super.init()
        
        api.bridge = self
        ufw.register(self)
        // これは `api` オブジェクトの登録を呼び出す。
        // 登録されると、Unityコール は `api` インスタンスに転送される。
        FrameworkLibAPI.registerAPIforNativeCalls(api)
        
        ufw.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
    }
    
    /// Notifies the UnityFramework to show the window, and append the Unity view to the given controller
    /// 訳: UnityFrameworkにウィンドウを表示するように通知し、Unityビューを指定されたコントローラに追加します。
    ///
    /// - Parameter controller: Controller that will host the Unity view
    public func show(controller: UIViewController) {
        if isReady {
            ufw.showUnityWindow()
        }
        if let view = self.view {
            controller.view?.addSubview(view)
        }
    }
    
    internal func unityGotReady() {
        isReady = true
        onReady()
    }
    
    /// Unloads the Unity framework
    ///
    /// ## Notes
    ///
    /// * Unloading dowsn't seem to free memory, or it's not picked up by the XCode dev tools.
    /// * 訳: アンロードしてもメモリは解放されないようです。
    /// * Unloading isn't synchronous, and this object will be notified in the `unityDidUnload` method
    /// * 訳: アンロードは同期ではなく、このオブジェクトは `unityDidUnload` メソッドで通知される。
    public func unload() {
        ufw.unloadApplication()
    }
    
    /// Triggered by Unity via `UnityFrameworkListenier` when the framework unloaded
    /// 訳: UnityFrameworkListenier` 経由でフレームワークのアンロード時にUnityによってトリガーされる。
    internal func unityDidUnload(_ notification: Notification!) {
        ufw.unregisterFrameworkListener(self)
        UnityBridge.instance = nil
    }
}
