//
//  Money.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/06.
//

import Foundation
import RealmSwift

class Money: Object {
    @objc dynamic var totalMoney = 0
    @objc dynamic var income = 0
    @objc dynamic var spending = 0
    @objc dynamic var balance = 0
}
