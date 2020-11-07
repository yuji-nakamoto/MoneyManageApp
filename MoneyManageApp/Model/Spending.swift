//
//  Spending.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import Foundation
import RealmSwift

class Spending: Object {
    @objc dynamic var numeric = 0
    @objc dynamic var category = ""
    @objc dynamic var date_jp = ""
    @objc dynamic var memo = ""
    @objc dynamic var date = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
}
