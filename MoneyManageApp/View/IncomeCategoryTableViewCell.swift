//
//  IncomeCategoryTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit

class IncomeCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    func resetColer() {
        backView.backgroundColor = .white
    }

    @IBAction func cellButtonPressed(_ sender: Any) {
        backView.backgroundColor = .systemGray4
    }
}
