//
//  Monthly.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/11.
//

import RealmSwift

class Monthly: Object {
    @objc dynamic var money = 0
    @objc dynamic var date = ""
    @objc dynamic var previousMonth = ""
}
