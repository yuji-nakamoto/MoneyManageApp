//
//  Income.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import Foundation
import RealmSwift
import Firebase

class Income: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var date = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var id = ""
    @objc dynamic var isAutofill = false
}

class FIncome {
    var price: Int!
    var category: String!
    var memo: String!
    var timestamp: String!
    var date: String!
    var year: String!
    var month: String!
    var day: String!
    var isAutofill: Bool!
    var id: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        price = dict[PRICE] as? Int ?? 0
        category = dict[CATEGORY] as? String ?? ""
        memo = dict[MEMO] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? String ?? ""
        date = dict[DATE] as? String ?? ""
        year = dict[YEAR] as? String ?? ""
        month = dict[MONTHE] as? String ?? ""
        day = dict[DAY] as? String ?? ""
        isAutofill = dict[IS_AUTOFILL] as? Bool ?? false
        id = dict[ID] as? String ?? ""
    }
    
    class func fetchIncome(completion: @escaping(FIncome) -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("income").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch income: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let income = FIncome(dict: dict)
                completion(income)
            })
        }
    }
    
    class func saveIncome(id: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("income").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving income: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteIncome(id: String, completion: @escaping() -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("income").document(id).delete { (error) in
            if let error = error {
                print("Error delete income: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
