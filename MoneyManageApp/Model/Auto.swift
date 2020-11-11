//
//  Auto.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import Foundation
import RealmSwift

class Auto: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var payment = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var date = ""
    @objc dynamic var month = 0
    @objc dynamic var day = 0
    @objc dynamic var isInput = false
    @objc dynamic var onRegister = false
    @objc dynamic var isRegister = false
    @objc dynamic var autofillDay = ""
    @objc dynamic var id = ""
}
