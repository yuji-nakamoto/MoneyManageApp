//
//  AuthService.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/20.
//

import Foundation
import Firebase

struct AuthService {
    
    // MARK: - Authentication func
    
    static func loginUser(email: String, password: String, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                completion(error)
            } else {
                completion(error)
            }
        }
    }
    
    static func createUser(email: String, password: String, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                completion(error)
            } else {
                completion(error)
            }
        }
    }
    
    static func logoutUser(completion: @escaping(_ error: Error?) -> Void) {
                
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error as NSError {
            print("Error log out: \(error.localizedDescription)")
            completion(error)
        }
    }
    
    static func changePassword(password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            if let error = error {
                print("Error change password: \(error.localizedDescription)")
            }
            completion(error)
        })
    }
}
