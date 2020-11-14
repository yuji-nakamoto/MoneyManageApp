//
//  HouseholdABTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/08.
//

import UIKit

class HouseholdABTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    func configureSpendingCell(_ spending: Spending) {
        
        let result = String.localizedStringWithFormat("%d", spending.price)
        priceLabel.text = "¥" + String(result)
        categoryLabel.text = spending.category
        if spending.memo == "" {
            memoLabel.text = spending.category
        } else {
            memoLabel.text = spending.memo
        }
        
        if spending.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
        } else if spending.category == "食費" {
            categoryImageView.image = UIImage(named: "food")
        } else if spending.category == "日用品" {
            categoryImageView.image = UIImage(named: "brush")
        } else if spending.category == "趣味" {
            categoryImageView.image = UIImage(named: "hobby")
        } else if spending.category == "交際費" {
            categoryImageView.image = UIImage(named: "dating")
        } else if spending.category == "交通費" {
            categoryImageView.image = UIImage(named: "traffic")
        } else if spending.category == "衣服・美容" {
            categoryImageView.image = UIImage(named: "clothe")
        } else if spending.category == "健康・医療" {
            categoryImageView.image = UIImage(named: "health")
        } else if spending.category == "自動車" {
            categoryImageView.image = UIImage(named: "car")
        } else if spending.category == "教養・教育" {
            categoryImageView.image = UIImage(named: "education")
        } else if spending.category == "特別な支出" {
            categoryImageView.image = UIImage(named: "special")
        } else if spending.category == "現金・カード" {
            categoryImageView.image = UIImage(named: "card")
        } else if spending.category == "水道・光熱費" {
            categoryImageView.image = UIImage(named: "utility")
        } else if spending.category == "通信費" {
            categoryImageView.image = UIImage(named: "communication")
        } else if spending.category == "住宅" {
            categoryImageView.image = UIImage(named: "house")
        } else if spending.category == "税・社会保険" {
            categoryImageView.image = UIImage(named: "tax")
        } else if spending.category == "保険" {
            categoryImageView.image = UIImage(named: "insrance")
        } else if spending.category == "その他" {
            categoryImageView.image = UIImage(named: "etcetra")
        }
    }
    
    func configureIncomeCell(_ income: Income) {
        
        let result = String.localizedStringWithFormat("%d", income.price)
        priceLabel.text = "¥" + String(result)
        categoryLabel.text = income.category
        memoLabel.text = income.memo
        
        if income.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
        } else if income.category == "給料" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "一時所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "事業・副業" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "年金" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "配当所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "不動産所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "その他入金" {
            categoryImageView.image = UIImage(named: "en_mark")
        }
    }
}
