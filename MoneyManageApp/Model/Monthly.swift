//
//  Monthly.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/11.
//

import RealmSwift
import Firebase

class Monthly: Object {
    @objc dynamic var money = 0
    @objc dynamic var date = ""
    @objc dynamic var previousMonth = ""
}

class FMonthly {
    var money: Int!
    var date: String!
    var previousMonth: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        money = dict[MONEY] as? Int ?? 0
        date = dict[DATE] as? String ?? ""
        previousMonth = dict[PREVIOUS_MONTH] as? String ?? ""
    }
    
    class func fetchMonthly(completion: @escaping(FMonthly) -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("monthly").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch auto: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let monthly = FMonthly(dict: dict)
                completion(monthly)
            })
        }
    }
    
    class func saveMonthy(date: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("monthly").document(date).setData(value) { (error) in
            if let error = error {
                print("Error saving monthly: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteMonthlry(date: String, completion: @escaping() -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("monthly").document(date).delete { (error) in
            if let error = error {
                print("Error delete monthly: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
