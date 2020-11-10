//
//  Extension.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/08.
//

import UIKit
import Foundation

extension UIView {
    func addBorder(_ width: CGFloat, color: UIColor, alpha: CGFloat) {
        let border = CALayer()
        border.borderColor = color.withAlphaComponent(alpha).cgColor
        border.borderWidth = 1
        border.frame = CGRect(x: 0 - 1, y: 0 - 1, width: self.frame.size.width + 1, height: self.frame.size.height - 1)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

public let dataArray1 = [ "未設定", "月末", "月初", "2日", "3日", "4日", "5日", "6日", "7日", "8日", "9日", "10日", "11日", "12日", "13日", "14日", "15日", "16日", "17日", "18日", "19日", "20日", "21日", "22日", "23日", "24日", "25日", "26日", "27日", "28日"]

public let calendar = Calendar.current
public let date = Date()
public var comps = calendar.dateComponents([.year, .month], from: date)
public var firstday = calendar.date(from: comps)
public var add = DateComponents(month: 1, day: -1)
public var add2 = DateComponents(month: 2, day: -1)
public var lastday = calendar.date(byAdding: add, to: firstday!)
public var lastday2 = calendar.date(byAdding: add2, to: firstday!)

public let dateFormatter = DateFormatter()
public var timestamp: String {
    dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
    return dateFormatter.string(from: date)
}
public var year_month_day: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}
public var year: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: date)
}
public var month: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "MM"
    return dateFormatter.string(from: date)
}

public var day: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "d"
    return dateFormatter.string(from: date)
}
