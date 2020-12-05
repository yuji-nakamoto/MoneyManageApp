//
//  NoticeTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/12/04.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var text1Label: UILabel!
    @IBOutlet weak var text2Label: UILabel!
    @IBOutlet weak var text3Label: UILabel!
    @IBOutlet weak var endTextLabel: UILabel!
    @IBOutlet weak var text1TopConst: NSLayoutConstraint!
    @IBOutlet weak var text2TopConst: NSLayoutConstraint!
    @IBOutlet weak var text3TopConst: NSLayoutConstraint!

    func notice(_ notice: FNotice) {
        
        titleLabel.text = notice.title
        titleLabel2.text = notice.title2
        mainTextLabel.text = notice.mainText
        endTextLabel.text = notice.endText
        
        if notice.text1 != "" {
            text1Label.text = notice.text1
            text1TopConst.constant = 10
        } else {
            text1TopConst.constant = 0
        }
        
        if notice.text2 != "" {
            text2Label.text = notice.text2
            text2TopConst.constant = 5
        } else {
            text2TopConst.constant = 0
        }
        
        if notice.text3 != "" {
            text3Label.text = notice.text3
            text3TopConst.constant = 5
        } else {
            text3TopConst.constant = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTextLabel.text = ""
        titleLabel.text = ""
        titleLabel2.text = ""
        mainTextLabel.text = ""
        endTextLabel.text = ""
        text1Label.text = ""
        text2Label.text = ""
        text3Label.text = ""
    }
}
