//
//  AutoInputListTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit

class AutoInputListTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    
    func configureAutoCell(_ auto: Auto) {
        
        let result = String.localizedStringWithFormat("%d", auto.price)
        if auto.autofillDay == "月初" || auto.autofillDay == "月末" {
            dayLabel.text = auto.autofillDay
        } else {
            dayLabel.text = "毎月" + auto.autofillDay + "~"
        }
        
        if auto.memo == "" {
            memoLabel.text = "不明な出金"
        } else {
            memoLabel.text = auto.memo
        }
        
        if auto.payment == "支出" {
            backView.backgroundColor = UIColor(named: O_RED)
            priceLabel.text = "¥-" + String(result)
        } else {
            backView.backgroundColor = .systemGreen
            priceLabel.text = "¥" + String(result)
        }
        
        if auto.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
            categoryLabel.text = "未分類"
        } else if auto.category == "食費" {
            categoryImageView.image = UIImage(named: "food")
            categoryLabel.text = "食費"
        } else if auto.category == "日用品" {
            categoryImageView.image = UIImage(named: "brush")
            categoryLabel.text = "日用品"
        } else if auto.category == "趣味" {
            categoryImageView.image = UIImage(named: "hobby")
            categoryLabel.text = "趣味"
        } else if auto.category == "交際費" {
            categoryImageView.image = UIImage(named: "dating")
            categoryLabel.text = "交際費"
        } else if auto.category == "交通費" {
            categoryImageView.image = UIImage(named: "traffic")
            categoryLabel.text = "交通費"
        } else if auto.category == "衣服・美容" {
            categoryImageView.image = UIImage(named: "clothe")
            categoryLabel.text = "衣服・美容"
        } else if auto.category == "健康・医療" {
            categoryImageView.image = UIImage(named: "health")
            categoryLabel.text = "健康・医療"
        } else if auto.category == "自動車" {
            categoryImageView.image = UIImage(named: "car")
            categoryLabel.text = "自動車"
        } else if auto.category == "教養・教育" {
            categoryImageView.image = UIImage(named: "education")
            categoryLabel.text = "教養・教育"
        } else if auto.category == "特別な支出" {
            categoryImageView.image = UIImage(named: "special")
            categoryLabel.text = "特別な支出"
        } else if auto.category == "水道・光熱費" {
            categoryImageView.image = UIImage(named: "utility")
            categoryLabel.text = "水道・光熱費"
        } else if auto.category == "通信費" {
            categoryImageView.image = UIImage(named: "communication")
            categoryLabel.text = "通信費"
        } else if auto.category == "住宅" {
            categoryImageView.image = UIImage(named: "house")
            categoryLabel.text = "住宅"
        } else if auto.category == "税・社会保険" {
            categoryImageView.image = UIImage(named: "tax")
            categoryLabel.text = "税・社会保険"
        } else if auto.category == "保険" {
            categoryImageView.image = UIImage(named: "insrance")
            categoryLabel.text = "保険"
        } else if auto.category == "その他" {
            categoryImageView.image = UIImage(named: "etcetra")
            categoryLabel.text = "その他"
        } else if auto.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
            categoryLabel.text = "未分類"
        } else if auto.category == "給料" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "給料"
        } else if auto.category == "一時所得" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "一時所得"
        } else if auto.category == "事業・副業" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "事業・副業"
        } else if auto.category == "年金" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "年金"
        } else if auto.category == "配当所得" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "配当所得"
        } else if auto.category == "不動産所得" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "不動産所得"
        } else if auto.category == "その他入金" {
            categoryImageView.image = UIImage(named: "en_mark")
            categoryLabel.text = "その他入金"
        }
    }
}
