//
//  MyNavigationController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit

class MyUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    public func setup() {
        navigationBar.barTintColor = UIColor(named: O_WHITE)
    }
}
