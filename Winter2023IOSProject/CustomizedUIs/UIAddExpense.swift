//
//  UIAddExpense.swift
//  MidtermSolution
//
//  Created by english on 2023-04-05.
//

import UIKit
import SwiftUI
import Firebase

class UIAddExpense : UIView {
    
    var loggedInUser : User?
    
    let ref = Database.database().reference()
    
    private let lblTitle = newLabel(fontSize: 25, fontWeight: .bold, textColor: .black, defaultText: "Add Your Expense")
    
    private let txtDescription = newTextField(defaultText: "Description", isPassword: false)
    
    private let txtAmount = newTextField(defaultText: "Amount", isPassword: false)
    
    private let imageClose : UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = .init(systemName: "xmark")
        img.tintColor = .lightGray
        
        return img
    }()
    
    private let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.calendar = .current
        datePicker.date = .now
        return datePicker
    }()
    
    private let btnAdd : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Add", for: .normal)
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
        
        self.addSubviews(lblTitle, txtDescription, txtAmount, datePicker, btnAdd, imageClose)
    }
    
    private func applyConstraints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 310),
            self.widthAnchor.constraint(equalToConstant: 300),
            
            imageClose.widthAnchor.constraint(equalToConstant: 20),
            imageClose.heightAnchor.constraint(equalToConstant: 20),
            imageClose.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageClose.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            lblTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            lblTitle.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            txtDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 22),
            txtDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            txtDescription.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            
            txtAmount.topAnchor.constraint(equalTo: txtDescription.bottomAnchor, constant: 11),
            txtAmount.widthAnchor.constraint(equalTo: txtDescription.widthAnchor),
            txtAmount.centerXAnchor.constraint(equalTo: self.txtDescription.centerXAnchor),
            
            datePicker.topAnchor.constraint(equalTo: txtAmount.bottomAnchor, constant: 14),
            datePicker.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            btnAdd.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 27),
            btnAdd.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            btnAdd.widthAnchor.constraint(equalTo: datePicker.widthAnchor),
            btnAdd.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func addTargets(){
        btnAdd.enableTapGestureRecognizer(target: self, action: #selector(btnAddTapped))
        imageClose.enableTapGestureRecognizer(target: self, action: #selector(closePanel))
    }
    
    @objc func btnAddTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy, h:mm a"
        var datetime = datePicker.date
        
        
        let uuid = UUID().uuidString
        ref.child("Users").child(loggedInUser!.uid).child("listOfExpenses").child(uuid).setValue([
            "amount": -Double(txtAmount.text!)!,
            "dateTime": formatter.string(from: datetime),
            "description": txtDescription.text!,
            "icon": "money-management",
            "uid": uuid
        ])
    
        
        self.removeFromSuperview()
    }
    
    @objc func closePanel(){
        
        self.removeFromSuperview()
    }
    
}
