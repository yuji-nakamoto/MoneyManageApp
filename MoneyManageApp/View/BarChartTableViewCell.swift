//
//  BarChartTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/17.
//

import UIKit
import Charts
import RealmSwift

class BarChartTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var chartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chartViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var detailVC: DetailTableViewController?
    var CVWidth = 0
    var arrayCount = 0
    var barWidthValue = 0

    var mFoodArray = [MonthlyFood]()
    var mFoodArray2 = [MonthlyFood]()
    var mBrushArray = [MonthlyBrush]()
    var mBrushArray2 = [MonthlyBrush]()
    var mHobbyArray = [MonthlyHobby]()
    var mHobbyArray2 = [MonthlyHobby]()
    var mDatingArray = [MonthlyDating]()
    var mDatingArray2 = [MonthlyDating]()
    var mTrafficArray = [MonthlyTraffic]()
    var mTrafficArray2 = [MonthlyTraffic]()
    var mClotheArray = [MonthlyClothe]()
    var mClotheArray2 = [MonthlyClothe]()
    var mHealthArray = [MonthlyHealth]()
    var mHealthArray2 = [MonthlyHealth]()
    var mCarArray = [MonthlyCar]()
    var mCarArray2 = [MonthlyCar]()
    var mEducationArray = [MonthlyEducation]()
    var mEducationArray2 = [MonthlyEducation]()
    var mSpecialArray = [MonthlySpecial]()
    var mSpecialArray2 = [MonthlySpecial]()
    var mCardArray = [MonthlyCard]()
    var mCardArray2 = [MonthlyCard]()
    var mUtilityArray = [MonthlyUtility]()
    var mUtilityArray2 = [MonthlyUtility]()
    var mCommunicationArray = [MonthlyCommunication]()
    var mCommunicationArray2 = [MonthlyCommunication]()
    var mHouseArray = [MonthlyHouse]()
    var mHouseArray2 = [MonthlyHouse]()
    var mTaxArray = [MonthlyTax]()
    var mTaxArray2 = [MonthlyTax]()
    var mInsranceArray = [MonthlyInsrance]()
    var mInsranceArray2 = [MonthlyInsrance]()
    var mEtcetoraArray = [MonthlyEtcetora]()
    var mEtcetoraArray2 = [MonthlyEtcetora]()
    var mUnCategoryArray = [MonthlyUnCategory]()
    var mUnCategoryArray2 = [MonthlyUnCategory]()
    var mSalaryArray = [MonthlySalary]()
    var mSalaryArray2 = [MonthlySalary]()
    var mTemporaryArray = [MonthlyTemporary]()
    var mTemporaryArray2 = [MonthlyTemporary]()
    var mBusinessArray = [MonthlyBusiness]()
    var mBusinessArray2 = [MonthlyBusiness]()
    var mPensionArray = [MonthlyPension]()
    var mPensionArray2 = [MonthlyPension]()
    var mDevidentArray = [MonthlyDevident]()
    var mDevidentArray2 = [MonthlyDevident]()
    var mEstateArray = [MonthlyEstate]()
    var mEstateArray2 = [MonthlyEstate]()
    var mPaymentArray = [MonthlyPayment]()
    var mPaymentArray2 = [MonthlyPayment]()
    var mUnCategory2Array = [MonthlyUnCategory2]()
    var mUnCategory2Array2 = [MonthlyUnCategory2]()

    var dataEntries: [BarChartDataEntry] = []
    var category = ""
        
    func configureBarChartCell(_ category: String, _ year: String, _ month: String) {
        
        barChartView.delegate = self
        self.category = category
        mFoodArray.removeAll()
        mFoodArray2.removeAll()
        mBrushArray.removeAll()
        mBrushArray2.removeAll()
        mHobbyArray.removeAll()
        mHobbyArray2.removeAll()
        mDatingArray.removeAll()
        mDatingArray2.removeAll()
        mTrafficArray.removeAll()
        mTaxArray2.removeAll()
        mClotheArray.removeAll()
        mClotheArray2.removeAll()
        mHealthArray.removeAll()
        mHealthArray2.removeAll()
        mCarArray.removeAll()
        mCarArray2.removeAll()
        mEducationArray.removeAll()
        mEducationArray2.removeAll()
        mSpecialArray.removeAll()
        mSpecialArray2.removeAll()
        mCardArray.removeAll()
        mCardArray2.removeAll()
        mUtilityArray.removeAll()
        mUtilityArray2.removeAll()
        mCommunicationArray.removeAll()
        mCommunicationArray2.removeAll()
        mHouseArray.removeAll()
        mHouseArray2.removeAll()
        mTaxArray.removeAll()
        mTaxArray2.removeAll()
        mInsranceArray.removeAll()
        mInsranceArray2.removeAll()
        mEtcetoraArray.removeAll()
        mEtcetoraArray2.removeAll()
        mUnCategoryArray.removeAll()
        mUnCategoryArray2.removeAll()
        mSalaryArray.removeAll()
        mSalaryArray2.removeAll()
        mTemporaryArray.removeAll()
        mTemporaryArray2.removeAll()
        mBusinessArray.removeAll()
        mBusinessArray2.removeAll()
        mPensionArray.removeAll()
        mPensionArray2.removeAll()
        mDevidentArray.removeAll()
        mDevidentArray2.removeAll()
        mEstateArray.removeAll()
        mEstateArray2.removeAll()
        mPaymentArray.removeAll()
        mPaymentArray2.removeAll()
        mUnCategory2Array.removeAll()
        mUnCategory2Array2.removeAll()
        dataEntries.removeAll()
        
        let realm = try! Realm()
        let mAllFood = realm.objects(MonthlyFood.self)
        let mAllBrush = realm.objects(MonthlyBrush.self)
        let mAllHobby = realm.objects(MonthlyHobby.self)
        let mAllDating = realm.objects(MonthlyDating.self)
        let mAllTraffic = realm.objects(MonthlyTraffic.self)
        let mAllClothe = realm.objects(MonthlyClothe.self)
        let mAllHealth = realm.objects(MonthlyHealth.self)
        let mAllCar = realm.objects(MonthlyCar.self)
        let mAllEducation = realm.objects(MonthlyEducation.self)
        let mAllSpecial = realm.objects(MonthlySpecial.self)
        let mAllCard = realm.objects(MonthlyCard.self)
        let mAllUtility = realm.objects(MonthlyUtility.self)
        let mAllCommunication = realm.objects(MonthlyCommunication.self)
        let mAllHouse = realm.objects(MonthlyHouse.self)
        let mAllTax = realm.objects(MonthlyTax.self)
        let mAllInsrance = realm.objects(MonthlyInsrance.self)
        let mAllEtcetora = realm.objects(MonthlyEtcetora.self)
        let mAllUnCategory = realm.objects(MonthlyUnCategory.self)
        let mAllSalary = realm.objects(MonthlySalary.self)
        let mAllTemporary = realm.objects(MonthlyTemporary.self)
        let mAllBusiness = realm.objects(MonthlyBusiness.self)
        let mAllPension = realm.objects(MonthlyPension.self)
        let mAllDevident = realm.objects(MonthlyDevident.self)
        let mAllEstate = realm.objects(MonthlyEstate.self)
        let mAllPayment = realm.objects(MonthlyPayment.self)
        let mAllUnCategory2 = realm.objects(MonthlyUnCategory2.self)

        mFoodArray.append(contentsOf: mAllFood)
        mFoodArray = mFoodArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mBrushArray.append(contentsOf: mAllBrush)
        mBrushArray = mBrushArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mHobbyArray.append(contentsOf: mAllHobby)
        mHobbyArray = mHobbyArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mDatingArray.append(contentsOf: mAllDating)
        mDatingArray = mDatingArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mTrafficArray.append(contentsOf: mAllTraffic)
        mTrafficArray = mTrafficArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mClotheArray.append(contentsOf: mAllClothe)
        mClotheArray = mClotheArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mHealthArray.append(contentsOf: mAllHealth)
        mHealthArray = mHealthArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mCarArray.append(contentsOf: mAllCar)
        mCarArray = mCarArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mEducationArray.append(contentsOf: mAllEducation)
        mEducationArray = mEducationArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mSpecialArray.append(contentsOf: mAllSpecial)
        mSpecialArray = mSpecialArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mCardArray.append(contentsOf: mAllCard)
        mCardArray = mCardArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mUtilityArray.append(contentsOf: mAllUtility)
        mUtilityArray = mUtilityArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mCommunicationArray.append(contentsOf: mAllCommunication)
        mCommunicationArray = mCommunicationArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mHouseArray.append(contentsOf: mAllHouse)
        mHouseArray = mHouseArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mTaxArray.append(contentsOf: mAllTax)
        mTaxArray = mTaxArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mInsranceArray.append(contentsOf: mAllInsrance)
        mInsranceArray = mInsranceArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mEtcetoraArray.append(contentsOf: mAllEtcetora)
        mEtcetoraArray = mEtcetoraArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mUnCategoryArray.append(contentsOf: mAllUnCategory)
        mUnCategoryArray = mUnCategoryArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mSalaryArray.append(contentsOf: mAllSalary)
        mSalaryArray = mSalaryArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mTemporaryArray.append(contentsOf: mAllTemporary)
        mTemporaryArray = mTemporaryArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mBusinessArray.append(contentsOf: mAllBusiness)
        mBusinessArray = mBusinessArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mPensionArray.append(contentsOf: mAllPension)
        mPensionArray = mPensionArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mDevidentArray.append(contentsOf: mAllDevident)
        mDevidentArray = mDevidentArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mEstateArray.append(contentsOf: mAllEstate)
        mEstateArray = mEstateArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mPaymentArray.append(contentsOf: mAllPayment)
        mPaymentArray = mPaymentArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        mUnCategory2Array.append(contentsOf: mAllUnCategory2)
        mUnCategory2Array = mUnCategory2Array.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })

        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            if category == "食費" {
                
                for i in 0..<mFoodArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mFoodArray[i].totalPrice))))

                    let mFood = realm.objects(MonthlyFood.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mFoodArray2.append(contentsOf: mFood)
                    for _ in mFoodArray2 { setupLabel(array: mFoodArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mFoodArray)
                    dataSet.colors = [UIColor(named: "vermilion")!]
                }
            } else if category == "日用品" {
                for i in 0..<mBrushArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mBrushArray[i].totalPrice))))
                    
                    let mBrush = realm.objects(MonthlyBrush.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mBrushArray2.append(contentsOf: mBrush)
                    for _ in mBrushArray2 { setupLabel(array: mBrushArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mBrushArray)
                    dataSet.colors = [UIColor(named: "icon_color2")!]
                }
            } else if category == "趣味" {
                for i in 0..<mHobbyArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mHobbyArray[i].totalPrice))))
                    
                    let mHobby = realm.objects(MonthlyHobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mHobbyArray2.append(contentsOf: mHobby)
                    for _ in mHobbyArray2 { setupLabel(array: mHobbyArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mHobbyArray)
                    dataSet.colors = [UIColor(named: "icon_color3")!]
                }
            } else if category == "交際費" {
                for i in 0..<mDatingArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mDatingArray[i].totalPrice))))
                    
                    let mDating = realm.objects(MonthlyDating.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mDatingArray2.append(contentsOf: mDating)
                    for _ in mDatingArray2 { setupLabel(array: mDatingArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mDatingArray)
                    dataSet.colors = [UIColor(named: "icon_color4")!]
                }
            } else if category == "交通費" {
                for i in 0..<mTrafficArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mTrafficArray[i].totalPrice))))
                    
                    let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mTrafficArray2.append(contentsOf: mTraffic)
                    for _ in mTrafficArray2 { setupLabel(array: mTrafficArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mTrafficArray)
                    dataSet.colors = [UIColor(named: "icon_color5")!]
                }
            } else if category == "衣服・美容" {
                for i in 0..<mClotheArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mClotheArray[i].totalPrice))))
                    
                    let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mClotheArray2.append(contentsOf: mClothe)
                    for _ in mClotheArray2 { setupLabel(array: mClotheArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mClotheArray)
                    dataSet.colors = [UIColor(named: "icon_color6")!]
                }
            } else if category == "健康・医療" {
                for i in 0..<mHealthArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mHealthArray[i].totalPrice))))
                    
                    let mHealth = realm.objects(MonthlyHealth.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mHealthArray2.append(contentsOf: mHealth)
                    for _ in mHealthArray2 { setupLabel(array: mHealthArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mHealthArray)
                    dataSet.colors = [UIColor(named: "icon_color7")!]
                }
            } else if category == "自動車" {
                for i in 0..<mCarArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mCarArray[i].totalPrice))))
                    
                    let mCar = realm.objects(MonthlyCar.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mCarArray2.append(contentsOf: mCar)
                    for _ in mCarArray2 { setupLabel(array: mCarArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mCarArray)
                    dataSet.colors = [UIColor(named: "icon_color8")!]
                }
            } else if category == "教養・教育" {
                for i in 0..<mEducationArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mEducationArray[i].totalPrice))))
                    
                    let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mEducationArray2.append(contentsOf: mEducation)
                    for _ in mEducationArray2 { setupLabel(array: mEducationArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mEducationArray)
                    dataSet.colors = [UIColor(named: "icon_color9")!]
                }
            } else if category == "特別な支出" {
                for i in 0..<mSpecialArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mSpecialArray[i].totalPrice))))
                    
                    let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mSpecialArray2.append(contentsOf: mSpecial)
                    for _ in mSpecialArray2 { setupLabel(array: mSpecialArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mSpecialArray)
                    dataSet.colors = [UIColor(named: "icon_color10")!]
                }
            } else if category == "現金・カード" {
                for i in 0..<mCardArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mCardArray[i].totalPrice))))
                    
                    let mCard = realm.objects(MonthlyCard.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mCardArray2.append(contentsOf: mCard)
                    for _ in mCardArray2 { setupLabel(array: mCardArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mCardArray)
                    dataSet.colors = [UIColor(named: "icon_color24")!]
                }
            } else if category == "水道・光熱費" {
                for i in 0..<mUtilityArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mUtilityArray[i].totalPrice))))
                    
                    let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mUtilityArray2.append(contentsOf: mUtility)
                    for _ in mUtilityArray2 { setupLabel(array: mUtilityArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mUtilityArray)
                    dataSet.colors = [UIColor(named: "icon_color11")!]
                }
            } else if category == "通信費" {
                for i in 0..<mCommunicationArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mCommunicationArray[i].totalPrice))))
                    
                    let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mCommunicationArray2.append(contentsOf: mCommunication)
                    for _ in mCommunicationArray2 { setupLabel(array: mCommunicationArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mCommunicationArray)
                    dataSet.colors = [UIColor(named: "icon_color12")!]
                }
            } else if category == "住宅" {
                for i in 0..<mHouseArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mHouseArray[i].totalPrice))))
                    
                    let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mHouseArray2.append(contentsOf: mHouse)
                    for _ in mHouseArray2 { setupLabel(array: mHouseArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mHouseArray)
                    dataSet.colors = [UIColor(named: "icon_color13")!]
                }
            } else if category == "税・社会保険" {
                for i in 0..<mTaxArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mTaxArray[i].totalPrice))))
                    
                    let mTax = realm.objects(MonthlyTax.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mTaxArray2.append(contentsOf: mTax)
                    for _ in mTaxArray2 { setupLabel(array: mTaxArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mTaxArray)
                    dataSet.colors = [UIColor(named: "icon_color14")!]
                }
            } else if category == "保険" {
                for i in 0..<mInsranceArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mInsranceArray[i].totalPrice))))
                    
                    let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mInsranceArray2.append(contentsOf: mInsrance)
                    for _ in mInsranceArray2 { setupLabel(array: mInsranceArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mInsranceArray)
                    dataSet.colors = [UIColor(named: "icon_color15")!]
                }
            } else if category == "その他" {
                for i in 0..<mEtcetoraArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mEtcetoraArray[i].totalPrice))))
                    
                    let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mEtcetoraArray2.append(contentsOf: mEtcetora)
                    for _ in mEtcetoraArray2 { setupLabel(array: mEtcetoraArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mEtcetoraArray)
                    dataSet.colors = [UIColor(named: "icon_color16")!]
                }
            } else if category == "未分類" {
                for i in 0..<mUnCategoryArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mUnCategoryArray[i].totalPrice))))
                    
                    let mUnCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mUnCategoryArray2.append(contentsOf: mUnCategory)
                    for _ in mUnCategoryArray2 { setupLabel(array: mUnCategoryArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mUnCategoryArray)
                    dataSet.colors = [UIColor.systemGray]
                }
            }
        } else {
            if category == "給与" {
                for i in 0..<mSalaryArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mSalaryArray[i].totalPrice))))
                    
                    let mSalary = realm.objects(MonthlySalary.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mSalaryArray2.append(contentsOf: mSalary)
                    for _ in mSalaryArray2 { setupLabel(array: mSalaryArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mSalaryArray)
                    dataSet.colors = [UIColor(named: "icon_color17")!]
                }
            } else if category == "一時所得" {
                for i in 0..<mTemporaryArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mTemporaryArray[i].totalPrice))))
                    
                    let mTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mTemporaryArray2.append(contentsOf: mTemporary)
                    for _ in mTemporaryArray2 { setupLabel(array: mTemporaryArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mTemporaryArray)
                    dataSet.colors = [UIColor(named: "icon_color18")!]
                }
            } else if category == "事業・副業" {
                for i in 0..<mBusinessArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mBusinessArray[i].totalPrice))))
                    
                    let mBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mBusinessArray2.append(contentsOf: mBusiness)
                    for _ in mBusinessArray2 { setupLabel(array: mBusinessArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mBusinessArray)
                    dataSet.colors = [UIColor(named: "icon_color19")!]
                }
            } else if category == "年金" {
                for i in 0..<mPensionArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mPensionArray[i].totalPrice))))
                    
                    let mPension = realm.objects(MonthlyPension.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mPensionArray2.append(contentsOf: mPension)
                    for _ in mPensionArray2 { setupLabel(array: mPensionArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mPensionArray)
                    dataSet.colors = [UIColor(named: "icon_color20")!]
                }
            } else if category == "配当所得" {
                for i in 0..<mDevidentArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mDevidentArray[i].totalPrice))))
                    
                    let mDevident = realm.objects(MonthlyDevident.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mDevidentArray2.append(contentsOf: mDevident)
                    for _ in mDevidentArray2 { setupLabel(array: mDevidentArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mDevidentArray)
                    dataSet.colors = [UIColor(named: "icon_color21")!]
                }
            } else if category == "不動産所得" {
                for i in 0..<mEstateArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mEstateArray[i].totalPrice))))
                    
                    let mEstate = realm.objects(MonthlyEstate.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mEstateArray2.append(contentsOf: mEstate)
                    for _ in mEstateArray2 { setupLabel(array: mEstateArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mEstateArray)
                    dataSet.colors = [UIColor(named: "icon_color22")!]
                }
            } else if category == "その他入金" {
                for i in 0..<mPaymentArray.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mPaymentArray[i].totalPrice))))
                    
                    let mPayment = realm.objects(MonthlyPayment.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mPaymentArray2.append(contentsOf: mPayment)
                    for _ in mPaymentArray2 { setupLabel(array: mPaymentArray2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mPaymentArray)
                    dataSet.colors = [UIColor(named: "icon_color23")!]
                }
            } else if category == "未分類" {
                for i in 0..<mUnCategory2Array.count {
                    dataEntries.append((BarChartDataEntry(x: Double(i), y: Double(mUnCategory2Array[i].totalPrice))))
                    
                    let mUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")
                    mUnCategory2Array2.append(contentsOf: mUnCategory2)
                    for _ in mUnCategory2Array2 { setupLabel(array: mUnCategory2Array2) }
                    let dataSet = BarChartDataSet(entries: dataEntries)
                    let data = BarChartData(dataSet: dataSet)
                    
                    barChartView.data = data
                    setupBarWidth(dataSet, data, mArray: mUnCategory2Array)
                    dataSet.colors = [UIColor.systemGray]
                }
            }
        }
        setupBarchart()
        
        if UserDefaults.standard.object(forKey: ON_SCROLL) == nil {
            scrollView.contentOffset = CGPoint(x: chartViewWidth.constant - 375, y: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                detailVC?.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    UserDefaults.standard.set(true, forKey: ON_SCROLL)
                }
            }
        }
    }
    
    private func setupLabel(array: [Any]) {
        array.forEach { (mData) in
            let result = String.localizedStringWithFormat("%d", (mData as AnyObject).totalPrice)
            totalPriceLabel.text = "¥" + result
            timestampLabel.text = (mData as AnyObject).timestamp
            dateLabel.text = (mData as AnyObject).monthly
        }
    }
    
    private func setupLabel2(_ totalPrice: Int, _ timestamp: String, monthly: String) {
        
        let result = String.localizedStringWithFormat("%d",totalPrice)
        totalPriceLabel.text = "¥" + result
        timestampLabel.text = timestamp
        dateLabel.text = monthly
    }
    
    private func setupBarWidth(_ dataSet: BarChartDataSet, _ data: BarChartData, mArray: [Any]) {
        
        arrayCount += 1
        if arrayCount <= mArray.count {
            barWidthValue += 1
            if mArray.count >= 6 {
                chartViewWidth.constant += 20
            }
        }
        if barWidthValue <= 8 {
            let barWidht = "0." + String(barWidthValue)
            data.barWidth = Double(barWidht)!
        } else if barWidthValue >= 9 {
            data.barWidth = 0.7
        }
        dataSet.valueFont = UIFont(name: "HiraMaruProN-W4", size: 12)!
    }
    
    private func setupBarchart() {
        
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.drawLabelsEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.drawZeroLineEnabled = false
        barChartView.leftAxis.labelFont = UIFont(name: "", size: 0)!
        barChartView.leftAxis.gridColor = .clear
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.legend.enabled = false
        barChartView.legend.font = UIFont(name: "HiraMaruProN-W4", size: 15)!
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = .black
        barChartView.xAxis.axisLineColor = .black
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CVWidth = Int(UIScreen.main.bounds.width)
        chartViewWidth.constant = CGFloat(CVWidth)
        setupLayout()
    }
    
    private func setupLayout() {
        
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
        
        viewHeight.constant = 65
        chartViewHeight.constant = 350

        dateLabel.font = UIFont(name: "HiraMaruProN-W4", size: 15)
        totalPriceLabel.font = UIFont(name: "HiraMaruProN-W4", size: 35)
        timestampLabel.font = UIFont(name: "HiraMaruProN-W4", size: 18)
    }
    
    private func changeLayout2() {
        
        viewHeight.constant = 75
        chartViewHeight.constant = 400

        dateLabel.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        totalPriceLabel.font = UIFont(name: "HiraMaruProN-W4", size: 40)
        timestampLabel.font = UIFont(name: "HiraMaruProN-W4", size: 21)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if let dataSet = barChartView.data?.dataSets[highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            
            if UserDefaults.standard.object(forKey: CHANGE) == nil {
                if category == "食費" {
                    setupCategoryAndDate(mFoodArray, sliceIndex)
                } else if category == "日用品" {
                    setupCategoryAndDate(mBrushArray, sliceIndex)
                } else if category == "趣味" {
                    setupCategoryAndDate(mHobbyArray, sliceIndex)
                } else if category == "交際費" {
                    setupCategoryAndDate(mDatingArray, sliceIndex)
                } else if category == "交通費" {
                    setupCategoryAndDate(mTrafficArray, sliceIndex)
                } else if category == "衣服・美容" {
                    setupCategoryAndDate(mClotheArray, sliceIndex)
                } else if category == "健康・医療" {
                    setupCategoryAndDate(mHealthArray, sliceIndex)
                } else if category == "自動車" {
                    setupCategoryAndDate(mCarArray, sliceIndex)
                } else if category == "教養・教育" {
                    setupCategoryAndDate(mEducationArray, sliceIndex)
                } else if category == "特別な支出" {
                    setupCategoryAndDate(mSpecialArray, sliceIndex)
                } else if category == "現金・カード" {
                    setupCategoryAndDate(mCardArray, sliceIndex)
                } else if category == "水道・光熱費" {
                    setupCategoryAndDate(mUtilityArray, sliceIndex)
                } else if category == "通信費" {
                    setupCategoryAndDate(mCommunicationArray, sliceIndex)
                } else if category == "住宅" {
                    setupCategoryAndDate(mHouseArray, sliceIndex)
                } else if category == "税・社会保険" {
                    setupCategoryAndDate(mTaxArray, sliceIndex)
                } else if category == "保険" {
                    setupCategoryAndDate(mInsranceArray, sliceIndex)
                } else if category == "その他" {
                    setupCategoryAndDate(mEtcetoraArray, sliceIndex)
                } else if category == "未分類" {
                    setupCategoryAndDate(mUnCategoryArray, sliceIndex)
                }
            } else {
                if category == "給与" {
                    setupCategoryAndDate(mSalaryArray, sliceIndex)
                } else if category == "一時所得" {
                    setupCategoryAndDate(mTemporaryArray, sliceIndex)
                } else if category == "事業・副業" {
                    setupCategoryAndDate(mBusinessArray, sliceIndex)
                } else if category == "年金" {
                    setupCategoryAndDate(mPensionArray, sliceIndex)
                } else if category == "配当所得" {
                    setupCategoryAndDate(mDevidentArray, sliceIndex)
                } else if category == "不動産所得" {
                    setupCategoryAndDate(mEstateArray, sliceIndex)
                } else if category == "その他入金" {
                    setupCategoryAndDate(mPaymentArray, sliceIndex)
                } else if category == "未分類" {
                    setupCategoryAndDate(mUnCategory2Array, sliceIndex)
                }
            }
        }
    }
    
    private func setupCategoryAndDate(_ array: [Any], _ sliceIndex: Int) {
        
        let totalPrice = (array[sliceIndex] as AnyObject).totalPrice
        let timestamp: String = (array[sliceIndex] as AnyObject).timestamp
        let monthly: String = (array[sliceIndex] as AnyObject).monthly
        let category: String = (array[sliceIndex] as AnyObject).category
        let year: String = (array[sliceIndex] as AnyObject).year
        let month: String = (array[sliceIndex] as AnyObject).month

        UserDefaults.standard.set(category, forKey: CATEGORY)
        UserDefaults.standard.set(year, forKey: YEAR)
        UserDefaults.standard.set(month, forKey: MONTHE)
        detailVC?.viewWillAppear(true)
        detailVC?.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [self] in
            setupLabel2(totalPrice!, timestamp, monthly: monthly)
        }
    }
}
