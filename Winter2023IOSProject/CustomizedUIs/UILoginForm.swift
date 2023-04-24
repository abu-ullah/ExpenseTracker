//
//  UILoginForm.swift
//  Winter2023IOSProject
//
//  Created by english on 2023-03-31.
//

import Foundation
import UIKit
import Firebase


protocol UILoginFormDelegate {
    func signIn( _ sender: UILoginForm)
    func signUp( _ sender: UILoginForm )
}

class UILoginForm : UIView {
    
    
    let ref = Database.database().reference()
    let users = Database.database().reference().child("Users")
    
    var delegate : UILoginFormDelegate?
    
    public var email : String?

    public var password : String?
    
    public var response : String?
    
    public var loggedInUser = User()
    
    
    private let imgLogo = newImageView(imageSystemName: "SpendLess" , tintColor: .black)
    
    private let lblTitle = newLabel(fontSize: 27, fontWeight: .bold, textColor: .black, defaultText: "Welcome Back")
    
    private let lblResponse = newLabel(fontSize: 12, fontWeight: .bold, textColor: .red, defaultText: "")
    
    private let txtEmail = newTextField(defaultText: "Email", isPassword: false)
    
    private let txtPassword = newTextField(defaultText: "Password", isPassword: true)
    
    private let btnLogin = newButton(defaultText: "Sign In", tintColor: .black)
    
    private let btnSignup = newButton(defaultText: "Sign Up", tintColor: .black)
    
    static func newTextField(defaultText: String, isPassword: Bool) -> UITextField {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = defaultText
        txt.font = .systemFont(ofSize: 12, weight: .light)
        txt.borderStyle = .roundedRect
        return txt
    }
    
    static func newLabel(fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor, defaultText: String ) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = textColor
        lbl.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        lbl.textAlignment = .center
        lbl.text = defaultText
        return lbl
    }
    
    static func newImageView( imageSystemName : String, tintColor: UIColor ) -> UIImageView {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = tintColor
        img.image = UIImage(named: imageSystemName)
        img.contentMode = .scaleAspectFill
        return img
    }
    
    static func newButton(defaultText: String, tintColor: UIColor) -> UIButton{
        let btn = UIButton()
        btn.backgroundColor = tintColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(defaultText, for: .normal)
        btn.layer.cornerRadius = 6
        return btn
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        
        applyConstraints()
        
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.backgroundColor = .white
        txtPassword.isSecureTextEntry = true
        txtEmail.autocapitalizationType = .none
        txtPassword.autocapitalizationType = .none
        self.addSubviews(imgLogo, lblTitle, txtEmail, txtPassword, lblResponse, btnLogin, btnSignup)
        
        txtEmail.text = "thanhantrinh2015@gmail.com"
        txtPassword.text = "123456"
    }
    
    private func applyConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 900),
            
            imgLogo.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            imgLogo.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            imgLogo.heightAnchor.constraint(equalToConstant: 60),
            imgLogo.widthAnchor.constraint(equalToConstant: 60),
            
            lblTitle.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            lblTitle.topAnchor.constraint(equalTo: imgLogo.bottomAnchor, constant: 8),

            txtEmail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20),
            txtEmail.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            txtEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            
            txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: 8),
            txtPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            txtPassword.widthAnchor.constraint(equalTo: txtEmail.widthAnchor),
            
            
            lblResponse.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 20),
            lblResponse.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            btnLogin.topAnchor.constraint(equalTo: lblResponse.bottomAnchor, constant: 20),
            btnLogin.leadingAnchor.constraint(equalTo: txtEmail.leadingAnchor),
            btnLogin.widthAnchor.constraint(equalTo: txtEmail.widthAnchor),
            btnLogin.heightAnchor.constraint(equalToConstant: 60),
            
            btnSignup.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 20),
            btnSignup.leadingAnchor.constraint(equalTo: txtEmail.leadingAnchor),
            btnSignup.widthAnchor.constraint(equalTo: txtEmail.widthAnchor),
            btnSignup.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    private func addTargets(){
        
        btnLogin.enableTapGestureRecognizer(target: self, action: #selector(login))
        btnSignup.enableTapGestureRecognizer(target: self, action: #selector(signup))
    }
    
    @objc
    private func login() {
        
        if delegate != nil {
            
            fetchFields()
            
            Auth.auth().signIn(withEmail: email!, password: password!) { result, error in
                
                if error != nil {
                    self.lblResponse.text = "\(error!.localizedDescription)"
                    return
                }
                
                self.users.child("\(result!.user.uid)").observe(.value) { snapshot in
                    
                    let values = snapshot.value as! NSDictionary
                    self.loggedInUser.email = values["email"] as! String
                    self.loggedInUser.income = values["income"] as! Double
                    self.loggedInUser.balance = values["currentBalance"] as! Double
                    self.loggedInUser.uid = values["uid"] as! String
                    
                    
                    
                    if values["listOfExpenses"] != nil {
                        let subValue = values["listOfExpenses"] as! NSDictionary
                        for (expenseId, expenseFields) in subValue {
                            
                            var newExpense = Expense()
                            
                            let field = expenseFields as! [String:Any]
                            newExpense.id = field["uid"]! as! String
                            newExpense.amount = field["amount"] as! Double
                            newExpense.description = field["description"] as! String
                            newExpense.icon = field["icon"] as! String
                            newExpense.dateTime = field["dateTime"] as! String
                            
                            if field["period"] != nil {
                                newExpense.period = field["period"] as! Int
                            }
                            
                            self.loggedInUser.listOfExpenses.append(newExpense)
                        }
                    }
                    
                    
                    
                    self.delegate?.signIn(self)
                }
            }
        }
    }
    
    @objc private func signup() {
        
        if delegate != nil {
            
            fetchFields()
            
            Auth.auth().createUser(withEmail: email!, password: password!) { result, error in
                
                if error != nil {
                    self.lblResponse.text = "\(error!.localizedDescription)"
                    return
                }
                
                self.delegate?.signUp(self)
                self.lblResponse.text = self.response
                let newUser = User()
                self.users.child("\(result!.user.uid)/email").setValue(result!.user.email)
                self.users.child("\(result!.user.uid)/uid").setValue(result!.user.uid)
            }
        }
    }
    
    public func fetchFields() {
        
        email = txtEmail.text
        password = txtPassword.text
    }
    
    
}
