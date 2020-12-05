//
//  User.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/20.
//

import Foundation
import Firebase
import RealmSwift

class RUser: Object {
    @objc dynamic var uid = ""
    @objc dynamic var manageId = ""
    @objc dynamic var password = ""
}

class User {
    
    var uid: String!
    var moneyManegeId: String!
    var backupFile: String!
    var backupCount: Double!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        moneyManegeId = dict[MONEY_MANEGE_ID] as? String ?? ""
        backupFile = dict[BACKUP_FILE] as? String ?? ""
        backupCount = dict[BACKUP_COUNT] as? Double ?? 0
    }
    
    // MARK: - Return user
    
    class func currentUserId() -> String {
        guard Auth.auth().currentUser != nil else { return "XswnqPQzcFg4DnKubEWJ4cWjCrh1" }
        return Auth.auth().currentUser!.uid
    }
    
    class func fetchUser(completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(User.currentUserId()).getDocument { (snapshot, error) in
            if let error = error {
                print("Error: fetch user: \(error.localizedDescription)")
                completion(User(dict: [UID: ""]))
            }
            if snapshot?.data() == nil {
                completion(User(dict: [UID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    class func saveUser(uid: String, manegeId: String) {
        COLLECTION_USERS.document(uid).setData([UID: uid, MONEY_MANEGE_ID: manegeId]) { (error) in
            if let error = error {
                print("Error saving user: \(error.localizedDescription)")
            }
        }
    }
    
    class func updateUser(value: [String: Any]) {
        COLLECTION_USERS.document(User.currentUserId()).updateData(value) { (error) in
            if let error = error {
                print("Error update user: \(error.localizedDescription)")
            }
        }
    }
}
