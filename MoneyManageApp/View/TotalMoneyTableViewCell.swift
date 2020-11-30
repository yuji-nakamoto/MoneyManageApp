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
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var totalMoneyRightConst: NSLayoutConstraint!
    @IBOutlet weak var totalLeftConst: NSLayoutConstraint!
    @IBOutlet weak var balanceTopConst: NSLayoutConstraint!
    @IBOutlet weak var totalTopConst: NSLayoutConstraint!
    @IBOutlet weak var totalMoneyTopConst: NSLayoutConstraint!
    
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
        let daySpenResults = realm.objects(Spending.self).filter("year == '\(year)'").filter("month == '\(month)'").filter("day == '\(day)'")
        let dayIncomeResults = realm.objects(Income.self).filter("year == '\(year)'").filter("month == '\(month)'").filter("day == '\(day)'")
        let spenResults = realm.objects(Spending.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let incomeResults = realm.objects(Income.self).filter("year == '\(year)'").filter("month == '\(month)'")

        let daySpendingPrice = daySpenResults.reduce(0) { (result, spending) -> Int in
            return result + spending.price
        }
        let dayIncomePrice = dayIncomeResults.reduce(0) { (result, income) -> Int in
            return result + income.price
        }
        
        let totalSpending = spenResults.reduce(0) { (result, spending) -> Int in
            return result + spending.price
        }
        let totalIncome = incomeResults.reduce(0) { (result, income) -> Int in
            return result + income.price
        }

        let balance = dayIncomePrice - daySpendingPrice
        let result = String.localizedStringWithFormat("%d", balance)
        if balance > 0 {
            balanceLabel.text = "⬆️ ¥" + String(result)
            balanceLabel.textColor = UIColor(named: O_BLUE)
        } else if balance < 0 {
            balanceLabel.text = "⬇️ ¥" + String(result)
            balanceLabel.textColor = UIColor(named: "fire_brick")
        } else {
            balanceLabel.text = "➡️ ¥" + String(result)
            balanceLabel.textColor = .systemGray
        }
        
        if money.count == 0 {
            totalMoneyLabel.text = "¥0"
        }
        
        money.forEach { (money) in
            
            let totalMoney = money.totalMoney + totalIncome - totalSpending
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: totalMoney))!
            totalMoneyLabel.text = "¥" + result
            
            try! realm.write() {
                money.holdMoney = totalMoney
            }
            
            var yyyy_mm_dd: String {
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.string(from: date)
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
        
        switch (UIScreen.main.nativeBounds.height) {
        case 2048:
            changeLayout1()
            break
        case 2160:
            changeLayout1()
            break
        case 2360:
            changeLayout1()
            break
        case 2388:
            changeLayout1()
            break
        case 2732:
            changeLayout2()
            break
        default:
            break
        }
    }
    
    private func changeLayout1() {
        
        totalMoneyRightConst.constant = 30
        totalLeftConst.constant = 30
        balanceTopConst.constant = 15
        totalTopConst.constant = 30
        totalMoneyTopConst.constant = 35
        
        totalLabel.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        totalMoneyLabel.font = UIFont(name: "HiraMaruProN-W4", size: 40)
        balanceLabel.font = UIFont(name: "HiraMaruProN-W4", size: 20)
        previousLabel.font = UIFont(name: "HiraMaruProN-W4", size: 15)
    }
    
    private func changeLayout2() {
        
        totalMoneyRightConst.constant = 40
        totalLeftConst.constant = 40
        balanceTopConst.constant = 15
        totalTopConst.constant = 30
        totalMoneyTopConst.constant = 35
        
        totalLabel.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        totalMoneyLabel.font = UIFont(name: "HiraMaruProN-W4", size: 40)
        balanceLabel.font = UIFont(name: "HiraMaruProN-W4", size: 20)
        previousLabel.font = UIFont(name: "HiraMaruProN-W4", size: 15)
    }
}
