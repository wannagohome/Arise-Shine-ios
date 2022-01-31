//
//  SceneDelegate.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import UIKit
import RIBs

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var launchRouter: LaunchRouting?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        UINavigationBar.appearance().isTranslucent = false
        self.setWindow(in: scene)
        self.setLaunchRouter()
    }
}

private extension SceneDelegate {
    func setWindow(in scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        self.window = window
    }
    
    func setLaunchRouter() {
        guard let winow = self.window else { return }
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: winow)
    }
}

