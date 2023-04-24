//
//  UITransactionTableViewCell.swift
//  Winter2023IOSProject
//
//  Created by english on 2023-03-31.
//

import Foundation
import UIKit

class TransactionTableViewCell : UITableViewCell {
    
    static let identifier = "TransactionTableViewCell"
    public var expenseId : String?
    
    public var transactionDescription : String? {
        didSet {
            if transactionDescription!.count > 18
            {
                lblTransactionDescription.text = (transactionDescription?.prefix(18))! + "..."
                return
            }
            lblTransactionDescription.text = transactionDescription!
        }
    }
    
    public var amount : Double? {
        didSet {
            
            if amount! > 0
            {
                lblAmount.text = "+ $\(amount!)"
                lblAmount.textColor = .green
                return
            }
            
            
            lblAmount.text = "- $\(abs(amount!))"
            lblAmount.textColor = .red
            
        }
    }
    
    public var image : String? {
        didSet {
            icon.image = UIImage(named: image!)
        }
    }
    
    public var transactionDate : String? {
        didSet {
            lblTransactionDate.text = transactionDate!
        }
    }
    
    /*public var icon : String? {
        didSet {
            icon.image = icon
        }
    }*/
    
    private let lblTransactionDescription = newLabel(fontSize: 17, textColor: .black, defaultText: "Fly to Paris")
    private let lblAmount = newLabel(fontSize: 0, textColor: .red, defaultText: "- $523")
    private let lblTransactionDate = newLabel(fontSize: 12, textColor: .lightGray, defaultText: "May 12 at 9:30PM")
    
    private let view : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    private let icon : UIImageView = {
        
        let imgView = UIImageView()
        imgView.image = .init(systemName: "xmark")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    
    static func newLabel( fontSize : CGFloat, textColor : UIColor, defaultText : String ) -> UILabel {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = textColor
        lbl.font = .systemFont(ofSize: fontSize)
        lbl.text = defaultText
        
        return lbl
    }
    
    
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initialize() {
        addSubViews(views : view, lblTransactionDescription, lblTransactionDate,
                    lblAmount, icon)
        lblAmount.font = .systemFont(ofSize: 17, weight: .semibold)
        lblTransactionDescription.numberOfLines = 3
        
        applyConst()
                    
    }
    
    
    private func applyConst() {
        
        self.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        NSLayoutConstraint.activate([
                
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            icon.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            icon.widthAnchor.constraint(equalToConstant: 45),
            icon.heightAnchor.constraint(equalToConstant: 45),
            
            lblTransactionDescription.topAnchor.constraint(equalTo: icon.topAnchor),
            lblTransactionDescription.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 20),
            
            lblTransactionDate.bottomAnchor.constraint(equalTo: icon.bottomAnchor),
            lblTransactionDate.leadingAnchor.constraint(equalTo: lblTransactionDescription.leadingAnchor),
            
            lblAmount.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lblAmount.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            

        ])
        
    }
    
    
    private func addSubViews( views : UIView... ){
        for view in views {
            self.addSubview(view)
        }
    }
    
}
