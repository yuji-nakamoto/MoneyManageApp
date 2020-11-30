//
//  BalanceTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/05.
//

import UIKit
import RealmSwift
import Charts

class BalanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var lastDayLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var incomeLabel2: UILabel!
    @IBOutlet weak var spendingLabel2: UILabel!
    @IBOutlet weak var balanceLabel2: UILabel!
    @IBOutlet weak var accountBookLabel: UILabel!
    @IBOutlet weak var income2RightConst: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var chartViewLeftConst: NSLayoutConstraint!
    @IBOutlet weak var changeButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var changeButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var changeButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var chartViewButtomConst: NSLayoutConstraint!
    @IBOutlet weak var incomeBottomConst: NSLayoutConstraint!
    @IBOutlet weak var spendingBottomConst: NSLayoutConstraint!
    @IBOutlet weak var chatViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var incomeRightConst: NSLayoutConstraint!
    @IBOutlet weak var accountBookLeftConst: NSLayoutConstraint!
    
    var homeVC: HomeViewController?
    
    var firstDay: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: firstday!)
    }
    
    var lastDay: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: lastday!)
    }
    
    var year: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: firstday!)
    }
    
    var month: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: firstday!)
    }
    
    func fetchChart() {
        
        firstDayLabel.text = firstDay
        lastDayLabel.text = lastDay
        
        var categoryArray = [String]()
        var priceArray = [Int]()
        
        categoryArray.removeAll()
        priceArray.removeAll()
        
        let realm = try! Realm()
        let spenResults = realm.objects(Spending.self).filter("month == '\(month)'").filter("year == '\(year)'")
        let incomeResults = realm.objects(Income.self).filter("month == '\(month)'").filter("year == '\(year)'")
        
        let totalSpending = spenResults.reduce(0) { (result, spending) -> Int in
            return result + spending.price
        }
        let totalIncome = incomeResults.reduce(0) { (result, income) -> Int in
            return result + income.price
        }
        let balanceNumeric = totalIncome - totalSpending
        let result1 = String.localizedStringWithFormat("%d", totalIncome)
        let result2 = String.localizedStringWithFormat("%d", totalSpending)
        let result3 = String.localizedStringWithFormat("%d", balanceNumeric)

        incomeLabel.text = "¥" + String(result1)
        spendingLabel.text = "¥-" + String(result2)
        balanceLabel.text = "¥" + String(result3)
        
        var dataEntries: [ChartDataEntry] = []
        var colors = [UIColor]()

        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            
            let food = realm.objects(MonthlyFood.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let brush = realm.objects(MonthlyBrush.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let hobby = realm.objects(MonthlyHobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let dating = realm.objects(MonthlyDating.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let traffic = realm.objects(MonthlyTraffic.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let clothe = realm.objects(MonthlyClothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let health = realm.objects(MonthlyHealth.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let car = realm.objects(MonthlyCar.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let education = realm.objects(MonthlyEducation.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let special = realm.objects(MonthlySpecial.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let card = realm.objects(MonthlyCard.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let utility = realm.objects(MonthlyUtility.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let communication = realm.objects(MonthlyCommunication.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let house = realm.objects(MonthlyHouse.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let tax = realm.objects(MonthlyTax.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let insrance = realm.objects(MonthlyInsrance.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let etcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let unCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")
            
            food.forEach { (food) in
                categoryArray.append(food.category)
                priceArray.append(food.totalPrice)
            }
            brush.forEach { (brush) in
                categoryArray.append(brush.category)
                priceArray.append(brush.totalPrice)
            }
            hobby.forEach { (hobby) in
                categoryArray.append(hobby.category)
                priceArray.append(hobby.totalPrice)
            }
            dating.forEach { (dating) in
                categoryArray.append(dating.category)
                priceArray.append(dating.totalPrice)
            }
            traffic.forEach { (traffic) in
                categoryArray.append(traffic.category)
                priceArray.append(traffic.totalPrice)
            }
            clothe.forEach { (clothe) in
                categoryArray.append(clothe.category)
                priceArray.append(clothe.totalPrice)
            }
            health.forEach { (health) in
                categoryArray.append(health.category)
                priceArray.append(health.totalPrice)
            }
            car.forEach { (car) in
                categoryArray.append(car.category)
                priceArray.append(car.totalPrice)
            }
            education.forEach { (education) in
                categoryArray.append(education.category)
                priceArray.append(education.totalPrice)
            }
            special.forEach { (special) in
                categoryArray.append(special.category)
                priceArray.append(special.totalPrice)
            }
            card.forEach { (card) in
                categoryArray.append(card.category)
                priceArray.append(card.totalPrice)
            }
            utility.forEach { (utility) in
                categoryArray.append(utility.category)
                priceArray.append(utility.totalPrice)
            }
            communication.forEach { (communication) in
                categoryArray.append(communication.category)
                priceArray.append(communication.totalPrice)
            }
            house.forEach { (house) in
                categoryArray.append(house.category)
                priceArray.append(house.totalPrice)
            }
            tax.forEach { (tax) in
                categoryArray.append(tax.category)
                priceArray.append(tax.totalPrice)
            }
            insrance.forEach { (insrance) in
                categoryArray.append(insrance.category)
                priceArray.append(insrance.totalPrice)
            }
            etcetora.forEach { (etcetora) in
                categoryArray.append(etcetora.category)
                priceArray.append(etcetora.totalPrice)
            }
            unCategory.forEach { (unCategory) in
                categoryArray.append(unCategory.category)
                priceArray.append(unCategory.totalPrice)
            }
            
            
            changeButton.alpha = 0
            UIView.animate(withDuration: 0.5) { [self] in
                changeButton.alpha = 1
                changeButton.backgroundColor = UIColor(named: CARROT_ORANGE)
                changeButton.setTitle("支出", for: .normal)
            }
            
            if categoryArray.count == 0 {
                pieChartView.isHidden = true
                noDataLabel.isHidden = false
                noDataLabel.text = "支出のデータはありません"
            } else {
                pieChartView.isHidden = false
                noDataLabel.isHidden = true
            }
            
            for i in 0..<categoryArray.count {

                pieChartView.isHidden = true
                
                dataEntries.append(PieChartDataEntry(value: Double(priceArray[i]), label: categoryArray[i], data: ""))
                let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                pieChartDataSet.valueFont = UIFont(name: "", size: 0)!
                pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 7)!
                
                if categoryArray[i] == "食費" {
                    colors.append(UIColor(named: "vermilion")!)
                }
                if categoryArray[i] == "日用品" {
                    colors.append(UIColor(named: "icon_color2")!)
                }
                if categoryArray[i] == "趣味" {
                    colors.append(UIColor(named: "icon_color3")!)
                }
                if categoryArray[i] == "交際費" {
                    colors.append(UIColor(named: "icon_color4")!)
                }
                if categoryArray[i] == "交通費" {
                    colors.append(UIColor(named: "icon_color5")!)
                }
                if categoryArray[i] == "衣服・美容" {
                    colors.append(UIColor(named: "icon_color6")!)
                }
                if categoryArray[i] == "健康・医療" {
                    colors.append(UIColor(named: "icon_color7")!)
                }
                if categoryArray[i] == "自動車" {
                    colors.append(UIColor(named: "icon_color8")!)
                }
                if categoryArray[i] == "教養・教育" {
                    colors.append(UIColor(named: "icon_color9")!)
                }
                if categoryArray[i] == "特別な支出" {
                    colors.append(UIColor(named: "icon_color10")!)
                }
                if categoryArray[i] == "現金・カード" {
                    colors.append(UIColor(named: "icon_color24")!)
                }
                if categoryArray[i] == "水道・光熱費" {
                    colors.append(UIColor(named: "icon_color11")!)
                }
                if categoryArray[i] == "通信費" {
                    colors.append(UIColor(named: "icon_color12")!)
                }
                if categoryArray[i] == "住宅" {
                    colors.append(UIColor(named: "icon_color13")!)
                }
                if categoryArray[i] == "税・社会保険" {
                    colors.append(UIColor(named: "icon_color14")!)
                }
                if categoryArray[i] == "保険" {
                    colors.append(UIColor(named: "icon_color15")!)
                }
                if categoryArray[i] == "その他" {
                    colors.append(UIColor(named: "icon_color16")!)
                }
                if categoryArray[i] == "未分類" {
                    colors.append(.systemGray)
                }
                pieChartDataSet.colors = colors

                if UserDefaults.standard.object(forKey: ON_ANIME) != nil {
                    pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
                }
                pieChartView.isHidden = false
                pieChartView.highlightPerTapEnabled = false
                pieChartView.legend.enabled = false
                
                switch (UIScreen.main.nativeBounds.height) {
                case 2048:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2160:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2360:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2388:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2732:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 20)!
                    break
                default:
                    break
                }
            }
        } else {
            
            let salary = realm.objects(MonthlySalary.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let temporary = realm.objects(MonthlyTemporary.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let business = realm.objects(MonthlyBusiness.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let pension = realm.objects(MonthlyPension.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let devident = realm.objects(MonthlyDevident.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let estate = realm.objects(MonthlyEstate.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let payment = realm.objects(MonthlyPayment.self).filter("year == '\(year)'").filter("month == '\(month)'")
            let unCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")
            
            salary.forEach { (salary) in
                categoryArray.append(salary.category)
                priceArray.append(salary.totalPrice)
            }
            temporary.forEach { (temporary) in
                categoryArray.append(temporary.category)
                priceArray.append(temporary.totalPrice)
            }
            business.forEach { (business) in
                categoryArray.append(business.category)
                priceArray.append(business.totalPrice)
            }
            pension.forEach { (pension) in
                categoryArray.append(pension.category)
                priceArray.append(pension.totalPrice)
            }
            devident.forEach { (devident) in
                categoryArray.append(devident.category)
                priceArray.append(devident.totalPrice)
            }
            estate.forEach { (estate) in
                categoryArray.append(estate.category)
                priceArray.append(estate.totalPrice)
            }
            payment.forEach { (payment) in
                categoryArray.append(payment.category)
                priceArray.append(payment.totalPrice)
            }
            unCategory2.forEach { (unCategory2) in
                categoryArray.append(unCategory2.category)
                priceArray.append(unCategory2.totalPrice)
            }
            
            changeButton.alpha = 0
            UIView.animate(withDuration: 0.5) { [self] in
                changeButton.alpha = 1
                changeButton.backgroundColor = UIColor(named: O_BLUE)
                changeButton.setTitle("収入", for: .normal)
            }
            
            if categoryArray.count == 0 {
                pieChartView.isHidden = true
                noDataLabel.isHidden = false
                noDataLabel.text = "収入のデータはありません"
            } else {
                pieChartView.isHidden = false
                noDataLabel.isHidden = true
            }
            
            for i in 0..<categoryArray.count {
                
                pieChartView.isHidden = true

                dataEntries.append(PieChartDataEntry(value: Double(priceArray[i]), label: categoryArray[i], data: ""))
                let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                pieChartDataSet.valueFont = UIFont(name: "", size: 0)!
                pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 7)!

                if categoryArray[i] == "給与" {
                    colors.append(UIColor(named: "icon_color17")!)
                }
                if categoryArray[i] == "一時所得" {
                    colors.append(UIColor(named: "icon_color18")!)
                }
                if categoryArray[i] == "事業・副業" {
                    colors.append(UIColor(named: "icon_color19")!)
                }
                if categoryArray[i] == "年金" {
                    colors.append(UIColor(named: "icon_color20")!)
                }
                if categoryArray[i] == "配当所得" {
                    colors.append(UIColor(named: "icon_color21")!)
                }
                if categoryArray[i] == "不動産所得" {
                    colors.append(UIColor(named: "icon_color22")!)
                }
                if categoryArray[i] == "その他入金" {
                    colors.append(UIColor(named: "icon_color23")!)
                }
                if categoryArray[i] == "未分類" {
                    colors.append(.systemGray)
                }
                pieChartDataSet.colors = colors

                if UserDefaults.standard.object(forKey: ON_ANIME) != nil {
                    pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
                }
                pieChartView.isHidden = false
                pieChartView.highlightPerTapEnabled = false
                pieChartView.legend.enabled = false
                
                switch (UIScreen.main.nativeBounds.height) {
                case 2048:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2160:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2360:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2388:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                case 2732:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 20)!
                    break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            UserDefaults.standard.set(true, forKey: CHANGE)
            homeVC?.tableView.reloadData()
        } else {
            UserDefaults.standard.removeObject(forKey: CHANGE)
            homeVC?.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeButton.layer.cornerRadius = 25 / 2
        incomeLabel.text = "¥0"
        spendingLabel.text = "¥0"
        balanceLabel.text = "¥0"
        
        switch (UIScreen.main.nativeBounds.height) {
        case 2048:
            changeLayout1()
            break
        case 2160:
            changeLayout1()
            break
        case 2360:
            changeLayout1()
            break
        case 2388:
            changeLayout1()
            break
        case 2732:
            changeLayout2()
            break
        default:
            break
        }
    }
    
    private func changeLayout1() {
        
        heightConstraint.constant = 350
        widthConstraint.constant = 350
        chartViewLeftConst.constant = 20
        chartViewButtomConst.constant = 20
        chatViewTopConst.constant = 20
        changeButtonHeight.constant = 30
        changeButtonWidth.constant = 90
        changeButtonBottom.constant = 20
        incomeRightConst.constant = 30
        income2RightConst.constant = 200
        incomeBottomConst.constant = 80
        spendingBottomConst.constant = 80
        accountBookLeftConst.constant = 30
        
        incomeLabel.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        spendingLabel.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        balanceLabel.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        incomeLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        spendingLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        balanceLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        accountBookLabel.font = UIFont(name: "HiraMaruProN-W4", size: 25)
        firstDayLabel.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        lastDayLabel.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        noDataLabel.font = UIFont(name: "HiraMaruProN-W4", size: 15)

        changeButton.layer.cornerRadius = 15
        changeButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 15)
    }
    
    private func changeLayout2() {
        
        heightConstraint.constant = 450
        widthConstraint.constant = 450
        chartViewLeftConst.constant = 50
        chartViewButtomConst.constant = 20
        chatViewTopConst.constant = 20
        changeButtonHeight.constant = 40
        changeButtonWidth.constant = 100
        changeButtonBottom.constant = 30
        incomeRightConst.constant = 40
        income2RightConst.constant = 200
        incomeBottomConst.constant = 80
        spendingBottomConst.constant = 80
        accountBookLeftConst.constant = 40
        
        incomeLabel.font = UIFont(name: "HiraMaruProN-W4", size: 30)
        spendingLabel.font = UIFont(name: "HiraMaruProN-W4", size: 30)
        balanceLabel.font = UIFont(name: "HiraMaruProN-W4", size: 30)
        incomeLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 30)
        spendingLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 30)
        balanceLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 30)
        accountBookLabel.font = UIFont(name: "HiraMaruProN-W4", size: 30)
        firstDayLabel.font = UIFont(name: "HiraMaruProN-W4", size: 20)
        lastDayLabel.font = UIFont(name: "HiraMaruProN-W4", size: 20)
        noDataLabel.font = UIFont(name: "HiraMaruProN-W4", size: 20)

        changeButton.layer.cornerRadius = 20
        changeButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 20)
    }
}
