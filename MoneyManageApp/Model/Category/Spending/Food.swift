//
//  Food.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import RealmSwift

class Food: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var id = ""
}

class FFood {
    var price = 0
    var category = ""
    var memo = ""
    var timestamp = ""
    var year = ""
    var month = ""
    var day = ""
    var id = ""
    
    init() {
    }
    
    init(dict: [String: Any]) {
        price = dict[PRICE] as? Int ?? 0
        category = dict[CATEGORY] as? String ?? ""
        memo = dict[MEMO] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? String ?? ""
        year = dict[YEAR] as? String ?? ""
        month = dict[MONTHE] as? String ?? ""
        day = dict[DAY] as? String ?? ""
        id = dict[ID] as? String ?? ""
    }
    
    class func fetchFood(completion: @escaping(FFood) -> Void) {
        COLLECTION_SPENDING.document(User.currentUserId()).collection("food").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch spending: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(FFood(dict: [PRICE: 0]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let data = FFood(dict: dict)
                completion(data)
            })
        }
    }
    
    class func saveFood(id: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_SPENDING.document(User.currentUserId()).collection("food").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving spending: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteFood(id: String, completion: @escaping() -> Void) {
        COLLECTION_SPENDING.document(User.currentUserId()).collection("food").document(id).delete { (error) in
            if let error = error {
                print("Error delete: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
