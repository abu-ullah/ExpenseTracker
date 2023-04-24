//
//  UIEditIncomePanel.swift
//  MidtermSolution
//
//  Created by english on 2023-04-13.
//

import UIKit
import Firebase

protocol UIEditIncomePanelDelegate {
    func updateIncome( _ sender : Any )
}

class UIEditIncomePanel : UIView {
    public var delegate : UIEditIncomePanelDelegate?
    
    var loggedInUser : User?
    
    let ref = Database.database().reference()
    
    private let imageClose : UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = .init(systemName: "xmark")
        img.tintColor = .lightGray
        
        return img
    }()
    
    private let lblTitle = newLabel(fontSize: 18, fontWeight: .bold, textColor: .black, defaultText: "What was your income last year?")
    
    private let txtIncome = newTextField(defaultText: "Income", isPassword: false)
    
    private let btnConfirm : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Confirm", for: .normal)
        btn.backgroundColor = .systemPurple
        btn.tintColor = .white
        return btn
    }()
    
    static func newLabel(fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor, defaultText: String ) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = textColor
        lbl.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        lbl.textAlignment = .center
        lbl.text = defaultText
        lbl.numberOfLines = 3
        return lbl
    }
    
    static func newTextField(defaultText: String, isPassword: Bool) -> UITextField {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = defaultText
        txt.font = .systemFont(ofSize: 12, weight: .light)
        txt.borderStyle = .roundedRect
        return txt
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
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        
        self.addSubviews(lblTitle, txtIncome, btnConfirm, imageClose)
    }
    
    private func applyConstraints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 220),
            self.widthAnchor.constraint(equalToConstant: 300),
            
            imageClose.widthAnchor.constraint(equalToConstant: 20),
            imageClose.heightAnchor.constraint(equalToConstant: 20),
            imageClose.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageClose.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            lblTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            lblTitle.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            lblTitle.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            
            txtIncome.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20),
            txtIncome.widthAnchor.constraint(equalTo: lblTitle.widthAnchor),
            txtIncome.centerXAnchor.constraint(equalTo: self.lblTitle.centerXAnchor),
            
            btnConfirm.topAnchor.constraint(equalTo: txtIncome.bottomAnchor, constant: 30),
            btnConfirm.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            btnConfirm.widthAnchor.constraint(equalTo: txtIncome.widthAnchor),
            btnConfirm.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func addTargets(){
        btnConfirm.enableTapGestureRecognizer(target: self, action: #selector(btnConfirmTapped))
        imageClose.enableTapGestureRecognizer(target: self, action: #selector(closePanel))
    }
    
    @objc func btnConfirmTapped() {
        var income = Double(txtIncome.text!)
        
        ref.child("Users").child(loggedInUser!.uid).updateChildValues([
            "income" : income
        ])
        if delegate != nil {
            delegate?.updateIncome(self)
        }
        self.removeFromSuperview()
    }
    
    @objc func closePanel(){
        
        self.removeFromSuperview()
    }
    
}

