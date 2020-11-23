//
//  Spending.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import Foundation
import RealmSwift
import Firebase

class Spending: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var date = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var isAutofill = false
    @objc dynamic var id = ""
}

class FSpending {
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
    
    class func fetchSpending(completion: @escaping(FSpending) -> Void) {
        COLLECTION_SPENDING.document(User.currentUserId()).collection("spending").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch spending: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let spending = FSpending(dict: dict)
                completion(spending)
            })
        }
    }
    
    class func saveSpending(id: String, value: [String: Any], completion: @escaping() -> Void) {
        
        COLLECTION_SPENDING.document(User.currentUserId()).collection("spending").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving spending: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
