//
//  Spending.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import Foundation
import RealmSwift

class Spending: Object {
    @objc dynamic var price = 0
    @objc dynamic var category = ""
    @objc dynamic var memo = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var date = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
}
