//
//  Etcetora.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import RealmSwift

class Etcetora: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var id = ""
}

class FEtcetora {
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
    
    class func fetchFEtcetora(completion: @escaping(FEtcetora) -> Void) {
        COLLECTION_SPENDING.document(User.currentUserId()).collection("etcetora").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch spending: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(FEtcetora(dict: [PRICE: 0]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let data = FEtcetora(dict: dict)
                completion(data)
            })
        }
    }
    
    class func saveFEtcetora(id: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_SPENDING.document(User.currentUserId()).collection("etcetora").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving spending: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    class func deleteEtcetora(id: String, completion: @escaping() -> Void) {
        COLLECTION_SPENDING.document(User.currentUserId()).collection("etcetora").document(id).delete { (error) in
            if let error = error {
                print("Error delete: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
