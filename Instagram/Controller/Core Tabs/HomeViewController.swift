//
//  ViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//
import FirebaseAuth
import UIKit
import SQLite

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        
    }
    private func handleNotAuthenticated(){
        //Check auth status
    
        if (LoginViewController.shared.logat != true){
            LoginViewController.shared.logat = true
            let loginVC=LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC,animated: false)
        }
    

}
}

