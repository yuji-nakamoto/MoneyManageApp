//
//  Brush.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import RealmSwift

class Brush: Object {
    @objc dynamic var price = 0
    @objc dynamic var timestamp = ""
    @objc dynamic var date = ""
    @objc dynamic var memo = ""
}
