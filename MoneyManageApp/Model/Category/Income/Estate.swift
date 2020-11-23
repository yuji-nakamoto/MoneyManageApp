//
//  Estate.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import RealmSwift

class Estate: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var id = ""
}

class FEstate {
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
    
    class func fetchFEstate(completion: @escaping(FEstate) -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("estate").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch income: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let data = FEstate(dict: dict)
                completion(data)
            })
        }
    }
    
    class func saveFEstate(id: String, value: [String: Any], completion: @escaping() -> Void) {
        COLLECTION_INCOME.document(User.currentUserId()).collection("estate").document(id).setData(value) { (error) in
            if let error = error {
                print("Error saving income: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
