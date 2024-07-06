//
//  SceneDelegate.swift
//  List Examination
//
//  Created by Farras on 06/07/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        DispatchQueue.main.async {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            let viewController = MainVC()
            let navigationController = UINavigationController(rootViewController: viewController)
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
