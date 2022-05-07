//
//  LoginViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//
import SafariServices
import UIKit

class LoginViewController: UIViewController {
  
    static let shared = LoginViewController ()
    var logat = false
    
    struct Constants{
        static let cornerRadius: CGFloat = 8.0
    }
    
    public let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or Email... "
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

    public let passwrodField: UITextField = {
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue

        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("New User? Create an Account", for: .normal)
        return button
        
    }()
    
    private let headerView: UIView = {
        let header =  UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        return header
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        
        createAccountButton.addTarget(self,
                                      action: #selector(didTapCreateAccoundButton),
                                      for: .touchUpInside)
        
        termsButton.addTarget(self,
                              action: #selector(didTapTermsButton),
                              for: .touchUpInside)
        
        privacyButton.addTarget(self,
                                action: #selector(didTapPrivacyButton),
                                for: .touchUpInside)
        
        usernameEmailField.delegate = self
        passwrodField.delegate = self
        
        addSubviews()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(
            x: 0,
            y: 0.0,
            width: view.width,
            height: view.height/3.0)
        
        usernameEmailField.frame = CGRect(
            x: 25,
            y: headerView.bottom+10,
            width: view.width-50,
            height: 52)
        
        passwrodField.frame = CGRect(
            x: 25,
            y: usernameEmailField.bottom+10,
            width: view.width-50,
            height: 52)
        
        loginButton.frame = CGRect(
            x: 25,
            y: passwrodField.bottom+10,
            width: view.width-50,
            height: 52)
        
        createAccountButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom+10,
            width: view.width-50,
            height: 52)
        
        termsButton.frame = CGRect(
            x: 10,
            y: view.height-view.safeAreaInsets.bottom-100,
            width: view.width-20,
            height: 50)
        
        privacyButton.frame = CGRect(
            x: 10,
            y: view.height-view.safeAreaInsets.bottom-50,
            width: view.width-20,
            height: 50)
        
        configureHeaderview()
    }
    
    private func configureHeaderview(){
        guard headerView.subviews.count == 1 else {
            return
        }
        guard let backgroundView = headerView.subviews.first  else {
            return
        }
        
        backgroundView.frame = headerView.bounds
        
        let imageView = UIImageView (image: UIImage(named: "text"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4.0,
                                 y: view.safeAreaInsets.top,
                                 width: headerView.width/2.0,
                                 height: headerView.height - view.safeAreaInsets.top)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SQLiteDatabase().printAllUsers()
    }
    
    private func addSubviews(){
        view.addSubview(usernameEmailField)
        view.addSubview(passwrodField)
        view.addSubview(loginButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
        
    }
   
    @objc private func didTapLoginButton(){
        passwrodField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
         
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
            let password = passwrodField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        var username: String?
        var email: String?
        if usernameEmail.contains("@"), usernameEmail.contains("."){
            email=usernameEmail
            
        }
        else{
            username=usernameEmail
        }
        
        //self.dismiss(animated: true,completion: nil)
        
        AuthManager.shared.loginUser(username: username,email: email, password: password) {succes in
        DispatchQueue.main.async {
            if succes {
                //user signed in
                print("Ce bine merge functia")
                self.dismiss(animated: true,completion: nil)
            }
            else {
                //error
                let alert=UIAlertController(title: "Log in Error",
                                            message: "Not able to log in",
                                            preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss",
                                              style: .cancel,
                                              handler: nil))
                self.present(alert,animated: true)
                }
            }
        }
    }
        
        
    
    @objc private func didTapTermsButton(){
        guard let URL = URL(string: "https://help.instagram.com/581066165581870/?helpref=uf_share")else{
            return
        }
        let vc = SFSafariViewController(url: URL)
        present(vc, animated: true)
        
    }
    @objc private func didTapPrivacyButton(){
        guard let URL = URL(string: "https://help.instagram.com/519522125107875/?helpref=uf_share")else{
            return
        }
        let vc = SFSafariViewController(url: URL)
        present(vc, animated: true)
        
    }
    @objc private func didTapCreateAccoundButton(){
        let vc = RegistrationViewController()
        vc.title="Create Account"
        
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwrodField.becomeFirstResponder()
        }
        else if textField == passwrodField {
            didTapLoginButton()
            
        }
        return true
    }
}
