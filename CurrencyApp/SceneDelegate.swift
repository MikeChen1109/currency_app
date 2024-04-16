//
//  SceneDelegate.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/4.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = CurrencyController()
        window?.makeKeyAndVisible()
    }
}

