//
//  MainTabBarControllerViewController.swift
//  messenger
//
//  Created by kobayashi emino on 2020/08/31.
//  Copyright © 2020 kobayashi emino. All rights reserved.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatViewController = templeteViewController(image: "buble.left.and.bubble.right", selectedImage: "buble.left.and.bubble.right.fill", title: "Chat", view: ChatViewController())
        let profileViewController = templeteViewController(image: "person", selectedImage: "person.fill", title: "Profile", view: ProfileViewController())
        
        viewControllers = [chatViewController, profileViewController]
    }
    
    private func templeteViewController(image: String, selectedImage: String, title: String, view: UIViewController = UIViewController()) -> UINavigationController {
        let vc = view
        let navVC = UINavigationController(rootViewController: vc)
        navVC.tabBarItem.image = UIImage(systemName: image)
        navVC.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
        navVC.modalPresentationStyle = .fullScreen
        navVC.title = title
        return navVC
    }
}
