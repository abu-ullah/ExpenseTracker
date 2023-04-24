//
//  UISettingsButton.swift
//  MidtermSolution
//
//  Created by english on 2023-04-13.
//

import Foundation
import UIKit

class UISettingsButton : UIView {
    
    public var text : String? {
        didSet {
            lblText.text = text
        }
    }
    
    private let lblText = newLabel(fontSize: 18, fontWeight: .semibold, textColor: .gray, defaultText: "Text goes here")
    
    let imgArrow = newImageView(tintColor: .lightGray, imageName: "arrow.forward")
 
    static func newLabel(fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor, defaultText: String ) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = textColor
        lbl.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        lbl.textAlignment = .center
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.backgroundColor = .lightGray
        
        self.addSubviews(lblText, imgArrow)
    }
    
    private func applyConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 30),
            
            lblText.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            lblText.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            imgArrow.centerYAnchor.constraint(equalTo: lblText.centerYAnchor),
            imgArrow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            imgArrow.widthAnchor.constraint(equalToConstant: 15),
            imgArrow.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
}
