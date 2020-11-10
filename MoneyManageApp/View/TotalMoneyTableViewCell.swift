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
    
    func fetchTotalMoney() {
        let realm = try! Realm()
        let results = realm.objects(Money.self)
        
        results.forEach { (money) in
            totalMoneyLabel.text = "¥" + String(money.totalMoney)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        totalMoneyLabel.text = "¥0"
    }
}
