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
    
    func spendingCell(_ category: String, _ price: Int) {
        
        categoryLabel.text = category
        let result = String.localizedStringWithFormat("%d", price)
        priceLabel.text = "¥" + String(result)
        
        if category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
        } else if category == "食費" {
            categoryImageView.image = UIImage(named: "food")
        } else if category == "日用品" {
            categoryImageView.image = UIImage(named: "brush")
        } else if category == "趣味" {
            categoryImageView.image = UIImage(named: "hobby")
        } else if category == "交際費" {
            categoryImageView.image = UIImage(named: "dating")
        } else if category == "交通費" {
            categoryImageView.image = UIImage(named: "traffic")
        } else if category == "衣服・美容" {
            categoryImageView.image = UIImage(named: "clothe")
        } else if category == "健康・医療" {
            categoryImageView.image = UIImage(named: "health")
        } else if category == "自動車" {
            categoryImageView.image = UIImage(named: "car")
        } else if category == "教養・教育" {
            categoryImageView.image = UIImage(named: "education")
        } else if category == "特別な支出" {
            categoryImageView.image = UIImage(named: "special")
        } else if category == "現金・カード" {
            categoryImageView.image = UIImage(named: "card")
        } else if category == "水道・光熱費" {
            categoryImageView.image = UIImage(named: "utility")
        } else if category == "通信費" {
            categoryImageView.image = UIImage(named: "communication")
        } else if category == "住宅" {
            categoryImageView.image = UIImage(named: "house")
        } else if category == "税・社会保険" {
            categoryImageView.image = UIImage(named: "tax")
        } else if category == "保険" {
            categoryImageView.image = UIImage(named: "insrance")
        } else if category == "その他" {
            categoryImageView.image = UIImage(named: "etcetra")
        }
    }
    
    
    func incomeCell(_ category: String, _ price: Int) {
        
        let result = String.localizedStringWithFormat("%d", price)
        priceLabel.text = "¥" + String(result)
        categoryLabel.text = category
        
        if category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
        } else if category == "給与" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if category == "一時所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if category == "事業・副業" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if category == "年金" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if category == "配当所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if category == "不動産所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if category == "その他入金" {
            categoryImageView.image = UIImage(named: "en_mark")
        }
    }
}
