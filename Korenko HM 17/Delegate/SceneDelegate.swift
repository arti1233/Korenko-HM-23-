//
//  SceneDelegate.swift
//  Korenko HM 17
//
//  Created by Artsiom Korenko on 25.05.22.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let keyChain = KeychainSwift()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print(#function)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print(#function)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print(#function)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print(#function)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if let password = keyChain.get("password"), !password.isEmpty{
            checkPassword()
        } else {
            addPassword()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print(#function)
    }
    
    
}

extension SceneDelegate {
    func addPassword(){
    
        let securityAlert = UIAlertController(title: "Security", message: "Do you want set up a password", preferredStyle: .alert)
        securityAlert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        let setPasswordButton = UIAlertAction(title: "Set password", style: .cancel){ _ in
            guard let textField = securityAlert.textFields?[0],
                  let text = textField.text else { return }
            self.keyChain.set(text, forKey: "password")
        }
            
            securityAlert.addAction(setPasswordButton)
            securityAlert.addAction(cancelButton)
        self.window?.rootViewController?.dismiss(animated: true)
        self.window?.rootViewController?.present(securityAlert, animated: true)
    }
    
    
    func checkPassword(){
        let alertController = UIAlertController(title: "Access denied", message: "Your password?", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let okButtun = UIAlertAction(title: "OK", style: .default) {_ in
            guard let textField = alertController.textFields?[0],
                  let text = textField.text,
                  let password = self.keyChain.get("password"),
                  password == text else { return self.wrongPassword() }
        }
        
        alertController.addAction(okButtun)
        self.window?.rootViewController?.dismiss(animated: true)
        self.window?.rootViewController?.present(alertController, animated: true)
    }
    
    
    func wrongPassword(){
        let allertController = UIAlertController(title: "Error", message: "Password is wrong!", preferredStyle: .alert)
        let okButtun = UIAlertAction(title: "OK", style: .default) { _ in
            self.checkPassword()
        }
        allertController.addAction(okButtun)
        self.window?.rootViewController?.present(allertController, animated: true)
        
    }
    
}
