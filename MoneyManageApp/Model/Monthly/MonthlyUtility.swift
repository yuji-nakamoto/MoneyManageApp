//
//  MonthlyUtility.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/16.
//

import RealmSwift
import Firebase

class MonthlyUtility: Object {
    @objc dynamic var totalPrice = 0
    @objc dynamic var category = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var monthly = ""
    @objc dynamic var date = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
}

class FMonthlyUtility {
    var totalPrice = 0
    var category = ""
    var timestamp = ""
    var monthly = ""
    var date = ""
    var year = ""
    var month = ""
    
    init() {
    }
    
    init(dict: [String: Any]) {
        totalPrice = dict[TOTAL_PRICE] as? Int ?? 0
        category = dict[CATEGORY] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? String ?? ""
        monthly = dict[MONTHLY] as? String ?? ""
        date = dict[DATE] as? String ?? ""
        year = dict[YEAR] as? String ?? ""
        month = dict[MONTHE] as? String ?? ""
    }
    
    class func fetchMUtility(completion: @escaping(FMonthlyUtility) -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("mUtility").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch Utility: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(FMonthlyUtility(dict: [TOTAL_PRICE: 0]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let mUtility = FMonthlyUtility(dict: dict)
                completion(mUtility)
            })
        }
    }
    
    class func saveMonthyUtility(timestamp: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("mUtility").document(timestamp).setData(value) { (error) in
            if let error = error {
                print("Error saving monthly: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteMUtility(timestamp: String, completion: @escaping() -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("mUtility").document(timestamp).delete { (error) in
            if let error = error {
                print("Error delete: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
