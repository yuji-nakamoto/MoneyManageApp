//
//  Money.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/06.
//

import Foundation
import RealmSwift
import Firebase

class Money: Object {
    @objc dynamic var totalMoney = 0
    @objc dynamic var holdMoney = 0
    @objc dynamic var createMoney = false
    @objc dynamic var nextMonth = ""
}

class FMoney {
    var totalMoney: Int!
    var holdMoney: Int!
    var createMoney: Bool!
    var nextMonth: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        totalMoney = dict[TOTAL_MONEY] as? Int ?? 0
        holdMoney = dict[HOLD_MONEY] as? Int ?? 0
        createMoney = dict[CREATE_MONEY] as? Bool ?? false
        nextMonth = dict[NEXT_MONTH] as? String ?? ""
    }
    
    class func fetchMoney(completion: @escaping(FMoney) -> Void) {
        COLLECTION_MONEY.document(User.currentUserId()).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch money: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let money = FMoney(dict: dict)
            completion(money)
        }
    }
    
    class func saveMoney(value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_MONEY.document(User.currentUserId()).setData(value) { (error) in
            if let error = error {
                print("Error saving money: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
