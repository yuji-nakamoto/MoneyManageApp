//
//  HomeViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/05.
//

import UIKit
import GoogleMobileAds
import RealmSwift
import AVFoundation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var autofillView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var player = AVAudioPlayer()
    private let soundFile = Bundle.main.path(forResource: "pa1", ofType: "mp3")
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var autoArray1 = [Auto]()
    private var autoArray2 = [Auto]()
    private var autoArray3 = [Auto]()
    private var autoArray4 = [Auto]()
    
    private var firstDayString: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: firstday!)
    }
    
    private var lastDayString: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: lastday!)
    }
    
    var yearMonthTotal: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年M月合計"
        return dateFormatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showHintView()
        setupBanner()
        removeUserDefaults()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if autofillView.isHidden == false {
            autofillView.isHidden = true
        }
        setupSound()
        isAutofill()
        tableView.reloadData()
    }
    
    @IBAction func closeButtonPressd(_ sender: Any) {
        UIView.animate(withDuration: 0.5) { [self] in
            self.autofillView.isHidden = !self.autofillView.isHidden
        }
    }
    
    @IBAction func closeButton2Pressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.hintView.alpha = 0
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: END_TUTORIAL2)
        }
    }
    
    private func isAutofill() {
        
        let realm = try! Realm()
        // 自動入力作成時 & 入出金反映時
        let auto1 = realm.objects(Auto.self).filter("isInput == false").filter("onRegister == false")
        // 自動入力反映後
        let auto2 = realm.objects(Auto.self).filter("isInput == true").filter("onRegister == false")
        // 入出金一覧から自動入力登録時
        // 入力作成時の自動入力登録時
        let auto3 = realm.objects(Auto.self).filter("isInput == true").filter("onRegister == true")
        
        autoArray1.removeAll()
        autoArray2.removeAll()
        autoArray3.removeAll()
        autoArray4.removeAll()
        autoArray1.append(contentsOf: auto1)
        autoArray2.append(contentsOf: auto2)
        autoArray3.append(contentsOf: auto3)
        
        autoArray1.forEach { (auto) in
            if yyyy_mm_dd >= auto.date {
                autoArray4.append(auto)
                writeData(auto)
            }
        }
        
        autoArray2.forEach { (auto) in
            if yyyy_mm_dd >= auto.nextMonth {
                try! realm.write {
                    auto.isInput = false
                }
                tableView.reloadData()
            }
        }
        
        autoArray3.forEach { (auto) in
            prepareUpdate(auto)
        }
    }
    
    private func writeData(_ auto: Auto) {
        
        let realm = try! Realm()
        var day = auto.day
        let calendar = Calendar.current
        var dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
        let nextDateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: 1))
        let spending = Spending()
        let food = Food()
        let brush = Brush()
        let hobby = Hobby()
        let dating = Dating()
        let traffic = Traffic()
        let clothe = Clothe()
        let health = Health()
        let car = Car()
        let education = Education()
        let special = Special()
        let card = Card()
        let utility = Utility()
        let communication = Communicaton()
        let house = House()
        let tax = Tax()
        let insrance = Insrance()
        let etcetora = Etcetora()
        let unCategory = UnCategory()
        let income = Income()
        let salary = Salary()
        let temporary = Temporary()
        let business = Business()
        let pension = Pension()
        let devident = Devident()
        let estate = Estate()
        let payment = Payment()
        let unCategory2 = UnCategory2()
        
        if auto.payment == "支出" {
            
            if auto.isRegister == true {
                spendingData(spending, auto)
                spending.isAutofill = true
                try! realm.write() {
                    realm.add(spending)
                }
            } else {
                spendingData(spending, auto)
                try! realm.write() {
                    realm.add(spending)
                }
            }
            
            if auto.category == "食費" {
                foodData(food, auto)
                mFoodCreate(auto)
                try! realm.write {
                    realm.add(food)
                }
            } else if auto.category == "日用品" {
                brushData(brush, auto)
                mBrushCreate(auto)
                try! realm.write {
                    realm.add(brush)
                }
            } else if auto.category == "趣味" {
                hobbyData(hobby, auto)
                mHobbyCreate(auto)
                try! realm.write {
                    realm.add(hobby)
                }
            } else if auto.category == "交際費" {
                datingData(dating, auto)
                mDatingCreate(auto)
                try! realm.write {
                    realm.add(dating)
                }
            } else if auto.category == "交通費" {
                trafficData(traffic, auto)
                mTrafficCreate(auto)
                try! realm.write {
                    realm.add(traffic)
                }
            } else if auto.category == "衣服・美容" {
                clotheData(clothe, auto)
                mClotheCreate(auto)
                try! realm.write {
                    realm.add(clothe)
                }
            } else if auto.category == "健康・医療" {
                healthData(health, auto)
                mHealthCreate(auto)
                try! realm.write {
                    realm.add(health)
                }
            } else if auto.category == "自動車" {
                carData(car, auto)
                mCarCreate(auto)
                try! realm.write {
                    realm.add(car)
                }
            } else if auto.category == "教養・教育" {
                educationData(education, auto)
                mEducationCreate(auto)
                try! realm.write {
                    realm.add(education)
                }
            } else if auto.category == "特別な支出" {
                specialData(special, auto)
                mSpecialCreate(auto)
                try! realm.write {
                    realm.add(special)
                }
            } else if auto.category == "現金・カード" {
                cardData(card, auto)
                mCardCreate(auto)
                try! realm.write {
                    realm.add(card)
                }
            } else if auto.category == "水道・光熱費" {
                utilityData(utility, auto)
                mUtilityCreate(auto)
                try! realm.write {
                    realm.add(utility)
                }
            } else if auto.category == "通信費" {
                communicationData(communication, auto)
                mCommunicationCreate(auto)
                try! realm.write {
                    realm.add(communication)
                }
            } else if auto.category == "住宅" {
                houseData(house, auto)
                mHouseCreate(auto)
                try! realm.write {
                    realm.add(house)
                }
            } else if auto.category == "税・社会保険" {
                taxData(tax, auto)
                mTaxCreate(auto)
                try! realm.write {
                    realm.add(tax)
                }
            } else if auto.category == "保険" {
                insranceData(insrance, auto)
                mInsranceCreate(auto)
                try! realm.write {
                    realm.add(insrance)
                }
            } else if auto.category == "その他" {
                etcetoraData(etcetora, auto)
                mEtcetoraCreate(auto)
                try! realm.write {
                    realm.add(etcetora)
                }
            } else if auto.category == "未分類" {
                unCategoryData(unCategory, auto)
                mUnCategoryCreate(auto)
                try! realm.write {
                    realm.add(unCategory)
                }
            }
            
            try! realm.write {
                if auto.autofillDay == "月末" {
                    
                    day = Int(lastDay2String)!
                    dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                } else {
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                }
                auto.month = Int(month)! + 1
                auto.day = day
                auto.isInput = true
            }
            
            categoryLabel.text = spending.category
            if spending.memo == "" {
                memoLabel.text = spending.category
            } else {
                memoLabel.text = spending.memo
            }
            let result = String.localizedStringWithFormat("%d", spending.price)
            priceLabel.text = "¥" + result
            totalLabel.text = "合計\(autoArray4.count)件の自動入力を行いました"
            setCategorySpendingImage(spending)
            showAutofillView()
            
        } else {
            
            if auto.isRegister == true {
                incomeData(income, auto)
                income.isAutofill = true
                try! realm.write {
                    realm.add(income)
                }
            } else {
                incomeData(income, auto)
                try! realm.write {
                    realm.add(income)
                }
            }
            
            if auto.category == "給与" {
                salaryData(salary, auto)
                mSalaryCreate(auto)
                try! realm.write {
                    realm.add(salary)
                }
            } else if auto.category == "一時所得" {
                temporaryData(temporary, auto)
                mTemporaryCreate(auto)
                try! realm.write {
                    realm.add(temporary)
                }
            } else if auto.category == "事業・副業" {
                businessData(business, auto)
                mBusinessCreate(auto)
                try! realm.write {
                    realm.add(business)
                }
            } else if auto.category == "年金" {
                pensionData(pension, auto)
                mPensionCreate(auto)
                try! realm.write {
                    realm.add(pension)
                }
            } else if auto.category == "配当所得" {
                devidentData(devident, auto)
                mDevidentCreate(auto)
                try! realm.write {
                    realm.add(devident)
                }
            } else if auto.category == "不動産所得" {
                estateData(estate, auto)
                mEstateCreate(auto)
                try! realm.write {
                    realm.add(estate)
                }
            } else if auto.category == "その他入金" {
                paymentData(payment, auto)
                mPaymentCreate(auto)
                try! realm.write {
                    realm.add(payment)
                }
            } else if auto.category == "未分類" {
                unCategory2Data(unCategory2, auto)
                mUnCategory2Create(auto)
                try! realm.write {
                    realm.add(unCategory2)
                }
            }
            
            try! realm.write {
                if auto.autofillDay == "月末" {
                    
                    day = Int(lastDay2String)!
                    dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                } else {
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                }
                auto.month = Int(month)! + 1
                auto.day = day
                auto.isInput = true
            }
            
            categoryLabel.text = income.category
            if income.memo == "" {
                memoLabel.text = income.category
            } else {
                memoLabel.text = income.memo
            }
            let result = String.localizedStringWithFormat("%d", income.price)
            priceLabel.text = "¥" + result
            totalLabel.text = "合計\(autoArray4.count)件の自動入力を行いました"
            setCategoryIncomeImage(income)
            showAutofillView()
        }
        tableView.reloadData()
    }
    
    private func prepareUpdate(_ auto: Auto) {
        
        var day = auto.day
        let calendar = Calendar.current
        var dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month + 1, day: day))
        let nextDateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: 1))
        
        if auto.autofillDay == "月末" {
            
            day = Int(lastDay2String)!
            dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
            formatterFunc2(auto, dateComp!, nextDateComp!, day)
        } else {
            formatterFunc2(auto, dateComp!, nextDateComp!, day)
        }
    }
    
    // MARK: - Spending data
    
    private func spendingData(_ spending: Spending, _ auto: Auto) {
        
        spending.price = auto.price
        spending.category = auto.category
        spending.memo = auto.memo
        spending.timestamp = auto.timestamp
        spending.date = auto.date
        spending.year = year
        spending.month = month
        spending.day = String(auto.day)
        spending.id = auto.id
    }
    
    private func foodData(_ food: Food, _ auto: Auto) {
        
        food.price = auto.price
        food.category = auto.category
        food.memo = auto.memo
        food.timestamp = auto.timestamp
        food.year = year
        food.month = month
        food.day = String(auto.day)
        food.id = auto.id
    }
    
    private func brushData(_ brush: Brush, _ auto: Auto) {
        
        brush.price = auto.price
        brush.category = auto.category
        brush.memo = auto.memo
        brush.timestamp = auto.timestamp
        brush.year = year
        brush.month = month
        brush.day = String(auto.day)
        brush.id = auto.id
    }
    
    private func hobbyData(_ hobby: Hobby, _ auto: Auto) {
        
        hobby.price = auto.price
        hobby.category = auto.category
        hobby.memo = auto.memo
        hobby.timestamp = auto.timestamp
        hobby.year = year
        hobby.month = month
        hobby.day = String(auto.day)
        hobby.id = auto.id
    }
    
    private func datingData(_ dating: Dating, _ auto: Auto) {
        
        dating.price = auto.price
        dating.category = auto.category
        dating.memo = auto.memo
        dating.timestamp = auto.timestamp
        dating.year = year
        dating.month = month
        dating.day = String(auto.day)
        dating.id = auto.id
    }
    
    private func trafficData(_ traffic: Traffic, _ auto: Auto) {
        
        traffic.price = auto.price
        traffic.category = auto.category
        traffic.memo = auto.memo
        traffic.timestamp = auto.timestamp
        traffic.year = year
        traffic.month = month
        traffic.day = String(auto.day)
        traffic.id = auto.id
    }
    
    private func clotheData(_ clothe: Clothe, _ auto: Auto) {
        
        clothe.price = auto.price
        clothe.category = auto.category
        clothe.memo = auto.memo
        clothe.timestamp = auto.timestamp
        clothe.year = year
        clothe.month = month
        clothe.day = String(auto.day)
        clothe.id = auto.id
    }
    
    private func healthData(_ health: Health, _ auto: Auto) {
        
        health.price = auto.price
        health.category = auto.category
        health.memo = auto.memo
        health.timestamp = auto.timestamp
        health.year = year
        health.month = month
        health.day = String(auto.day)
        health.id = auto.id
    }
    
    private func carData(_ car: Car, _ auto: Auto) {
        
        car.price = auto.price
        car.category = auto.category
        car.memo = auto.memo
        car.timestamp = auto.timestamp
        car.year = year
        car.month = month
        car.day = String(auto.day)
        car.id = auto.id
    }
    
    private func educationData(_ education: Education, _ auto: Auto) {
        
        education.price = auto.price
        education.category = auto.category
        education.memo = auto.memo
        education.timestamp = auto.timestamp
        education.year = year
        education.month = month
        education.day = String(auto.day)
        education.id = auto.id
    }
    
    private func specialData(_ special: Special, _ auto: Auto) {
        
        special.price = auto.price
        special.category = auto.category
        special.memo = auto.memo
        special.timestamp = auto.timestamp
        special.year = year
        special.month = month
        special.day = String(auto.day)
        special.id = auto.id
    }
    
    private func cardData(_ card: Card, _ auto: Auto) {
        
        card.price = auto.price
        card.category = auto.category
        card.memo = auto.memo
        card.timestamp = auto.timestamp
        card.year = year
        card.month = month
        card.day = String(auto.day)
        card.id = auto.id
    }
    
    private func utilityData(_ utility: Utility, _ auto: Auto) {
        
        utility.price = auto.price
        utility.category = auto.category
        utility.memo = auto.memo
        utility.timestamp = auto.timestamp
        utility.year = year
        utility.month = month
        utility.day = String(auto.day)
        utility.id = auto.id
    }
    
    private func communicationData(_ communication: Communicaton, _ auto: Auto) {
        
        communication.price = auto.price
        communication.category = auto.category
        communication.memo = auto.memo
        communication.timestamp = auto.timestamp
        communication.year = year
        communication.month = month
        communication.day = String(auto.day)
        communication.id = auto.id
    }
    
    private func houseData(_ house: House, _ auto: Auto) {
        
        house.price = auto.price
        house.category = auto.category
        house.memo = auto.memo
        house.timestamp = auto.timestamp
        house.year = year
        house.month = month
        house.day = String(auto.day)
        house.id = auto.id
    }
    
    private func taxData(_ tax: Tax, _ auto: Auto) {
        
        tax.price = auto.price
        tax.category = auto.category
        tax.memo = auto.memo
        tax.timestamp = auto.timestamp
        tax.year = year
        tax.month = month
        tax.day = String(auto.day)
        tax.id = auto.id
    }
    
    private func insranceData(_ insrance: Insrance, _ auto: Auto) {
        
        insrance.price = auto.price
        insrance.category = auto.category
        insrance.memo = auto.memo
        insrance.timestamp = auto.timestamp
        insrance.year = year
        insrance.month = month
        insrance.day = String(auto.day)
        insrance.id = auto.id
    }
    
    private func etcetoraData(_ etcetora: Etcetora, _ auto: Auto) {
        
        etcetora.price = auto.price
        etcetora.category = auto.category
        etcetora.memo = auto.memo
        etcetora.timestamp = auto.timestamp
        etcetora.year = year
        etcetora.month = month
        etcetora.day = String(auto.day)
        etcetora.id = auto.id
    }
    
    private func unCategoryData(_ unCategory: UnCategory, _ auto: Auto) {
        
        unCategory.price = auto.price
        unCategory.category = auto.category
        unCategory.memo = auto.memo
        unCategory.timestamp = auto.timestamp
        unCategory.year = year
        unCategory.month = month
        unCategory.day = String(auto.day)
        unCategory.id = auto.id
    }
    
    // MARK: - Monthly create
    
    private func mFoodCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mFood = realm.objects(MonthlyFood.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mFood.count == 0 {
            let mFood = MonthlyFood()
            mFood.totalPrice = auto.price
            mFood.category = "食費"
            mFood.timestamp = yearMonthTotal
            mFood.monthly = "(\(firstDayString)~\(lastDayString))"
            mFood.date = yyyy_mm
            mFood.year = year
            mFood.month = month
            try! realm.write {
                realm.add(mFood)
            }
        } else {
            mFood.forEach { (mFood) in
                try! realm.write {
                    mFood.totalPrice = mFood.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mBrushCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mBrush = realm.objects(MonthlyBrush.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mBrush.count == 0 {
            let mBrush = MonthlyBrush()
            mBrush.totalPrice = auto.price
            mBrush.category = "日用品"
            mBrush.timestamp = yearMonthTotal
            mBrush.monthly = "(\(firstDayString)~\(lastDayString))"
            mBrush.date = yyyy_mm
            mBrush.year = year
            mBrush.month = month
            try! realm.write {
                realm.add(mBrush)
            }
        } else {
            mBrush.forEach { (mBrush) in
                try! realm.write {
                    mBrush.totalPrice = mBrush.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mHobbyCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mHobby = realm.objects(MonthlyHobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mHobby.count == 0 {
            let mHobby = MonthlyHobby()
            mHobby.totalPrice = auto.price
            mHobby.category = "趣味"
            mHobby.timestamp = yearMonthTotal
            mHobby.monthly = "(\(firstDayString)~\(lastDayString))"
            mHobby.date = yyyy_mm
            mHobby.year = year
            mHobby.month = month
            try! realm.write {
                realm.add(mHobby)
            }
        } else {
            mHobby.forEach { (mHobby) in
                try! realm.write {
                    mHobby.totalPrice = mHobby.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mDatingCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mDating = realm.objects(MonthlyDating.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mDating.count == 0 {
            let mDating = MonthlyDating()
            mDating.totalPrice = auto.price
            mDating.category = "交際費"
            mDating.timestamp = yearMonthTotal
            mDating.monthly = "(\(firstDayString)~\(lastDayString))"
            mDating.date = yyyy_mm
            mDating.year = year
            mDating.month = month
            try! realm.write {
                realm.add(mDating)
            }
        } else {
            mDating.forEach { (mDating) in
                try! realm.write {
                    mDating.totalPrice = mDating.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mTrafficCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mTraffic.count == 0 {
            let mTraffic = MonthlyTraffic()
            mTraffic.totalPrice = auto.price
            mTraffic.category = "交通費"
            mTraffic.timestamp = yearMonthTotal
            mTraffic.monthly = "(\(firstDayString)~\(lastDayString))"
            mTraffic.date = yyyy_mm
            mTraffic.year = year
            mTraffic.month = month
            try! realm.write {
                realm.add(mTraffic)
            }
        } else {
            mTraffic.forEach { (mTraffic) in
                try! realm.write {
                    mTraffic.totalPrice = mTraffic.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mClotheCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mClothe.count == 0 {
            let mClothe = MonthlyClothe()
            mClothe.totalPrice = auto.price
            mClothe.category = "衣服・美容"
            mClothe.timestamp = yearMonthTotal
            mClothe.monthly = "(\(firstDayString)~\(lastDayString))"
            mClothe.date = yyyy_mm
            mClothe.year = year
            mClothe.month = month
            try! realm.write {
                realm.add(mClothe)
            }
        } else {
            mClothe.forEach { (mClothe) in
                try! realm.write {
                    mClothe.totalPrice = mClothe.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mHealthCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mHealth = realm.objects(MonthlyHealth.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mHealth.count == 0 {
            let mHealth = MonthlyHealth()
            mHealth.totalPrice = auto.price
            mHealth.category = "健康・医療"
            mHealth.timestamp = yearMonthTotal
            mHealth.monthly = "(\(firstDayString)~\(lastDayString))"
            mHealth.date = yyyy_mm
            mHealth.year = year
            mHealth.month = month
            try! realm.write {
                realm.add(mHealth)
            }
        } else {
            mHealth.forEach { (mHealth) in
                try! realm.write {
                    mHealth.totalPrice = mHealth.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mCarCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mCar = realm.objects(MonthlyCar.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mCar.count == 0 {
            let mCar = MonthlyCar()
            mCar.totalPrice = auto.price
            mCar.category = "自動車"
            mCar.timestamp = yearMonthTotal
            mCar.monthly = "(\(firstDayString)~\(lastDayString))"
            mCar.date = yyyy_mm
            mCar.year = year
            mCar.month = month
            try! realm.write {
                realm.add(mCar)
            }
        } else {
            mCar.forEach { (mCar) in
                try! realm.write {
                    mCar.totalPrice = mCar.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mEducationCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mEducation.count == 0 {
            let mEducation = MonthlyEducation()
            mEducation.totalPrice = auto.price
            mEducation.category = "教養・教育"
            mEducation.timestamp = yearMonthTotal
            mEducation.monthly = "(\(firstDayString)~\(lastDayString))"
            mEducation.date = yyyy_mm
            mEducation.year = year
            mEducation.month = month
            try! realm.write {
                realm.add(mEducation)
            }
        } else {
            mEducation.forEach { (mEducation) in
                try! realm.write {
                    mEducation.totalPrice = mEducation.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mSpecialCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mSpecial.count == 0 {
            let mSpecial = MonthlySpecial()
            mSpecial.totalPrice = auto.price
            mSpecial.category = "特別な支出"
            mSpecial.timestamp = yearMonthTotal
            mSpecial.monthly = "(\(firstDayString)~\(lastDayString))"
            mSpecial.date = yyyy_mm
            mSpecial.year = year
            mSpecial.month = month
            try! realm.write {
                realm.add(mSpecial)
            }
        } else {
            mSpecial.forEach { (mSpecial) in
                try! realm.write {
                    mSpecial.totalPrice = mSpecial.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mUtilityCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mUtility.count == 0 {
            let mUtility = MonthlyUtility()
            mUtility.totalPrice = auto.price
            mUtility.category = "水道・光熱費"
            mUtility.timestamp = yearMonthTotal
            mUtility.monthly = "(\(firstDayString)~\(lastDayString))"
            mUtility.date = yyyy_mm
            mUtility.year = year
            mUtility.month = month
            try! realm.write {
                realm.add(mUtility)
            }
        } else {
            mUtility.forEach { (mUtility) in
                try! realm.write {
                    mUtility.totalPrice = mUtility.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mCommunicationCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mCommunication.count == 0 {
            let mCommunication = MonthlyCommunication()
            mCommunication.totalPrice = auto.price
            mCommunication.category = "通信費"
            mCommunication.timestamp = yearMonthTotal
            mCommunication.monthly = "(\(firstDayString)~\(lastDayString))"
            mCommunication.date = yyyy_mm
            mCommunication.year = year
            mCommunication.month = month
            try! realm.write {
                realm.add(mCommunication)
            }
        } else {
            mCommunication.forEach { (mCommunication) in
                try! realm.write {
                    mCommunication.totalPrice = mCommunication.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mHouseCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mHouse.count == 0 {
            let mHouse = MonthlyHouse()
            mHouse.totalPrice = auto.price
            mHouse.category = "住宅"
            mHouse.timestamp = yearMonthTotal
            mHouse.monthly = "(\(firstDayString)~\(lastDayString))"
            mHouse.date = yyyy_mm
            mHouse.year = year
            mHouse.month = month
            try! realm.write {
                realm.add(mHouse)
            }
        } else {
            mHouse.forEach { (mHouse) in
                try! realm.write {
                    mHouse.totalPrice = mHouse.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mCardCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mCard = realm.objects(MonthlyCard.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mCard.count == 0 {
            let mCard = MonthlyCard()
            mCard.totalPrice = auto.price
            mCard.category = "現金・カード"
            mCard.timestamp = yearMonthTotal
            mCard.monthly = "(\(firstDayString)~\(lastDayString))"
            mCard.date = yyyy_mm
            mCard.year = year
            mCard.month = month
            try! realm.write {
                realm.add(mCard)
            }
        } else {
            mCard.forEach { (mCard) in
                try! realm.write {
                    mCard.totalPrice = mCard.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mTaxCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mTax = realm.objects(MonthlyTax.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mTax.count == 0 {
            let mTax = MonthlyTax()
            mTax.totalPrice = auto.price
            mTax.category = "税・社会保険"
            mTax.timestamp = yearMonthTotal
            mTax.monthly = "(\(firstDayString)~\(lastDayString))"
            mTax.date = yyyy_mm
            mTax.year = year
            mTax.month = month
            try! realm.write {
                realm.add(mTax)
            }
        } else {
            mTax.forEach { (mTax) in
                try! realm.write {
                    mTax.totalPrice = mTax.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mInsranceCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mInsrance.count == 0 {
            let mInsrance = MonthlyInsrance()
            mInsrance.totalPrice = auto.price
            mInsrance.category = "保険"
            mInsrance.timestamp = yearMonthTotal
            mInsrance.monthly = "(\(firstDayString)~\(lastDayString))"
            mInsrance.date = yyyy_mm
            mInsrance.year = year
            mInsrance.month = month
            try! realm.write {
                realm.add(mInsrance)
            }
        } else {
            mInsrance.forEach { (mInsrance) in
                try! realm.write {
                    mInsrance.totalPrice = mInsrance.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mEtcetoraCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mEtcetora.count == 0 {
            let mEtcetora = MonthlyEtcetora()
            mEtcetora.totalPrice = auto.price
            mEtcetora.category = "その他"
            mEtcetora.timestamp = yearMonthTotal
            mEtcetora.monthly = "(\(firstDayString)~\(lastDayString))"
            mEtcetora.date = yyyy_mm
            mEtcetora.year = year
            mEtcetora.month = month
            try! realm.write {
                realm.add(mEtcetora)
            }
        } else {
            mEtcetora.forEach { (mEtcetora) in
                try! realm.write {
                    mEtcetora.totalPrice = mEtcetora.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mUnCategoryCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mUnCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mUnCategory.count == 0 {
            let mUnCategory = MonthlyUnCategory()
            mUnCategory.totalPrice = auto.price
            mUnCategory.category = "未分類"
            mUnCategory.timestamp = yearMonthTotal
            mUnCategory.monthly = "(\(firstDayString)~\(lastDayString))"
            mUnCategory.date = yyyy_mm
            mUnCategory.year = year
            mUnCategory.month = month
            try! realm.write {
                realm.add(mUnCategory)
            }
        } else {
            mUnCategory.forEach { (mUnCategory) in
                try! realm.write {
                    mUnCategory.totalPrice = mUnCategory.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mSalaryCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mSalary = realm.objects(MonthlySalary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mSalary.count == 0 {
            let mSalary = MonthlySalary()
            mSalary.totalPrice = auto.price
            mSalary.category = "給与"
            mSalary.timestamp = yearMonthTotal
            mSalary.monthly = "(\(firstDayString)~\(lastDayString))"
            mSalary.date = yyyy_mm
            mSalary.year = year
            mSalary.month = month
            try! realm.write {
                realm.add(mSalary)
            }
        } else {
            mSalary.forEach { (mSalary) in
                try! realm.write {
                    mSalary.totalPrice = mSalary.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mTemporaryCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mTemporary.count == 0 {
            let mTemporary = MonthlyTemporary()
            mTemporary.totalPrice = auto.price
            mTemporary.category = "一時所得"
            mTemporary.timestamp = yearMonthTotal
            mTemporary.monthly = "(\(firstDayString)~\(lastDayString))"
            mTemporary.date = yyyy_mm
            mTemporary.year = year
            mTemporary.month = month
            try! realm.write {
                realm.add(mTemporary)
            }
        } else {
            mTemporary.forEach { (mTemporary) in
                try! realm.write {
                    mTemporary.totalPrice = mTemporary.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mBusinessCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mBusiness.count == 0 {
            let mBusiness = MonthlyBusiness()
            mBusiness.totalPrice = auto.price
            mBusiness.category = "事業・副業"
            mBusiness.timestamp = yearMonthTotal
            mBusiness.monthly = "(\(firstDayString)~\(lastDayString))"
            mBusiness.date = yyyy_mm
            mBusiness.year = year
            mBusiness.month = month
            try! realm.write {
                realm.add(mBusiness)
            }
        } else {
            mBusiness.forEach { (mBusiness) in
                try! realm.write {
                    mBusiness.totalPrice = mBusiness.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mPensionCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mPension = realm.objects(MonthlyPension.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mPension.count == 0 {
            let mPension = MonthlyPension()
            mPension.totalPrice = auto.price
            mPension.category = "年金"
            mPension.timestamp = yearMonthTotal
            mPension.monthly = "(\(firstDayString)~\(lastDayString))"
            mPension.date = yyyy_mm
            mPension.year = year
            mPension.month = month
            try! realm.write {
                realm.add(mPension)
            }
        } else {
            mPension.forEach { (mPension) in
                try! realm.write {
                    mPension.totalPrice = mPension.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mDevidentCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mDevident = realm.objects(MonthlyDevident.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mDevident.count == 0 {
            let mDevident = MonthlyDevident()
            mDevident.totalPrice = auto.price
            mDevident.category = "配当所得"
            mDevident.timestamp = yearMonthTotal
            mDevident.monthly = "(\(firstDayString)~\(lastDayString))"
            mDevident.date = yyyy_mm
            mDevident.year = year
            mDevident.month = month
            try! realm.write {
                realm.add(mDevident)
            }
        } else {
            mDevident.forEach { (mDevident) in
                try! realm.write {
                    mDevident.totalPrice = mDevident.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mEstateCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mEstate = realm.objects(MonthlyEstate.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mEstate.count == 0 {
            let mEstate = MonthlyEstate()
            mEstate.totalPrice = auto.price
            mEstate.category = "不動産所得"
            mEstate.timestamp = yearMonthTotal
            mEstate.monthly = "(\(firstDayString)~\(lastDayString))"
            mEstate.date = yyyy_mm
            mEstate.year = year
            mEstate.month = month
            try! realm.write {
                realm.add(mEstate)
            }
        } else {
            mEstate.forEach { (mEstate) in
                try! realm.write {
                    mEstate.totalPrice = mEstate.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mPaymentCreate(_ auto: Auto) {
        
        let realm = try! Realm()
        let mPayment = realm.objects(MonthlyPayment.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mPayment.count == 0 {
            let mPayment = MonthlyPayment()
            mPayment.totalPrice = auto.price
            mPayment.category = "その他入金"
            mPayment.timestamp = yearMonthTotal
            mPayment.monthly = "(\(firstDayString)~\(lastDayString))"
            mPayment.date = yyyy_mm
            mPayment.year = year
            mPayment.month = month
            try! realm.write {
                realm.add(mPayment)
            }
        } else {
            mPayment.forEach { (mPayment) in
                try! realm.write {
                    mPayment.totalPrice = mPayment.totalPrice + auto.price
                }
            }
        }
    }
    
    private func mUnCategory2Create(_ auto: Auto) {
        
        let realm = try! Realm()
        let mUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        if mUnCategory2.count == 0 {
            let mUnCategory2 = MonthlyUnCategory2()
            mUnCategory2.totalPrice = auto.price
            mUnCategory2.category = "未分類"
            mUnCategory2.timestamp = yearMonthTotal
            mUnCategory2.monthly = "(\(firstDayString)~\(lastDayString))"
            mUnCategory2.date = yyyy_mm
            mUnCategory2.year = year
            mUnCategory2.month = month
            try! realm.write {
                realm.add(mUnCategory2)
            }
        } else {
            mUnCategory2.forEach { (mUnCategory2) in
                try! realm.write {
                    mUnCategory2.totalPrice = mUnCategory2.totalPrice + auto.price
                }
            }
        }
    }
    
    // MARK: - Income data
    
    private func incomeData(_ income: Income, _ auto: Auto) {
        
        income.price = auto.price
        income.category = auto.category
        income.memo = auto.memo
        income.timestamp = auto.timestamp
        income.date = auto.date
        income.year = year
        income.month = month
        income.day = String(auto.day)
        income.id = auto.id
    }
    
    private func salaryData(_ salary: Salary, _ auto: Auto) {
        
        salary.price = auto.price
        salary.category = auto.category
        salary.memo = auto.memo
        salary.timestamp = auto.timestamp
        salary.year = year
        salary.month = month
        salary.day = String(auto.day)
        salary.id = auto.id
    }
    
    private func temporaryData(_ temporary: Temporary, _ auto: Auto) {
        
        temporary.price = auto.price
        temporary.category = auto.category
        temporary.memo = auto.memo
        temporary.timestamp = auto.timestamp
        temporary.year = year
        temporary.month = month
        temporary.day = String(auto.day)
        temporary.id = auto.id
    }
    
    private func businessData(_ business: Business, _ auto: Auto) {
        
        business.price = auto.price
        business.category = auto.category
        business.memo = auto.memo
        business.timestamp = auto.timestamp
        business.year = year
        business.month = month
        business.day = String(auto.day)
        business.id = auto.id
    }
    
    private func pensionData(_ pension: Pension, _ auto: Auto) {
        
        pension.price = auto.price
        pension.category = auto.category
        pension.memo = auto.memo
        pension.timestamp = auto.timestamp
        pension.year = year
        pension.month = month
        pension.day = String(auto.day)
        pension.id = auto.id
    }
    
    private func devidentData(_ devident: Devident, _ auto: Auto) {
        
        devident.price = auto.price
        devident.category = auto.category
        devident.memo = auto.memo
        devident.timestamp = auto.timestamp
        devident.year = year
        devident.month = month
        devident.day = String(auto.day)
        devident.id = auto.id
    }
    
    private func estateData(_ estate: Estate, _ auto: Auto) {
        
        estate.price = auto.price
        estate.category = auto.category
        estate.memo = auto.memo
        estate.timestamp = auto.timestamp
        estate.year = year
        estate.month = month
        estate.day = String(auto.day)
        estate.id = auto.id
    }
    
    private func paymentData(_ payment: Payment, _ auto: Auto) {
        
        payment.price = auto.price
        payment.category = auto.category
        payment.memo = auto.memo
        payment.timestamp = auto.timestamp
        payment.year = year
        payment.month = month
        payment.day = String(auto.day)
        payment.id = auto.id
    }
    
    private func unCategory2Data(_ unCategory2: UnCategory2, _ auto: Auto) {
        
        unCategory2.price = auto.price
        unCategory2.category = auto.category
        unCategory2.memo = auto.memo
        unCategory2.timestamp = auto.timestamp
        unCategory2.year = year
        unCategory2.month = month
        unCategory2.day = String(auto.day)
        unCategory2.id = auto.id
    }

    private func formatterFunc1(_ auto: Auto, _ date: Date, _ nextDate: Date) {
        
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: date)
        }
        var date: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        var nextMonth: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: nextDate)
        }
        auto.timestamp = timestamp
        auto.date = date
        auto.nextMonth = nextMonth
    }
    
    private func formatterFunc2(_ auto: Auto, _ date: Date, _ nextDate: Date, _ day: Int) {
        
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: date)
        }
        var date: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        var nextMonth: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: nextDate)
        }
        updateData(auto, timestamp, date, nextMonth, day)
    }
    
    private func updateData(_ auto: Auto, _ timestamp: String, _ date: String, _ nextMonth: String, _ day: Int) {
        
        let realm = try! Realm()
        
        try! realm.write {
            auto.timestamp = timestamp
            auto.date = date
            auto.month = auto.month + 1
            auto.day = day
            auto.nextMonth = nextMonth
            auto.onRegister = false
        }
        tableView.reloadData()
    }
    
    private func setup() {
        navigationItem.title = "ホーム"
        tableView.tableFooterView = UIView()
        hintView.alpha = 0
        hintView.layer.cornerRadius = 10
        closeButton.layer.cornerRadius = 30 / 2
        descriptionLabel.text = "以上でチュートリアルは終了です!\n操作が分からなくなった場合や、他のことも知りたい場合は、ホーム画面右上の歯車マークから'使い方'をタップで確認できます。\n\nまずは左上にある資産の登録を行いましょう！"
    }
    
    private func showAutofillView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.5) { [self] in
                
                autofillView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    player.play()
                    player.numberOfLoops = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        UIView.animate(withDuration: 0.5) {
                            autofillView.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    private func showHintView() {
        
        if UserDefaults.standard.object(forKey: END_TUTORIAL2) == nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                
                visualEffectView.frame = self.view.frame
                view.addSubview(self.visualEffectView)
                visualEffectView.alpha = 0
                view.addSubview(hintView)
            
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    visualEffectView.alpha = 1
                    hintView.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    private func removeUserDefaults() {
        
        UserDefaults.standard.removeObject(forKey: PLUS)
        UserDefaults.standard.removeObject(forKey: MINUS)
        UserDefaults.standard.removeObject(forKey: MULTIPLY)
        UserDefaults.standard.removeObject(forKey: DEVIDE)
    }
    
    func setupSound() {
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFile!))
            player.prepareToPlay()
        } catch  {
            print("Error sound", error.localizedDescription)
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/6064632742"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setCategorySpendingImage(_ spending: Spending) {
        
        if spending.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
        } else if spending.category == "食費" {
            categoryImageView.image = UIImage(named: "food")
        } else if spending.category == "日用品" {
            categoryImageView.image = UIImage(named: "brush")
        } else if spending.category == "趣味" {
            categoryImageView.image = UIImage(named: "hobby")
        } else if spending.category == "交際費" {
            categoryImageView.image = UIImage(named: "dating")
        } else if spending.category == "交通費" {
            categoryImageView.image = UIImage(named: "traffic")
        } else if spending.category == "衣服・美容" {
            categoryImageView.image = UIImage(named: "clothe")
        } else if spending.category == "健康・医療" {
            categoryImageView.image = UIImage(named: "health")
        } else if spending.category == "自動車" {
            categoryImageView.image = UIImage(named: "car")
        } else if spending.category == "教養・教育" {
            categoryImageView.image = UIImage(named: "education")
        } else if spending.category == "特別な支出" {
            categoryImageView.image = UIImage(named: "special")
        } else if spending.category == "現金・カード" {
            categoryImageView.image = UIImage(named: "card")
        } else if spending.category == "水道・光熱費" {
            categoryImageView.image = UIImage(named: "utility")
        } else if spending.category == "通信費" {
            categoryImageView.image = UIImage(named: "communication")
        } else if spending.category == "住宅" {
            categoryImageView.image = UIImage(named: "house")
        } else if spending.category == "税・社会保険" {
            categoryImageView.image = UIImage(named: "tax")
        } else if spending.category == "保険" {
            categoryImageView.image = UIImage(named: "insrance")
        } else if spending.category == "その他" {
            categoryImageView.image = UIImage(named: "etcetra")
        }
    }
    
    private func setCategoryIncomeImage(_ income: Income) {
        
        if income.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
        } else if income.category == "給与" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "一時所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "事業・副業" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "年金" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "配当所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "不動産所得" {
            categoryImageView.image = UIImage(named: "en_mark")
        } else if income.category == "その他入金" {
            categoryImageView.image = UIImage(named: "en_mark")
        }
    }
}

extension HomeViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TotalMoneyTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! BalanceTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3") as! BarChartTableViewCell
        
        if indexPath.row == 0 {
            cell1.fetchTotalMoney()
            return cell1
        } else if indexPath.row == 1 {
            cell2.homeVC = self
            cell2.fetchChart()
            return cell2
        }
        cell3.configureBarChartCell()
        return cell3
    }
}
