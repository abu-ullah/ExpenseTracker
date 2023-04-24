//
//  ViewController.swift
//  Winter2023IOSProject
//
//  Created by english on 2023-03-31.
//

import UIKit
import Firebase

class ViewController: UIViewController, UILoginFormDelegate {


    let loginForm : UILoginForm = UILoginForm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialize()
        applyConstraints()
    }
    
    func initialize() {
        
        loginForm.delegate = self
        self.view.addSubview(loginForm)
    }
    
    func applyConstraints() {
        
        NSLayoutConstraint.activate([
            
            loginForm.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginForm.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
    }
    
    func signIn(_ sender: UILoginForm) {
        
        loginForm.response = "Logged in"
        
        
        
        let storyBoard : UIStoryboard = .init(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.loggedInUser = loginForm.loggedInUser
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    func signUp(_ sender: UILoginForm) {
        loginForm.response = "Account created"
    }
 


}

