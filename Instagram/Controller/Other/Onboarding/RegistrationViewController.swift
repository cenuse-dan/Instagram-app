//
//  RegistrationViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//

import UIKit

class RegistrationViewController: UIViewController {

    struct Constants{
        static let cornerRadius: CGFloat = 8.0
    }
    
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username... "
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.backgroundColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let EmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address... "
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.backgroundColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry=true
        field.placeholder = "Password... "
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.backgroundColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.addTarget(self,
                                 action: #selector(didTapRegister),
                                 for: .touchUpInside)
        usernameField.delegate=self
        EmailField.delegate=self
        passwordField.delegate=self
        view.addSubview(usernameField)
        view.addSubview(EmailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)


        
        

        view.backgroundColor = .systemBackground
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameField.frame=CGRect(x: 20, y: view.safeAreaInsets.top+100, width: view.width-40, height: 52)
        EmailField.frame=CGRect(x: 20, y: usernameField.bottom+100, width: view.width-40, height: 52)
        passwordField.frame=CGRect(x: 20, y: EmailField.bottom+100, width: view.width-40, height: 52)
        registerButton.frame=CGRect(x: 20, y: passwordField.bottom+100, width: view.width-40, height: 52)
        
    }
    @objc private func didTapRegister(){
        EmailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        guard let email = EmailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8,
                let username = usernameField.text, !username.isEmpty else {
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password)
            
            
        
    }

 
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField
        {
            EmailField.becomeFirstResponder()
        }
        else if textField == EmailField{
            passwordField.becomeFirstResponder()
        }
        else {
            didTapRegister()
        }
        return true
    }
}
