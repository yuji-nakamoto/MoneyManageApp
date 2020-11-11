//
//  TotalMoneyTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/05.
//

import UIKit
import RealmSwift

class TotalMoneyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private let previousMonthDate = calendar.previousMonth(for: date)
    private let nextMonthDate = calendar.nextMonth(for: date)
    private var nextMonth: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: nextMonthDate)
    }
    
    private var previousMonthLastday: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: previousMonthLastdayDate!)
    }
    
    private var previousMonthFirstday: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: previousMonthDate)
    }
    
    func fetchTotalMoney() {
        
        let realm = try! Realm()
        let money = realm.objects(Money.self)
        let spenResults = realm.objects(Spending.self).filter("month == '\(month)'").filter("year == '\(year)'")
        let incomeResults = realm.objects(Income.self).filter("month == '\(month)'").filter("year == '\(year)'")
        
        let totalSpending = spenResults.reduce(0) { (result, spending) -> Int in
            return result + spending.price
        }
        let totalIncome = incomeResults.reduce(0) { (result, income) -> Int in
            return result + income.price
        }
        
        let balance = totalIncome - totalSpending
        if balance > 0 {
            balanceLabel.text = "⬆️ ¥" + String(balance)
            balanceLabel.textColor = UIColor(named: O_BLACK)
        } else if balance < 0 {
            balanceLabel.text = "⬇️ ¥" + String(balance)
            balanceLabel.textColor = .systemPink
        } else {
            balanceLabel.text = "⬅️ ¥" + String(balance)
            balanceLabel.textColor = UIColor(named: O_BLACK)
        }
        
        money.forEach { (money) in
            
            if money.createMoney == true {
                registerButton.isHidden = true
            } else {
                registerButton.isHidden = false
                registerButton.setTitle("資産の登録", for: .normal)
            }
            
            let totalMoney = money.totalMoney + totalIncome - totalSpending
            let result = String.localizedStringWithFormat("%d", totalMoney)
            totalMoneyLabel.text = "¥" + String(result)
            
            try! realm.write() {
                money.holdMoney = totalMoney
            }
            
            if yyyy_mm_dd >= money.nextMonth {
                
                try! realm.write() {
                    money.totalMoney = money.holdMoney
                    money.nextMonth = nextMonth
                }
                
                let lastMonthDate = calendar.previousMonth(for: date)
                var lastMonth: String {
                    dateFormatter.locale = Locale(identifier: "ja_JP")
                    dateFormatter.dateFormat = "yyyy年M月資産合計"
                    return dateFormatter.string(from: lastMonthDate)
                }
                
                let monthry = Monthly()
                monthry.money = money.holdMoney
                monthry.date = lastMonth
                monthry.previousMonth = "\(previousMonthFirstday)~\(previousMonthLastday)"
            
                try! realm.write() {
                    realm.add(monthry)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        totalMoneyLabel.text = "¥0"
        registerButton.layer.cornerRadius = 5
    }
}
