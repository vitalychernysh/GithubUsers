//
//  SceneDelegate.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import UIKit
import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private var appFlowCoordinator: ApplicationFlowCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        appFlowCoordinator = ApplicationFlowCoordinator(window: window)
        appFlowCoordinator.execute()
    }

}

