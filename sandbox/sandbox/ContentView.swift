//
//  ContentView.swift
//  sandbox
//
//  Created by 長政輝 on 2023/06/29.
//

import SwiftUI

struct MyViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        UnityBridge.getInstance().onReady = {
            UnityBridge.getInstance().api.test("this works so well!")
            UnityBridge.getInstance().show(controller: vc)
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        ZStack {
            MyViewController()
            Text("This text overlays Unity!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
