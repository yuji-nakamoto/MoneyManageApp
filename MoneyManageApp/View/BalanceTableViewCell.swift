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
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var homeVC: HomeViewController?
    
    var firstDay: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: firstday!)
    }
    
    var lastDay: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: lastday!)
    }
    
    var year: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: firstday!)
    }
    
    var month: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: firstday!)
    }
    
    func fetchChart() {
        
        firstDayLabel.text = firstDay
        lastDayLabel.text = lastDay
        
        let realm = try! Realm()
        let spenResults = realm.objects(Spending.self).filter("month == '\(month)'").filter("year == '\(year)'")
        let incomeResults = realm.objects(Income.self).filter("month == '\(month)'").filter("year == '\(year)'")
        
        let totalSpending = spenResults.reduce(0) { (result, spending) -> Int in
            return result + spending.price
        }
        let totalIncome = incomeResults.reduce(0) { (result, income) -> Int in
            return result + income.price
        }
        let balanceNumeric = totalIncome - totalSpending
        let result1 = String.localizedStringWithFormat("%d", totalIncome)
        let result2 = String.localizedStringWithFormat("%d", totalSpending)
        let result3 = String.localizedStringWithFormat("%d", balanceNumeric)

        incomeLabel.text = "¥" + String(result1)
        spendingLabel.text = "¥-" + String(result2)
        balanceLabel.text = "¥" + String(result3)
        
        var dataEntries: [ChartDataEntry] = []
        var colors = [UIColor]()

        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            
            changeButton.alpha = 0
            UIView.animate(withDuration: 0.5) { [self] in
                changeButton.alpha = 1
                changeButton.backgroundColor = UIColor(named: O_RED)
                changeButton.setTitle("支出", for: .normal)
            }
            
            if spenResults.count == 0 {
                pieChartView.isHidden = true
                noDataLabel.isHidden = false
                noDataLabel.text = "支出のデータはありません"
            } else {
                pieChartView.isHidden = false
                noDataLabel.isHidden = true
            }
            
            for i in 0..<spenResults.count {

                dataEntries.append(PieChartDataEntry(value: Double(spenResults[i].price), label: spenResults[i].category, data: ""))
                let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                pieChartDataSet.valueFont = UIFont(name: "", size: 0)!
                pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 7)!
                
                if spenResults[i].category == "食費" {
                    colors.append(UIColor(named: "icon_color1")!)
                }
                if spenResults[i].category == "日用品" {
                    colors.append(UIColor(named: "icon_color2")!)
                }
                if spenResults[i].category == "趣味" {
                    colors.append(UIColor(named: "icon_color3")!)
                }
                if spenResults[i].category == "交際費" {
                    colors.append(UIColor(named: "icon_color4")!)
                }
                if spenResults[i].category == "交通費" {
                    colors.append(UIColor(named: "icon_color5")!)
                }
                if spenResults[i].category == "衣服・美容" {
                    colors.append(UIColor(named: "icon_color6")!)
                }
                if spenResults[i].category == "健康・医療" {
                    colors.append(UIColor(named: "icon_color7")!)
                }
                if spenResults[i].category == "自動車" {
                    colors.append(UIColor(named: "icon_color8")!)
                }
                if spenResults[i].category == "教養・教育" {
                    colors.append(UIColor(named: "icon_color9")!)
                }
                if spenResults[i].category == "特別な支出" {
                    colors.append(UIColor(named: "icon_color10")!)
                }
                if spenResults[i].category == "水道・光熱費" {
                    colors.append(UIColor(named: "icon_color11")!)
                }
                if spenResults[i].category == "通信費" {
                    colors.append(UIColor(named: "icon_color12")!)
                }
                if spenResults[i].category == "住宅" {
                    colors.append(UIColor(named: "icon_color13")!)
                }
                if spenResults[i].category == "税・社会保険" {
                    colors.append(UIColor(named: "icon_color14")!)
                }
                if spenResults[i].category == "保険" {
                    colors.append(UIColor(named: "icon_color15")!)
                }
                if spenResults[i].category == "その他" {
                    colors.append(UIColor(named: "icon_color16")!)
                }
                if spenResults[i].category == "未分類" {
                    colors.append(.systemGray)
                }
                pieChartDataSet.colors = colors
                
                if UserDefaults.standard.object(forKey: ON_ANIME) != nil {
                    pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
                } 
                pieChartView.highlightPerTapEnabled = false
                pieChartView.legend.enabled = false
            }
            
        } else {
            
            changeButton.alpha = 0
            UIView.animate(withDuration: 0.5) { [self] in
                changeButton.alpha = 1
                changeButton.backgroundColor = .systemGreen
                changeButton.setTitle("収入", for: .normal)
            }
            
            if incomeResults.count == 0 {
                pieChartView.isHidden = true
                noDataLabel.isHidden = false
                noDataLabel.text = "収入のデータはありません"
            } else {
                pieChartView.isHidden = false
                noDataLabel.isHidden = true
            }
            
            for i in 0..<incomeResults.count {
                dataEntries.append(PieChartDataEntry(value: Double(incomeResults[i].price), label: incomeResults[i].category, data: ""))
                let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                pieChartDataSet.valueFont = UIFont(name: "", size: 0)!
                pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 7)!

                if incomeResults[i].category == "給料" {
                    colors.append(UIColor(named: "icon_color17")!)
                }
                if incomeResults[i].category == "一時所得" {
                    colors.append(UIColor(named: "icon_color18")!)
                }
                if incomeResults[i].category == "事業・副業" {
                    colors.append(UIColor(named: "icon_color19")!)
                }
                if incomeResults[i].category == "年金" {
                    colors.append(UIColor(named: "icon_color20")!)
                }
                if incomeResults[i].category == "配当所得" {
                    colors.append(UIColor(named: "icon_color21")!)
                }
                if incomeResults[i].category == "不動産所得" {
                    colors.append(UIColor(named: "icon_color22")!)
                }
                if incomeResults[i].category == "その他入金" {
                    colors.append(UIColor(named: "icon_color23")!)
                }
                if incomeResults[i].category == "未分類" {
                    colors.append(.systemGray)
                }
                pieChartDataSet.colors = colors

                if UserDefaults.standard.object(forKey: ON_ANIME) != nil {
                    pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
                }
                pieChartView.highlightPerTapEnabled = false
                pieChartView.legend.enabled = false
            }
        }
    }
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            UserDefaults.standard.set(true, forKey: CHANGE)
            homeVC?.tableView.reloadData()
        } else {
            UserDefaults.standard.removeObject(forKey: CHANGE)
            homeVC?.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeButton.layer.cornerRadius = 25 / 2
        incomeLabel.text = "¥0"
        spendingLabel.text = "¥0"
        balanceLabel.text = "¥0"
    }
}
