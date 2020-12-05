//
//  UnCategory2.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import RealmSwift

class UnCategory2: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var id = ""
}

class FUnCategory2 {
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
    
    class func fetchFUnCategory2(completion: @escaping(FUnCategory2) -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("unCategory2").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch income: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(FUnCategory2(dict: [PRICE: 0]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let data = FUnCategory2(dict: dict)
                completion(data)
            })
        }
    }
    
    class func saveFUnCategory2(id: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("unCategory2").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving income: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteUnCategory2(id: String, completion: @escaping() -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("unCategory2").document(id).delete { (error) in
            if let error = error {
                print("Error delete: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
