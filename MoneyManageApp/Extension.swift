//
//  Extension.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/08.
//

import UIKit
import Foundation

extension UIViewController {

    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}

public let dataArray1 = [ "未設定", "月初", "月末", "2日", "3日", "4日", "5日", "6日", "7日", "8日", "9日", "10日", "11日", "12日", "13日", "14日", "15日", "16日", "17日", "18日", "19日", "20日", "21日", "22日", "23日", "24日", "25日", "26日", "27日", "28日"]

public let calendar = Calendar.current
public let date = Date()
public var comps = calendar.dateComponents([.year, .month,], from: date)
public var firstday = calendar.date(from: comps)
public var add = DateComponents(month: 1, day: -1)
public var add2 = DateComponents(month: 2, day: -1)
public var add3 = DateComponents(month: 0, day: -1)
public var lastday = calendar.date(byAdding: add, to: firstday!)
public var lastday2 = calendar.date(byAdding: add2, to: firstday!)
public var previousMonthLastdayDate = calendar.date(byAdding: add3, to: firstday!)

public let dateFormatter = DateFormatter()

public var timestamp: String {
    dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
    return dateFormatter.string(from: date)
}
public var lastDayString: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "d"
    return dateFormatter.string(from: lastday!)
}
public var lastDay2String: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "d"
    return dateFormatter.string(from: lastday2!)
}
public var yyyy_mm_dd: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}
public var yyyy_mm: String {
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "yyyy-MM"
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

extension Calendar {
    
    func endOfDay(for date:Date) -> Date {
        return nextDay(for: date)
    }
    
    func previousDay(for date:Date) -> Date {
        return move(date, byDays: -1)
    }
    
    func nextDay(for date:Date) -> Date {
        return move(date, byDays: 1)
    }
    
    //MARK: - Move operation
    
    func move(_ date:Date, byDays days:Int) -> Date {
        return self.date(byAdding: .day, value: days, to: startOfDay(for: date))!
    }
    
    func startOfWeek(for date:Date) -> Date {
        let comps = self.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        return self.date(from: comps)!
    }
    
    func endOfWeek(for date:Date) -> Date {
        return nextWeek(for: date)
    }
    
    func previousWeek(for date:Date) -> Date {
        return move(date, byWeeks: -1)
    }
    
    func nextWeek(for date:Date) -> Date {
        return move(date, byWeeks: 1)
    }
    
    //MARK: - Month operations
    
    func startOfMonth(for date:Date) -> Date {
        let comps = dateComponents([.month, .year], from: date)
        return self.date(from: comps)!
    }
    
    func endOfMonth(for date:Date) -> Date {
        return nextMonth(for: date)
    }
    
    func previousMonth(for date:Date) -> Date {
        return move(date, byMonths: -1)
    }
    
    func nextMonth(for date:Date) -> Date {
        return move(date, byMonths: 1)
    }
    
    //MARK: - Move operations
    
    func move(_ date:Date, byWeeks weeks:Int) -> Date {
        return self.date(byAdding: .weekOfYear, value: weeks, to: startOfWeek(for: date))!
    }
    
    func move(_ date:Date, byMonths months:Int) -> Date {
        return self.date(byAdding: .month, value: months, to: startOfMonth(for: date))!
    }
}

func conversionDay(_ auto: Auto, _ day: String) {
    
    if day == "1" {
        auto.autofillDay = "月初"
    } else if day == "2" {
        auto.autofillDay = "2日"
    } else if day == "3" {
        auto.autofillDay = "3日"
    } else if day == "4" {
        auto.autofillDay = "4日"
    } else if day == "5" {
        auto.autofillDay = "5日"
    } else if day == "6" {
        auto.autofillDay = "6日"
    } else if day == "7" {
        auto.autofillDay = "7日"
    } else if day == "8" {
        auto.autofillDay = "8日"
    } else if day == "9" {
        auto.autofillDay = "9日"
    } else if day == "10" {
        auto.autofillDay = "10日"
    } else if day == "11" {
        auto.autofillDay = "11日"
    } else if day == "12" {
        auto.autofillDay = "12日"
    } else if day == "13" {
        auto.autofillDay = "13日"
    } else if day == "14" {
        auto.autofillDay = "14日"
    } else if day == "15" {
        auto.autofillDay = "15日"
    } else if day == "16" {
        auto.autofillDay = "16日"
    } else if day == "17" {
        auto.autofillDay = "17日"
    } else if day == "18" {
        auto.autofillDay = "18日"
    } else if day == "19" {
        auto.autofillDay = "19日"
    } else if day == "20" {
        auto.autofillDay = "20日"
    } else if day == "21" {
        auto.autofillDay = "21日"
    } else if day == "22" {
        auto.autofillDay = "22日"
    } else if day == "23" {
        auto.autofillDay = "23日"
    } else if day == "24" {
        auto.autofillDay = "24日"
    } else if day == "25" {
        auto.autofillDay = "25日"
    } else if day == "26" {
        auto.autofillDay = "26日"
    } else if day == "27" {
        auto.autofillDay = "27日"
    } else if day == "28" {
        auto.autofillDay = "28日"
    } else if day == "29" {
        auto.autofillDay = "月末"
    } else if day == "30" {
        auto.autofillDay = "月末"
    } else if day == "31" {
        auto.autofillDay = "月末"
    }
}
