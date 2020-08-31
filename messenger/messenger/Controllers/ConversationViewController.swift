//
//  MainTabBarControllerViewController.swift
//  messenger
//
//  Created by kobayashi emino on 2020/08/31.
//  Copyright © 2020 kobayashi emino. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatViewController = templeteViewController(image: "bubble.left.and.bubble.right", selectedImage: "bubble.left.and.bubble.right.fill", title: "Chat", view: ChatViewController())
        let profileViewController = templeteViewController(image: "person", selectedImage: "person.fill", title: "Profile", view: ProfileViewController())
        
        viewControllers = [chatViewController, profileViewController]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        
        if  FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false)
        }
    }
    
    private func templeteViewController(image: String, selectedImage: String, title: String, view: UIViewController = UIViewController()) -> UINavigationController {
        let vc = view
        let navVC = UINavigationController(rootViewController: vc)
        navVC.tabBarItem.image = UIImage(systemName: image)
        navVC.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
        navVC.modalPresentationStyle = .fullScreen
        return navVC
    }
}
