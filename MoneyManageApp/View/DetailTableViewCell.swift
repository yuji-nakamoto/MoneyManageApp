//
//  DetailTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/15.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func foodCell(_ food: Food) {
        
        let result = String.localizedStringWithFormat("%d", food.price)
        priceLabel.text = "¥" + result
        if food.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = food.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = food.timestamp
    }
    
    func brushCell(_ brush: Brush) {
        
        let result = String.localizedStringWithFormat("%d", brush.price)
        priceLabel.text = "¥" + result
        if brush.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = brush.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = brush.timestamp
    }
    
    func hobbyCell(_ hobby: Hobby) {
        
        let result = String.localizedStringWithFormat("%d", hobby.price)
        priceLabel.text = "¥" + result
        if hobby.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = hobby.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = hobby.timestamp
    }
    
    func datingCell(_ dating: Dating) {
        
        let result = String.localizedStringWithFormat("%d", dating.price)
        priceLabel.text = "¥" + result
        if dating.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = dating.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = dating.timestamp
    }
    
    func trafficCell(_ traffic: Traffic) {
        
        let result = String.localizedStringWithFormat("%d", traffic.price)
        priceLabel.text = "¥" + result
        if traffic.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = traffic.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = traffic.timestamp
    }
    
    func clotheCell(_ clothe: Clothe) {
        
        let result = String.localizedStringWithFormat("%d", clothe.price)
        priceLabel.text = "¥" + result
        if clothe.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = clothe.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = clothe.timestamp
    }
    
    func healthCell(_ health: Health) {
        
        let result = String.localizedStringWithFormat("%d", health.price)
        priceLabel.text = "¥" + result
        if health.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = health.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = health.timestamp
    }
    
    func carCell(_ car: Car) {
        
        let result = String.localizedStringWithFormat("%d", car.price)
        priceLabel.text = "¥" + result
        if car.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = car.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = car.timestamp
    }
    
    func educationCell(_ education: Education) {
        
        let result = String.localizedStringWithFormat("%d", education.price)
        priceLabel.text = "¥" + result
        if education.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = education.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = education.timestamp
    }
    
    func cardCell(_ card: Card) {
        
        let result = String.localizedStringWithFormat("%d", card.price)
        priceLabel.text = "¥" + result
        if card.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = card.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = card.timestamp
    }
    
    func utilityCell(_ utility: Utility) {
        
        let result = String.localizedStringWithFormat("%d", utility.price)
        priceLabel.text = "¥" + result
        if utility.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = utility.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = utility.timestamp
    }
    
    func communicationCell(_ communication: Communicaton) {
        
        let result = String.localizedStringWithFormat("%d", communication.price)
        priceLabel.text = "¥" + result
        if communication.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = communication.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = communication.timestamp
    }
    
    func houseCell(_ house: House) {
        
        let result = String.localizedStringWithFormat("%d", house.price)
        priceLabel.text = "¥" + result
        if house.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = house.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = house.timestamp
    }
    
    func taxCell(_ tax: Tax) {
        
        let result = String.localizedStringWithFormat("%d", tax.price)
        priceLabel.text = "¥" + result
        if tax.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = tax.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = tax.timestamp
    }
    
    func insranceCell(_ insrance: Insrance) {
        
        let result = String.localizedStringWithFormat("%d", insrance.price)
        priceLabel.text = "¥" + result
        if insrance.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = insrance.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = insrance.timestamp
    }
    
    func etcetoraCell(_ etcetora: Etcetora) {
        
        let result = String.localizedStringWithFormat("%d", etcetora.price)
        priceLabel.text = "¥" + result
        if etcetora.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = etcetora.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = etcetora.timestamp
    }
    
    func specialCell(_ special: Special) {
        
        let result = String.localizedStringWithFormat("%d", special.price)
        priceLabel.text = "¥" + result
        if special.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = special.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = special.timestamp
    }
    
    func unCategoryCell(_ unCategory: UnCategory) {
        
        let result = String.localizedStringWithFormat("%d", unCategory.price)
        priceLabel.text = "¥" + result
        if unCategory.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = unCategory.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = unCategory.timestamp
    }
    
    func salaryCell(_ salary: Salary) {
        
        let result = String.localizedStringWithFormat("%d", salary.price)
        priceLabel.text = "¥" + result
        if salary.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = salary.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = salary.timestamp
    }
    
    func temporaryCell(_ temporary: Temporary) {
        
        let result = String.localizedStringWithFormat("%d", temporary.price)
        priceLabel.text = "¥" + result
        if temporary.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = temporary.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = temporary.timestamp
    }
    
    func businessCell(_ business: Business) {
        
        let result = String.localizedStringWithFormat("%d", business.price)
        priceLabel.text = "¥" + result
        if business.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = business.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = business.timestamp
    }
    
    func pensionCell(_ pension: Pension) {
        
        let result = String.localizedStringWithFormat("%d", pension.price)
        priceLabel.text = "¥" + result
        if pension.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = pension.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = pension.timestamp
    }
    
    func devidentCell(_ devident: Devident) {
        
        let result = String.localizedStringWithFormat("%d", devident.price)
        priceLabel.text = "¥" + result
        if devident.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = devident.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = devident.timestamp
    }
    
    func estateCell(_ estate: Estate) {
        
        let result = String.localizedStringWithFormat("%d", estate.price)
        priceLabel.text = "¥" + result
        if estate.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = estate.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = estate.timestamp
    }
    
    func paymentCell(_ payment: Payment) {
        
        let result = String.localizedStringWithFormat("%d", payment.price)
        priceLabel.text = "¥" + result
        if payment.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = payment.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = payment.timestamp
    }
    
    func unCategory2Cell(_ unCategory2: UnCategory2) {
        
        let result = String.localizedStringWithFormat("%d", unCategory2.price)
        priceLabel.text = "¥" + result
        if unCategory2.memo == "" {
            memoLabel.text = "内容記入なし"
            memoLabel.textColor = .systemGray
        } else {
            memoLabel.text = unCategory2.memo
            memoLabel.textColor = UIColor(named: O_BLACK)
        }
        timestampLabel.text = unCategory2.timestamp
    }
}
