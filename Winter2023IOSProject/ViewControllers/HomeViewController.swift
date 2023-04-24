//
//  HomeViewController.swift
//  Winter2023IOSProject
//
//  Created by english on 2023-03-31.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIBottomNavBarDelegate, UISideBarDelegate {


    var loggedInUser = User()
    let balancePanel = UIBalancePanel()
    let bottomNavBar = UIBottomNavBar()
    let tableExpenses = UITableView()
    
    let ref = Database.database().reference()
    let users = Database.database().reference().child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialize()
        applyConstraints()
    }
    
    func initialize() {
        
        self.view.backgroundColor = UIColor.systemGray6
        
        
        initializeTableExpense()
        initializeBalancePanel()
        initializeBottomNavBar()
        
        
        
        self.view.addSubviews(balancePanel, bottomNavBar, tableExpenses)
    }
    
    func applyConstraints() {
        
        NSLayoutConstraint.activate([
            
            balancePanel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            balancePanel.topAnchor.constraint(equalTo: self.view.topAnchor),
            balancePanel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            balancePanel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            
            tableExpenses.topAnchor.constraint(equalTo: balancePanel.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableExpenses.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            tableExpenses.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            
            bottomNavBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            bottomNavBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            bottomNavBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomNavBar.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15),
            tableExpenses.bottomAnchor.constraint(equalTo: bottomNavBar.topAnchor)
            
        ])
        
    }
    
    
    func fetchExpenses() {
        
        users.child(loggedInUser.uid).child("income").observe(.value) { snapshot in
            
            self.loggedInUser.income = snapshot.value as! Double
            self.balancePanel.income = self.loggedInUser.income
        }
        
        users.child(loggedInUser.uid).child("listOfExpenses").observe(.value) { snapshot,arg   in
            
            self.loggedInUser.listOfExpenses = []
            let values = snapshot.value as! NSDictionary
            
            for (expenseId, expenseFields) in values {
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
            
            self.balancePanel.expense = 0
            for expense in self.loggedInUser.listOfExpenses {

                if expense.amount < 0 {
                    if expense.period > 0 {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMMM dd yyyy, h:mm a"
                        let date = formatter.date(from:expense.dateTime)!
                        let dateTimeInMiliseconds = date.timeIntervalSince1970 * 1000
                        let nowInMiliseconds = Date().timeIntervalSince1970 * 1000
                        
                        let differenceInMiliseconds = nowInMiliseconds - dateTimeInMiliseconds
                        var numberOfPayments = Int(Double(differenceInMiliseconds) / Double(expense.period))
                        if differenceInMiliseconds < 0 {
                            numberOfPayments = 0
                        }
                        
                        
                        self.balancePanel.expense! += Double(numberOfPayments) * expense.amount
                    } else {
                        self.balancePanel.expense! += expense.amount
                    }
                }
            }
            self.tableExpenses.reloadData()
            

            
            
        }

    }
    
    func initializeTableExpense() {
        
        
        tableExpenses.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableExpenses.delegate = self
        tableExpenses.dataSource = self
        tableExpenses.translatesAutoresizingMaskIntoConstraints = false
        tableExpenses.layer.cornerRadius = 10
        tableExpenses.backgroundColor = .clear
        tableExpenses.sectionHeaderTopPadding = 0
        
        fetchExpenses()
        
        
    }
    
    func initializeBalancePanel() {
        
        balancePanel.balance = loggedInUser.balance
        balancePanel.income = loggedInUser.income
        balancePanel.date = Date()
        balancePanel.expense = 0

        
    }
    
    func initializeBottomNavBar() {
        
        bottomNavBar.viewHomeChangeColor = .systemIndigo
        bottomNavBar.viewProfileChangeColor = .gray
        bottomNavBar.delegate = self
        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        cell.amount = loggedInUser.listOfExpenses[indexPath.section].amount
        cell.transactionDate = loggedInUser.listOfExpenses[indexPath.section].dateTime
        cell.transactionDescription = loggedInUser.listOfExpenses[indexPath.section].description
        cell.expenseId = loggedInUser.listOfExpenses[indexPath.section].id
        cell.image = loggedInUser.listOfExpenses[indexPath.section].icon
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return loggedInUser.listOfExpenses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = view.backgroundColor
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
        let actDelete = UIContextualAction(style: .normal, title: "") { action, view, complete in

            let removingExpenseId = self.loggedInUser.listOfExpenses[indexPath.section].id

            
            self.users.child(self.loggedInUser.uid).child("listOfExpenses").child(cell.expenseId!).removeValue()


            complete(true)
        }

        actDelete.image = .init(systemName: "trash")
        actDelete.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [actDelete])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
        for i in (0..<self.loggedInUser.listOfExpenses.count) {
            if self.loggedInUser.listOfExpenses[i].id == cell.expenseId
            {
                if self.loggedInUser.listOfExpenses[i].period > 0 {
                    showEditBillPanel(self.loggedInUser.listOfExpenses[i])
                } else {
                    showEditExpensePanel(self.loggedInUser.listOfExpenses[i])
                }
            }
        }
    }


    func showDialog(_ sender: UIBottomNavBar) {

        let dialog = UIAlertController(title: "Add", message: "Would you like to add a bill or an expense", preferredStyle: .actionSheet)
        let btnBill = UIAlertAction(title: "Bill", style: .default) { action in
            self.showAddBillPanel()
        }
        let btnExpense = UIAlertAction(title: "Expense", style: .default) { void in
            self.showAddExpensePanel()
        }
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in

        }

        dialog.addAction(btnBill)
        dialog.addAction(btnExpense)
        dialog.addAction(btnCancel)

        present(dialog, animated: true, completion: nil)
    }
    
    func showSideBar(_ sender: UIBottomNavBar) {
        let sideBar = UISideBar()
        bottomNavBar.viewHomeChangeColor = .gray
        bottomNavBar.viewProfileChangeColor = .systemIndigo
        self.view.addSubview(sideBar)
        sideBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        sideBar.bottomAnchor.constraint(equalTo: bottomNavBar.topAnchor).isActive = true
        sideBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        sideBar.delegate = self
        sideBar.loggedInUser = loggedInUser
    }


    func showAddBillPanel() {

        let addBillPanel = UIAddBill()
        self.view.addSubview(addBillPanel)
        addBillPanel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addBillPanel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        addBillPanel.loggedInUser = loggedInUser
    }

    func showAddExpensePanel() {

        let addExpensePanel = UIAddExpense()
        self.view.addSubview(addExpensePanel)
        addExpensePanel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addExpensePanel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        addExpensePanel.loggedInUser = loggedInUser
    }

    func showEditExpensePanel(_ expense : Expense) {

        let editExpensePanel = UIEditExpense()
        self.view.addSubview(editExpensePanel)
        editExpensePanel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        editExpensePanel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        editExpensePanel.editingExpense = expense
        editExpensePanel.loggedInUser = loggedInUser
    }
    
    func showEditBillPanel(_ expense : Expense) {

        let editBillPanel = UIEditBill()
        self.view.addSubview(editBillPanel)
        editBillPanel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        editBillPanel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        editBillPanel.editingExpense = expense
        editBillPanel.loggedInUser = loggedInUser
    }
    
    func changeBottomNavBarIconTintColor(_ sender: UISideBar) {
        
        bottomNavBar.viewHomeChangeColor = .systemIndigo
        bottomNavBar.viewProfileChangeColor = .gray
        
    }
    
    

}
