//
//  Tempory.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import RealmSwift

class Temporary: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var id = ""
}

class FTemporary {
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
    
    class func fetchFTemporary(completion: @escaping(FTemporary) -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("temporary").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch income: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(FTemporary(dict: [PRICE: 0]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let data = FTemporary(dict: dict)
                completion(data)
            })
        }
    }
    
    class func saveFTemporary(id: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("temporary").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving income: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteTemporary(id: String, completion: @escaping() -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("temporary").document(id).delete { (error) in
            if let error = error {
                print("Error delete: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
