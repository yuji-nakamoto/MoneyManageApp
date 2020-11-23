//
//  User.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/20.
//

import Foundation
import Firebase

class User {
    
    var uid: String!
    var email: String!
    var isLogin: Bool!
    var backupFile: String!
    var backupCount: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        email = dict[EMAIL] as? String ?? ""
        isLogin = dict[IS_LOGIN] as? Bool ?? false
        backupFile = dict[BACKUP_FILE] as? String ?? ""
        backupCount = dict[BACKUP_COUNT] as? Int ?? 0
    }
    
    // MARK: - Return user
    
    class func currentUserId() -> String {
        guard Auth.auth().currentUser != nil else { return "fCaTJRVce0eDLoxZAe2xLubNy893" }
        return Auth.auth().currentUser!.uid
    }
    
    class func fetchUser(completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(User.currentUserId()).getDocument { (snapshot, error) in
            if let error = error {
                print("Error: fetch user: \(error.localizedDescription)")
            }
            if snapshot?.data() == nil {
                completion(User(dict: [UID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    class func saveUser(uid: String, email: String) {
        COLLECTION_USERS.document(uid).setData([UID: uid, EMAIL: email, IS_LOGIN: true]) { (error) in
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
