//
//  HouseholdABTopViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/08.
//

import UIKit
import RealmSwift
import Charts

class HouseholdABTopViewCell: UITableViewCell {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var spendingButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var chartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chartViewWidth: NSLayoutConstraint!
    @IBOutlet weak var incomeButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var incomeButtonheight: NSLayoutConstraint!
    @IBOutlet weak var spendingButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var nextButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var nextButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var lastButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var lastButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var spendingButtonHeght: NSLayoutConstraint!
    
    var householdVC: HouseholdABTableViewController?
    
    func configureCharts(month: String, year: String) {
        
        let realm = try! Realm()
        var categoryArray = [String]()
        var priceArray = [Int]()
        
        categoryArray.removeAll()
        priceArray.removeAll()
        
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
            print(categoryArray.count)
            if categoryArray.count == 0 {
                pieChartView.isHidden = true
                noDataLabel.isHidden = false
                noDataLabel.text = "支出のデータはありません"
            } else {
                pieChartView.isHidden = false
                noDataLabel.isHidden = true
            }
            
            incomeButton.backgroundColor = .clear
            incomeButton.setTitleColor(.systemGray, for: .normal)
            UIView.animate(withDuration: 0.5) { [self] in
                spendingButton.backgroundColor = UIColor(named: CARROT_ORANGE)
                spendingButton.setTitleColor(.white, for: .normal)
            }
            
            for i in 0..<categoryArray.count {
                dataEntries.append(PieChartDataEntry(value: Double(priceArray[i]), label: categoryArray[i], data: ""))
                let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
                pieChartDataSet.valueFont = UIFont(name: "", size: 0)!
                pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 7)!
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                
                if categoryArray[i] == "食費" {
                    colors.append(UIColor(named: "icon_color1")!)
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
                pieChartView.highlightPerTapEnabled = false
                pieChartView.legend.enabled = false
                
                switch (UIScreen.main.nativeBounds.height) {
                case 2048:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2160:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2360:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2388:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2732:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
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
            
            if categoryArray.count == 0 {
                pieChartView.isHidden = true
                noDataLabel.isHidden = false
                noDataLabel.text = "収入のデータはありません"
            } else {
                pieChartView.isHidden = false
                noDataLabel.isHidden = true
            }
            
            spendingButton.backgroundColor = .clear
            spendingButton.setTitleColor(.systemGray, for: .normal)
            UIView.animate(withDuration: 0.5) { [self] in
                incomeButton.backgroundColor = UIColor(named: O_BLUE)
                incomeButton.setTitleColor(.white, for: .normal)
            }
            
            for i in 0..<categoryArray.count {
                dataEntries.append(PieChartDataEntry(value: Double(priceArray[i]), label: categoryArray[i], data: ""))
                let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
                pieChartDataSet.valueFont = UIFont(name: "", size: 0)!
                pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 7)!
                pieChartView.data = PieChartData(dataSet: pieChartDataSet)
                
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
                pieChartView.highlightPerTapEnabled = false
                pieChartView.legend.enabled = false
                
                switch (UIScreen.main.nativeBounds.height) {
                case 2048:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2160:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2360:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2388:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
                    break
                case 2732:
                    pieChartDataSet.entryLabelFont = UIFont(name: "HiraMaruProN-W4", size: 15)!
                    break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func spendingButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            UserDefaults.standard.removeObject(forKey: CHANGE)
            householdVC?.viewWillAppear(true)
        }
    }
    
    @IBAction func incomeButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            UserDefaults.standard.set(true, forKey: CHANGE)
            householdVC?.viewWillAppear(true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spendingButton.layer.cornerRadius = 30 / 2
        incomeButton.layer.cornerRadius = 30 / 2
        nextButton.layer.cornerRadius = 30 / 2
        lastButton.layer.cornerRadius = 30 / 2
        
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
        
        chartViewHeight.constant = 300
        chartViewWidth.constant = 300
        nextButtonHeight.constant = 35
        nextButtonWidth.constant = 70
        lastButtonHeight.constant = 35
        lastButtonWidth.constant = 70
        incomeButtonheight.constant = 35
        incomeButtonWidth.constant = 70
        spendingButtonHeght.constant = 35
        spendingButtonWidth.constant = 70
        viewHeight.constant = 35
        viewWidth.constant = 150
        
        nextButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        lastButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        incomeButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        spendingButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        
        spendingButton.layer.cornerRadius = 35 / 2
        incomeButton.layer.cornerRadius = 35 / 2
        nextButton.layer.cornerRadius = 35 / 2
        lastButton.layer.cornerRadius = 35 / 2
    }
    
    private func changeLayout2() {
        
        chartViewHeight.constant = 400
        chartViewWidth.constant = 400
        nextButtonHeight.constant = 40
        nextButtonWidth.constant = 80
        lastButtonHeight.constant = 40
        lastButtonWidth.constant = 80
        incomeButtonheight.constant = 40
        incomeButtonWidth.constant = 80
        spendingButtonHeght.constant = 40
        spendingButtonWidth.constant = 80
        viewHeight.constant = 40
        viewWidth.constant = 160
        
        nextButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 17)
        lastButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 17)
        incomeButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 17)
        spendingButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 17)
        
        spendingButton.layer.cornerRadius = 40 / 2
        incomeButton.layer.cornerRadius = 40 / 2
        nextButton.layer.cornerRadius = 40 / 2
        lastButton.layer.cornerRadius = 40 / 2
    }
}
