//
//  BalanceTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/05.
//

import UIKit
import RealmSwift
import Charts

class BalanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var lastDayLabel: UILabel!
    
    let calendar = Calendar.current
    let date = Date()
    lazy var comps = calendar.dateComponents([.year, .month], from: date)
    lazy var firstday = calendar.date(from: comps)
    var add = DateComponents(month: 1, day: -1)
    lazy var lastday = calendar.date(byAdding: add, to: firstday!)
    
    
    var firstDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: firstday!)
    }
    
    var lastDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: lastday!)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: firstday!)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: firstday!)
    }
    
    func fetchMoney() {
        

        firstDayLabel.text = firstDay
        lastDayLabel.text = lastDay
        
        let realm = try! Realm()
        let spenResults = realm.objects(Spending.self).filter("month == '\(month)'").filter("year == '\(year)'")
        let inComeResults = realm.objects(Income.self).filter("month == '\(month)'").filter("year == '\(year)'")

        let totalSpending = spenResults.reduce(0) { (result, spending) -> Int in
            return result + spending.numeric
        }
        let totalIncome = inComeResults.reduce(0) { (result, income) -> Int in
            return result + income.numeric
        }
        let balanceNumeric = totalIncome - totalSpending
        incomeLabel.text = "¥" + String(totalIncome)
        spendingLabel.text = "¥" + String(totalSpending)
        balanceLabel.text = "¥" + String(balanceNumeric)
 
        spenResults.forEach { (spending) in
            var dataEntries: [ChartDataEntry] = []

            for i in 0..<spenResults.count {
                dataEntries.append(PieChartDataEntry(value: Double(spenResults[i].numeric), label: spenResults[i].category, data: ""))
                let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                pieChartDataSet.valueFont = UIFont(name: "", size: 0)!
                pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 7)!

                let colors = [.systemGreen, UIColor(named: O_RED)!, .systemOrange, .systemBlue, .systemIndigo, .systemTeal, .brown, .magenta, .red, .systemGray3, .systemFill, .systemYellow, UIColor(named: O_GREEN)!, UIColor(named: O_BLACK)!, .purple, .cyan, .systemGroupedBackground, .darkGray]
                pieChartDataSet.colors = colors

                pieChartView.noDataText = "データがありません"
                pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
                pieChartView.highlightPerTapEnabled = false
                pieChartView.legend.enabled = false

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        incomeLabel.text = "¥0"
        spendingLabel.text = "¥0"
        balanceLabel.text = "¥0"
    }
}
