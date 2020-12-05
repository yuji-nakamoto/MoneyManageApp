//
//  MonthlyCar.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/16.
//

import RealmSwift
import Firebase

class MonthlyCar: Object {
    @objc dynamic var totalPrice = 0
    @objc dynamic var category = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var monthly = ""
    @objc dynamic var date = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
}

class FMonthlyCar {
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
    
    class func fetchMCar(completion: @escaping(FMonthlyCar) -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("mCar").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch Car: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(FMonthlyCar(dict: [TOTAL_PRICE: 0]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let mCar = FMonthlyCar(dict: dict)
                completion(mCar)
            })
        }
    }
    
    class func saveMonthyCar(timestamp: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("mCar").document(timestamp).setData(value) { (error) in
            if let error = error {
                print("Error saving monthly: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteMCar(timestamp: String, completion: @escaping() -> Void) {
        COLLECTION_MONTHLY.document(User.currentUserId()).collection("mCar").document(timestamp).delete { (error) in
            if let error = error {
                print("Error delete: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
