//
//  Notice.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/12/04.
//

import Foundation
import RealmSwift
import Firebase

class Notice: Object {
    @objc dynamic var noticeId1 = 0
    @objc dynamic var noticeId2 = 0
    @objc dynamic var noticeId3 = 0
    @objc dynamic var noticeId4 = 0
    @objc dynamic var noticeId5 = 0
}

class FNotice {
    
    var title: String!
    var time: Timestamp!
    var genre: String!
    var title2: String!
    var mainText: String!
    var text1: String!
    var text2: String!
    var text3: String!
    var endText: String!
    var uid: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        title = dict[TITLE] as? String ?? ""
        time = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        genre = dict[GENRE] as? String ?? ""
        title2 = dict[TITLE2] as? String ?? ""
        mainText = dict[MAIN_TEXT] as? String ?? ""
        text1 = dict[TEXT1] as? String ?? ""
        text2 = dict[TEXT2] as? String ?? ""
        text3 = dict[TEXT3] as? String ?? ""
        endText = dict[END_TEXT] as? String ?? ""
        uid = dict[UID] as? Int ?? 0
    }
    
    class func fetchNoticeList(comletion: @escaping(FNotice) ->Void) {
        
        COLLECTION_NOTICE.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (documents) in
                
                let notice = FNotice(dict: documents.data())
                comletion(notice)
            })
        }
    }
    
    class func fetchNotice1(comletion: @escaping(FNotice) ->Void) {
        
        COLLECTION_NOTICE.document("notice1").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = FNotice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice2(comletion: @escaping(FNotice) ->Void) {
        
        COLLECTION_NOTICE.document("notice2").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = FNotice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice3(comletion: @escaping(FNotice) ->Void) {
        
        COLLECTION_NOTICE.document("notice3").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = FNotice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice4(comletion: @escaping(FNotice) ->Void) {
        
        COLLECTION_NOTICE.document("notice4").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = FNotice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice5(comletion: @escaping(FNotice) ->Void) {
        
        COLLECTION_NOTICE.document("notice5").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = FNotice(dict: dict)
            comletion(notice)
        }
    }
}
