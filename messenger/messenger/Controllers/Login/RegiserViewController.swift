//
//  RegiserViewController.swift
//  messenger
//
//  Created by kobayashi emino on 2020/08/30.
//  Copyright © 2020 kobayashi emino. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegiserViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "first name..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "last name..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "E-mail..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        registerButton.addTarget(self,
                              action: #selector(didTapregisterButton),
                              for: .touchUpInside)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
        
        scrollView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePicture))
        scrollView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePicture() {
        presentPhotoActoinSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = view.width / 3
        imageView.frame = CGRect(x: (view.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width / 2

        firstNameTextField.frame = CGRect(x: 30,
                                      y: imageView.bottom + 10,
                                      width: view.width - 60,
                                      height: 52)
        lastNameTextField.frame = CGRect(x: 30,
                                          y: firstNameTextField.bottom + 10,
                                          width: view.width - 60,
                                          height: 52)
        emailTextField.frame = CGRect(x: 30,
                                         y: lastNameTextField.bottom + 10,
                                         width: view.width - 60,
                                         height: 52)
        passwordTextField.frame = CGRect(x: 30,
                                         y: emailTextField.bottom + 10,
                                         width: view.width - 60,
                                         height: 52)
        registerButton.frame = CGRect(x: 30,
                                   y: passwordTextField.bottom + 10,
                                   width: view.width - 60,
                                   height: 52)
    }
    
    @objc private func didTapregisterButton() {
        
        lastNameTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let firstname = firstNameTextField.text,
            let lastname = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !firstname.isEmpty,
            !lastname.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            password.count >= 6 else {
                alertUserregisterError()
                return
        }
        
        DatabaseManeger.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else { return }
            
            guard !exists else {
                strongSelf.alertUserregisterError(message: "Looks like user account for that email already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
                guard authResult != nil, error == nil else {
                    return
                }
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
                DatabaseManeger.shared.insertUser(with: ChatAppUser(firstname: firstname, lastname: lastname, emailAdress: email))
            }
        }
    }
    
    private func alertUserregisterError(message: String = "please Enter all information to create a new account") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
        let vc = RegiserViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension RegiserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            didTapregisterButton()
        }
        return true
    }
}

extension RegiserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActoinSheet() {
        let alert = UIAlertController(title: "Profile Picture",
                                      message: "How would you like to select a picture",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "take photo",
                                      style: .default,
                                      handler: { [weak self] (_) in
                                        self?.presentCamera()
        }))
        alert.addAction(UIAlertAction(title: "select photo",
                                      style: .default,
                                      handler: { [weak self] (_) in
                                        self?.presentPhotoPicker()
        }))
        present(alert, animated: true)
    }
    
    func presentCamera() {
        
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
