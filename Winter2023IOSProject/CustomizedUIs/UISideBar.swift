//
//  UISideBar.swift
//  Winter2023IOSProject
//
//  Created by english on 2023-04-13.
//

import Foundation
import UIKit


protocol UISideBarDelegate {
    func changeBottomNavBarIconTintColor ( _ sender : UISideBar )
}

class UISideBar : UIView {
    
    public var delegate : UISideBarDelegate?
    
    public var loggedInUser : User? {
        didSet {
            lblEmail.text = loggedInUser?.email
        }
    }
    
    private let lblEmail = newLabel(fontSize: 17, fontWeight: .semibold, textColor: .black, defaultText: "Name goes here")
    
    let imgProfile = newImageView(tintColor: .systemPurple, imageName: "person.fill")
    
    let imgClose = newImageView(tintColor: .lightGray, imageName: "xmark")
    
    var btnIncome = newButton(defaultText: "View or edit income", tintColor: .systemPurple)
    
    static func newLabel(fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor, defaultText: String ) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = textColor
        lbl.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        lbl.textAlignment = .center
        lbl.text = defaultText
        lbl.numberOfLines = 2
        return lbl
    }
    
    static func newImageView( tintColor: UIColor, imageName : String ) -> UIImageView {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = .init(systemName: imageName)
        img.contentMode = .scaleAspectFill
        img.tintColor = tintColor
        
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
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        
        self.lblEmail.text = loggedInUser?.email
        
        self.addSubviews(lblEmail, imgProfile, imgClose, btnIncome)
    }
    
    private func applyConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 280),
            
            imgClose.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imgClose.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            
            imgProfile.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imgProfile.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            imgProfile.widthAnchor.constraint(equalToConstant: 50),
            imgProfile.heightAnchor.constraint(equalToConstant: 50),
            
            lblEmail.centerYAnchor.constraint(equalTo: imgProfile.centerYAnchor),
            lblEmail.leadingAnchor.constraint(equalTo: imgProfile.trailingAnchor, constant: 10),
            lblEmail.widthAnchor.constraint(equalToConstant: 150),
            
            btnIncome.topAnchor.constraint(equalTo: lblEmail.bottomAnchor, constant: 40),
            btnIncome.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            btnIncome.heightAnchor.constraint(equalToConstant: 45),
            btnIncome.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func addTargets() {
        btnIncome.addTarget(self, action: #selector(btnIncomeTapped), for: .touchUpInside)
        imgClose.enableTapGestureRecognizer(target: self, action: #selector(imgCloseTapped))
    }
    
    @objc func btnIncomeTapped() {
        print("UiView tapped")
        let editIncomePanel = UIEditIncomePanel()
        self.addSubview(editIncomePanel)
        editIncomePanel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        editIncomePanel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        editIncomePanel.loggedInUser = loggedInUser
    }
    
    @objc func imgCloseTapped() {
        
        if delegate != nil {
            delegate?.changeBottomNavBarIconTintColor(self)
        }
        self.removeFromSuperview()
    }
    
}
