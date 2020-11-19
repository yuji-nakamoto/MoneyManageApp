//
//  Hobby.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import RealmSwift

class Hobby: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var id = ""
}
