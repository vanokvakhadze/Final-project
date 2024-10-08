//
//  SceneDelegate.swift
//  workout
//
//  Created by vano Kvakhadze on 09.07.24.
//

import UIKit
import FirebaseAuth
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.showSplashScreen()
    }

    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }

    private func showSplashScreen() {
        let splashScreen = UIHostingController(rootView: SplashScreen())
        self.window?.rootViewController = splashScreen

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.checkAuthentication()
        }
    }

    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            self.goToController(with: LoginVC())
        } else {
            let tabBarController = TabBarVC()
            self.goToController(with: tabBarController)
        }
    }

    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                let nav = UINavigationController(rootViewController: viewController)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav

                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
}

