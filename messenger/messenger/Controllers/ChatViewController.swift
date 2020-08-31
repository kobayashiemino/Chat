//
//  ChatViewController.swift
//  messenger
//
//  Created by kobayashi emino on 2020/08/31.
//  Copyright © 2020 kobayashi emino. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
