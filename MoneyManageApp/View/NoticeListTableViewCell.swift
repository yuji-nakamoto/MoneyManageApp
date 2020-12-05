//
//  NoticeListTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/12/04.
//

import UIKit

class NoticeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    func configureCell(_ notice: FNotice) {

        titleLabel.text = notice.title
        
        if notice.genre == "重要" {
            genreLabel.textColor = .systemRed
            genreLabel.text = "   重要   "
            genreLabel.layer.borderColor = UIColor.systemRed.cgColor
        } else if notice.genre == "アップデート" {
            genreLabel.textColor = .systemGreen
            genreLabel.text = "   アップデート   "
            genreLabel.layer.borderColor = UIColor.systemGreen.cgColor
        } else if notice.genre == "お知らせ" {
            genreLabel.textColor = .systemBlue
            genreLabel.text = "   お知らせ   "
            genreLabel.layer.borderColor = UIColor.systemBlue.cgColor
        }
        
        let date = notice.time.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        genreLabel.layer.borderWidth = 1
        genreLabel.layer.cornerRadius = 10
    }
}
