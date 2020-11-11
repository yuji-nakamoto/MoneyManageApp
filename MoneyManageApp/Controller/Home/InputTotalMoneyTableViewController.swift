//
//  InputTotalMoneyTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/11.
//

import UIKit
import PKHUD
import RealmSwift

class InputTotalMoneyTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var moneyLabel: UILabel!
    
    private var moneyArray = [Money]()
    private var money = 0
    private let nextMonthDate = calendar.nextMonth(for: date)
    
    private var nextMonth: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: nextMonthDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func backButtobPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if moneyLabel.text == "0" {
            HUD.flash(.labeledError(title: "", subtitle: "資産を入力してください"), delay: 1)
            return
        }
        
        let realm = try! Realm()
        let moneyArry = realm.objects(Money.self)
        
        moneyArray.removeAll()
        moneyArray.append(contentsOf: moneyArry)
        
        if moneyArray.count == 0 {
            let money = Money()
            money.createMoney = true
            money.totalMoney = self.money
            money.holdMoney = self.money
            money.nextMonth = self.nextMonth
            try! realm.write() {
                realm.add(money)
            }
        } else {
            moneyArray.forEach { (money) in
                try! realm.write() {
                    money.totalMoney = money.totalMoney + self.money
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        
        let realm = try! Realm()
        let money = realm.objects(Money.self)
        moneyArray.removeAll()
        moneyArray.append(contentsOf: money)
        
        moneyArray.forEach { (money) in
            if money.createMoney == true {
                navigationItem.title = "資産の追加"
                saveButton.setTitle("追加", for: .normal)
            } else {
                navigationItem.title = "資産の登録"
                saveButton.setTitle("登録", for: .normal)
            }
        }
        
        moneyLabel.text = "0"
        saveButton.layer.cornerRadius = 15
        tableView.tableFooterView = UIView()
        moneyTextField.becomeFirstResponder()
        moneyTextField.delegate = self
        moneyTextField.addTarget(self, action: #selector(textFieldTap), for: .editingDidBegin)
        moneyTextField.addTarget(self, action: #selector(labelDown), for: .editingDidEnd)
        moneyTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textFieldTap() {
        moneyLabel.text = "0"
        labelTopConstraint.constant = 60
        lineHeightConstraint.constant = 2
        lineView.backgroundColor = UIColor(named: O_RED)
    }
    
    @objc func labelDown() {
        if moneyTextField.text == "" {
            labelTopConstraint.constant = 80
            lineHeightConstraint.constant = 1
            lineView.backgroundColor = UIColor.systemGreen
        }
    }
    
    @objc func textDidChange() {
        
        guard moneyLabel.text!.count <= 11 else { return }
        moneyLabel.text = moneyTextField.text
        if moneyLabel.text == "" {
            moneyLabel.text = "0"
        }
        
        guard moneyLabel.text != "0" else { return }
        let totalMoney = Int(moneyLabel.text!)!
        let result = String.localizedStringWithFormat("%d", totalMoney)
        self.money = Int(moneyLabel.text!)!
        moneyLabel.text = result
    }
}
