//
//  UIBalancePanel.swift
//  Winter2023IOSProject§
//
//  Created by english on 2023-03-31.
//

import Foundation
import UIKit

class UIBalancePanel : UIView {
    
    public var balance : Double? {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            lblBalance.text = numberFormatter.string(from: NSNumber(value: balance!))
        }
    }
    
    public var date : Date? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            lblDate.text = formatter.string(from: date!)
        }
    }
    
    public var income : Double? {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            lblIncome.text = "$\(numberFormatter.string(from: NSNumber(value: income!))!)"
            calculateBalance()
        }
    }
    
    public var expense : Double? {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            lblExpense.text = "$\(numberFormatter.string(from: NSNumber(value: abs(expense!)))!)"
            calculateBalance()
        }
    }
    
    private let lblBalance = newLabel(fontSize: 35, fontWeight: .regular, textColor: .white, defaultText: "32,465")
    
    private let lblDate = newLabel(fontSize: 13, fontWeight: .bold, textColor: .systemGray6, defaultText: "September 2018")
    
    private let lblIncome = newLabel(fontSize: 17, fontWeight: .semibold, textColor: .white, defaultText: "$42,500")
    
    private let lblExpense = newLabel(fontSize: 17, fontWeight: .semibold, textColor: .white, defaultText: "$12,421")
    
    private let lblDollarSign = newLabel(fontSize: 25, fontWeight: .semibold, textColor: .white, defaultText: "$")
    
    private let lblCurrentBalance = newLabel(fontSize: 12, fontWeight: .bold, textColor: .systemGray6, defaultText: "CURRENT BALANCE")
    
    private let lblIncomeText = newLabel(fontSize: 12, fontWeight: .light, textColor: .systemGray6, defaultText: "INCOME")
    
    private let lblExpenseText = newLabel(fontSize: 12, fontWeight: .light, textColor: .systemGray6, defaultText: "EXPENSE")
    
    private let imgIncomeVariation = newImageView(imageSystemName: "arrow.down.left.circle", tintColor: .systemGreen)
    
    private let imgExpenseVariation = newImageView(imageSystemName: "arrow.up.forward.circle", tintColor: .systemRed)
    
    
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
        img.image = UIImage(systemName: imageSystemName)
        img.contentMode = .scaleAspectFill
        return img
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
        self.backgroundColor = .systemPurple
        
        let editIncomePanel = UIEditIncomePanel()
        
        self.addSubviews(lblCurrentBalance, lblBalance, lblDate, lblDollarSign, lblIncomeText, lblIncome, lblExpense, lblExpenseText, imgIncomeVariation, imgExpenseVariation)
    }
    
    private func applyConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalToConstant: 250),
            self.widthAnchor.constraint(equalToConstant: 300),
            
            lblCurrentBalance.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            lblCurrentBalance.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            lblBalance.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            lblBalance.topAnchor.constraint(equalTo: lblCurrentBalance.bottomAnchor, constant: 4),
            
            lblDollarSign.centerYAnchor.constraint(equalTo: lblBalance.centerYAnchor),
            lblDollarSign.trailingAnchor.constraint(equalTo: lblBalance.leadingAnchor, constant: -3),
            
            lblDate.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            lblDate.topAnchor.constraint(equalTo: lblBalance.bottomAnchor, constant: 8),
            
            imgIncomeVariation.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imgIncomeVariation.centerYAnchor.constraint(equalTo: lblIncomeText.centerYAnchor),
            
            lblIncomeText.leadingAnchor.constraint(equalTo: imgIncomeVariation.trailingAnchor, constant: 7),
            lblIncomeText.topAnchor.constraint(equalTo: lblDate.bottomAnchor, constant: 20),
            
            lblIncome.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            lblIncome.leadingAnchor.constraint(equalTo: lblIncomeText.leadingAnchor),
            lblIncome.topAnchor.constraint(equalTo: lblIncomeText.bottomAnchor, constant: 4),
            
            lblExpenseText.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            lblExpenseText.topAnchor.constraint(equalTo: lblDate.bottomAnchor, constant: 20),
            
            lblExpense.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            lblExpense.leadingAnchor.constraint(equalTo: lblExpenseText.leadingAnchor),
            lblExpense.topAnchor.constraint(equalTo: lblExpenseText.bottomAnchor, constant: 4),
            
            imgExpenseVariation.centerYAnchor.constraint(equalTo: lblExpenseText.centerYAnchor),
            imgExpenseVariation.trailingAnchor.constraint(equalTo: lblExpenseText.leadingAnchor, constant: -6)
        ])
        
    }
    
    private func addTargets() {
        imgIncomeVariation.enableTapGestureRecognizer(target: self, action: #selector(imgIncomeVariationTapped))
        
        imgExpenseVariation.enableTapGestureRecognizer(target: self, action: #selector(imgExpenseVariationTapped))
    }
    
    @objc func imgExpenseVariationTapped() {
        
    
    }
    
    @objc func imgIncomeVariationTapped() {

    }
    
    private func calculateBalance() {
        
        if income != nil && expense != nil {
            balance = income! + expense!
        }
    }
    
    
}

