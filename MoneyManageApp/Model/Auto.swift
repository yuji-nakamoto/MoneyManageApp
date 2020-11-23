//
//  Auto.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import Foundation
import RealmSwift
import Firebase

class Auto: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var payment = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var date = ""
    @objc dynamic var nextMonth = ""
    @objc dynamic var month = 0
    @objc dynamic var day = 0
    @objc dynamic var isInput = false
    @objc dynamic var onRegister = false
    @objc dynamic var isRegister = false
    @objc dynamic var autofillDay = ""
    @objc dynamic var id = ""
}

class FAuto {
    var price: Int!
    var category: String!
    var memo: String!
    var payment: String!
    var timestamp: String!
    var date: String!
    var nextMonth: String!
    var month: Int!
    var day: Int!
    var isInput: Bool!
    var onRegister: Bool!
    var isRegister: Bool!
    var autofillDay: String!
    var id: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        price = dict[PRICE] as? Int ?? 0
        category = dict[CATEGORY] as? String ?? ""
        memo = dict[MEMO] as? String ?? ""
        payment = dict[PAYMENT] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? String ?? ""
        date = dict[DATE] as? String ?? ""
        nextMonth = dict[NEXT_MONTH] as? String ?? ""
        month = dict[MONTHE] as? Int ?? 0
        day = dict[DAY] as? Int ?? 0
        isInput = dict[IS_INPUT] as? Bool ?? false
        onRegister = dict[ON_REGISTER] as? Bool ?? false
        isRegister = dict[IS_REGISTER] as? Bool ?? false
        autofillDay = dict[AUTOFILL_DAY] as? String ?? ""
        id = dict[ID] as? String ?? ""
    }
    
    class func fetchAuto(completion: @escaping(FAuto) -> Void) {
        COLLECTION_AUTO.document(User.currentUserId()).collection("auto").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch auto: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let auto = FAuto(dict: dict)
                completion(auto)
            })
        }
    }
    
    class func saveAutofill(id: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_AUTO.document(User.currentUserId()).collection("auto").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving auto: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
