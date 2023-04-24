//
//  UIBottomNavBar.swift
//  Winter2023IOSProject
//
//  Created by english on 2023-03-31.
//

import Foundation
import UIKit


protocol UIBottomNavBarDelegate {
    func showDialog( _ sender : UIBottomNavBar )
    func showSideBar(_ sender : UIBottomNavBar )
}


class UIBottomNavBar : UIView {
    
    
    var delegate : UIBottomNavBarDelegate?
    
    public var viewHomeChangeColor : UIColor? {
        didSet {
            imgHome.tintColor = viewHomeChangeColor
            lblHome.tintColor = viewHomeChangeColor
        }
    }
    
    public var viewProfileChangeColor : UIColor? {
        didSet {
            imgProfile.tintColor = viewProfileChangeColor
            lblProfile.tintColor = viewProfileChangeColor
        }
    }
    
    
    
    let imgHome = newImageView(tintColor: .black, imageName: "homekit")
    let imgAdd = newImageView(tintColor: .systemIndigo, imageName: "plus")
    let imgProfile = newImageView(tintColor: .black, imageName: "person.fill")
    
    let lblHome = newLabel(fontSize: 12, defaultText: "Home", fontColor: .black)
    let lblProfile = newLabel(fontSize: 12, defaultText: "Profile", fontColor: .black)
    
    
    let viewHome = newView()
    let viewProfile = newView()
    let viewAdd = newView()
    
    
    static func newLabel( fontSize : CGFloat, defaultText : String, fontColor : UIColor ) -> UILabel {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: fontSize)
        lbl.textColor = fontColor
        lbl.text = defaultText
        
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
    
    
    static func newView () -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        viewHome.addSubviews(imgHome, lblHome)
        viewProfile.addSubviews(imgProfile, lblProfile)
        viewAdd.addSubviews(imgAdd)
        
        viewAdd.layer.borderColor = UIColor.systemIndigo.cgColor
        viewAdd.layer.cornerRadius = 10
        viewAdd.layer.borderWidth = 1
        viewAdd.backgroundColor = UIColor(red: 245/255, green: 230/255, blue: 255/255, alpha: 0.4)
        
        
        addSubviews(viewHome, viewProfile, viewAdd)
        

        
    }
    
    private func addSubViews( views : UIView... ) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    private func applyConstraints() {
        
        
        NSLayoutConstraint.activate([
            
            viewHome.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            viewHome.heightAnchor.constraint(equalToConstant: 50),
            viewHome.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            viewHome.widthAnchor.constraint(equalToConstant: 50),
            imgHome.centerXAnchor.constraint(equalTo: viewHome.centerXAnchor),
            imgHome.centerYAnchor.constraint(equalTo: viewHome.centerYAnchor, constant: -10),
            imgHome.heightAnchor.constraint(equalToConstant: 20),
            imgHome.widthAnchor.constraint(equalToConstant: 20),
            lblHome.centerYAnchor.constraint(equalTo: viewHome.centerYAnchor, constant: 10),
            lblHome.centerXAnchor.constraint(equalTo: viewHome.centerXAnchor),
            
            viewProfile.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            viewProfile.heightAnchor.constraint(equalToConstant: 50),
            viewProfile.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            viewProfile.widthAnchor.constraint(equalToConstant: 50),
            imgProfile.centerXAnchor.constraint(equalTo: viewProfile.centerXAnchor),
            imgProfile.centerYAnchor.constraint(equalTo: viewProfile.centerYAnchor, constant: -10),
            imgProfile.heightAnchor.constraint(equalToConstant: 20),
            imgProfile.widthAnchor.constraint(equalToConstant: 20),
            lblProfile.centerYAnchor.constraint(equalTo: viewProfile.centerYAnchor, constant: 10),
            lblProfile.centerXAnchor.constraint(equalTo: viewProfile.centerXAnchor),
            
            viewAdd.heightAnchor.constraint(equalToConstant: 50),
            viewAdd.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            viewAdd.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            viewAdd.widthAnchor.constraint(equalToConstant: 50),
            imgAdd.centerXAnchor.constraint(equalTo: viewAdd.centerXAnchor),
            imgAdd.centerYAnchor.constraint(equalTo: viewAdd.centerYAnchor),
            imgAdd.heightAnchor.constraint(equalToConstant: 30),
            imgAdd.widthAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func addTargets() {
        
        viewAdd.enableTapGestureRecognizer(target: self, action: #selector(displayDialogue))
        viewProfile.enableTapGestureRecognizer(target: self, action: #selector(displaySideBar))
    }
    
    @objc
    private func displayDialogue() {
        
        if delegate != nil {
            
            delegate?.showDialog(self)
        }
        
    }
    
    @objc
    private func displaySideBar() {
        
        if delegate != nil {
            
            delegate?.showSideBar(self)
        }
        
    }
    
    
}

