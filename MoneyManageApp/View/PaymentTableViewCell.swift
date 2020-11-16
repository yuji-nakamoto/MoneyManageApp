//
//  PaymentTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var numericLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func configureIncomeCell(_ income: Income) {
        
        dateLabel.text = income.timestamp
        let result = String.localizedStringWithFormat("%d", income.price)
        numericLabel.text = "¥" + String(result)
        if income.memo == "" {
            memoLabel.text = income.category
        } else {
            memoLabel.text = income.memo
        }
        
        if income.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
            categoryLabel.text = "未分類"
        } else if income.category == "給与" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "給与"
        } else if income.category == "一時所得" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "一時所得"
        } else if income.category == "事業・副業" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "事業・副業"
        } else if income.category == "年金" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "年金"
        } else if income.category == "配当所得" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "配当所得"
        } else if income.category == "不動産所得" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "不動産所得"
        } else if income.category == "その他入金" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "その他入金"
        }
    }
    
    func configureWithdrawalCell(_ spending: Spending) {
        
        dateLabel.text = spending.timestamp
        let result = String.localizedStringWithFormat("%d", spending.price)
        numericLabel.text = "¥-" + String(result)
        if spending.memo == "" {
            memoLabel.text = spending.category
        } else {
            memoLabel.text = spending.memo
        }
        
        if spending.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
            categoryLabel.text = "未分類"
        } else if spending.category == "食費" {
            categoryImageView.image = UIImage(named: "food")
            categoryLabel.text = "食費"
        } else if spending.category == "日用品" {
            categoryImageView.image = UIImage(named: "brush")
            categoryLabel.text = "日用品"
        } else if spending.category == "趣味" {
            categoryImageView.image = UIImage(named: "hobby")
            categoryLabel.text = "趣味"
        } else if spending.category == "交際費" {
            categoryImageView.image = UIImage(named: "dating")
            categoryLabel.text = "交際費"
        } else if spending.category == "交通費" {
            categoryImageView.image = UIImage(named: "traffic")
            categoryLabel.text = "交通費"
        } else if spending.category == "衣服・美容" {
            categoryImageView.image = UIImage(named: "clothe")
            categoryLabel.text = "衣服・美容"
        } else if spending.category == "健康・医療" {
            categoryImageView.image = UIImage(named: "health")
            categoryLabel.text = "健康・医療"
        } else if spending.category == "自動車" {
            categoryImageView.image = UIImage(named: "car")
            categoryLabel.text = "自動車"
        } else if spending.category == "教養・教育" {
            categoryImageView.image = UIImage(named: "education")
            categoryLabel.text = "教養・教育"
        } else if spending.category == "特別な支出" {
            categoryImageView.image = UIImage(named: "special")
            categoryLabel.text = "特別な支出"
        } else if spending.category == "現金・カード" {
            categoryImageView.image = UIImage(named: "card")
            categoryLabel.text = "現金・カード"
        } else if spending.category == "水道・光熱費" {
            categoryImageView.image = UIImage(named: "utility")
            categoryLabel.text = "水道・光熱費"
        } else if spending.category == "通信費" {
            categoryImageView.image = UIImage(named: "communication")
            categoryLabel.text = "通信費"
        } else if spending.category == "住宅" {
            categoryImageView.image = UIImage(named: "house")
            categoryLabel.text = "住宅"
        } else if spending.category == "税・社会保険" {
            categoryImageView.image = UIImage(named: "tax")
            categoryLabel.text = "税・社会保険"
        } else if spending.category == "保険" {
            categoryImageView.image = UIImage(named: "insrance")
            categoryLabel.text = "保険"
        } else if spending.category == "その他" {
            categoryImageView.image = UIImage(named: "etcetra")
            categoryLabel.text = "その他"
        }
    }
}
