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
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var registerHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    private var player = AVAudioPlayer()
    private let soundFile = Bundle.main.path(forResource: "pa1", ofType: "mp3")
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var autoArray1 = [Auto]()
    private var autoArray2 = [Auto]()
    private var autoArray3 = [Auto]()
    private var autoArray4 = [Auto]()
    private let refresh = UIRefreshControl()
    private var categoryImage = UIImage()
    private var totalString = ""
    private var dateString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showHintView()
        setupBanner()
        removeUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSound()
        isAutofill()
        checkNotice1()
        checkRegister()
        tableView.reloadData()
        navigationController?.navigationBar.isHidden = true
        print("Realm URL: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Actions
    
    @IBAction func noticeButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let noticeListVC = storyboard.instantiateViewController(withIdentifier: "NoticeListVC")
        noticeListVC.presentationController?.delegate = self
        self.present(noticeListVC, animated: true, completion: nil)
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let navSettingVC = storyboard.instantiateViewController(withIdentifier: "NavSettingVC")
        navSettingVC.presentationController?.delegate = self
        self.present(navSettingVC, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let inputVC = storyboard.instantiateViewController(withIdentifier: "InputVC")
        inputVC.presentationController?.delegate = self
        self.present(inputVC, animated: true, completion: nil)
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
    
    @objc func refreshTableView(){
        checkRegister()
        checkNotice1()
        isAutofill()
        tableView.reloadData()
        refresh.endRefreshing()
    }
    
    // MARK: - Check notice
    
    private func checkNotice1() {
        
        let realm = try! Realm()
        let notice = realm.objects(Notice.self)
        
        notice.forEach { (n) in
            FNotice.fetchNotice1 { [self] (notice1) in
                if n.noticeId1 != notice1.uid {
                    noticeView.isHidden = false
                    noticeAnimation()
                } else {
                    noticeView.isHidden = true
                    checkNotice2()
                }
            }
        }
    }
    
    private func checkNotice2() {
        
        let realm = try! Realm()
        let notice = realm.objects(Notice.self)
        
        notice.forEach { (n) in
       
            FNotice.fetchNotice2 { [self] (notice2) in
                if n.noticeId2 != notice2.uid {
                    noticeView.isHidden = false
                    noticeAnimation()
                } else {
                    noticeView.isHidden = true
                    checkNotice3()
                }
            }
        }
    }
    
    private func checkNotice3() {
        
        let realm = try! Realm()
        let notice = realm.objects(Notice.self)
        
        notice.forEach { (n) in
       
            FNotice.fetchNotice3 { [self] (notice3) in
                if n.noticeId3 != notice3.uid {
                    noticeView.isHidden = false
                    noticeAnimation()
                } else {
                    noticeView.isHidden = true
                    checkNotice4()
                }
            }
        }
    }
    
    private func checkNotice4() {
        
        let realm = try! Realm()
        let notice = realm.objects(Notice.self)
        
        notice.forEach { (n) in
       
            FNotice.fetchNotice4 { [self] (notice4) in
                if n.noticeId4 != notice4.uid {
                    noticeView.isHidden = false
                    noticeAnimation()
                } else {
                    noticeView.isHidden = true
                    checkNotice5()
                }
            }
        }
    }
    
    private func checkNotice5() {
        
        let realm = try! Realm()
        let notice = realm.objects(Notice.self)
        
        notice.forEach { (n) in
       
            FNotice.fetchNotice5 { [self] (notice5) in
                if n.noticeId5 != notice5.uid {
                    noticeView.isHidden = false
                    noticeAnimation()
                } else {
                    noticeView.isHidden = true
                }
            }
        }
    }
    
    // MARK: - Autofill function
    
    private func isAutofill() {
        
        let date = Date()
        var yyyy_mm_dd: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        
        let realm = try! Realm()
        // 自動入力作成時 & 入出金反映時
        let auto1 = realm.objects(Auto.self).filter("isInput == false").filter("onRegister == false")
        // 自動入力反映後
        let auto2 = realm.objects(Auto.self).filter("isInput == true").filter("onRegister == false")
        /* 入出金一覧から自動入力登録時
           入力作成時の自動入力登録時 */
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
        
        let autoDateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month))
        let add = DateComponents(month: 1, day: -1)
        let comps = calendar.dateComponents([.year, .month,], from: autoDateComp!)
        let firstday = calendar.date(from: comps)
        let lastday = calendar.date(byAdding: add, to: firstday!)
        var firstDayString: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "M月d日"
            return dateFormatter.string(from: firstday!)
        }
        var lastDayString: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "M月d日"
            return dateFormatter.string(from: lastday!)
        }
        var yyyy_mm: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM"
            return dateFormatter.string(from: autoDateComp!)
        }
        var yearMonthTotal: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月合計"
            return dateFormatter.string(from: autoDateComp!)
        }
        
        var dateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month + 1, day: day))
        let nextDateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month + 1, day: 1))
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
                mFoodCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(food)
                }
            } else if auto.category == "日用品" {
                brushData(brush, auto)
                mBrushCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(brush)
                }
            } else if auto.category == "趣味" {
                hobbyData(hobby, auto)
                mHobbyCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(hobby)
                }
            } else if auto.category == "交際費" {
                datingData(dating, auto)
                mDatingCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(dating)
                }
            } else if auto.category == "交通費" {
                trafficData(traffic, auto)
                mTrafficCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(traffic)
                }
            } else if auto.category == "衣服・美容" {
                clotheData(clothe, auto)
                mClotheCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(clothe)
                }
            } else if auto.category == "健康・医療" {
                healthData(health, auto)
                mHealthCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(health)
                }
            } else if auto.category == "自動車" {
                carData(car, auto)
                mCarCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(car)
                }
            } else if auto.category == "教養・教育" {
                educationData(education, auto)
                mEducationCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(education)
                }
            } else if auto.category == "特別な支出" {
                specialData(special, auto)
                mSpecialCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(special)
                }
            } else if auto.category == "現金・カード" {
                cardData(card, auto)
                mCardCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(card)
                }
            } else if auto.category == "水道・光熱費" {
                utilityData(utility, auto)
                mUtilityCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(utility)
                }
            } else if auto.category == "通信費" {
                communicationData(communication, auto)
                mCommunicationCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(communication)
                }
            } else if auto.category == "住宅" {
                houseData(house, auto)
                mHouseCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(house)
                }
            } else if auto.category == "税・社会保険" {
                taxData(tax, auto)
                mTaxCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(tax)
                }
            } else if auto.category == "保険" {
                insranceData(insrance, auto)
                mInsranceCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(insrance)
                }
            } else if auto.category == "その他" {
                etcetoraData(etcetora, auto)
                mEtcetoraCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(etcetora)
                }
            } else if auto.category == "未分類" {
                unCategoryData(unCategory, auto)
                mUnCategoryCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(unCategory)
                }
            }
            
            try! realm.write {
                if auto.autofillDay == "月末" {
                    
                    day = Int(lastDay2String)!
                    dateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month + 1, day: day))
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                } else {
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                }
                auto.month = auto.month + 1
                auto.day = day
                auto.isInput = true
            }
            dateString = spending.month + "月分"
            totalString = "合計\(autoArray4.count)件の自動入力を行いました"
            setCategorySpendingImage(spending: spending, title: dateString, body: totalString)
            
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
                mSalaryCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(salary)
                }
            } else if auto.category == "一時所得" {
                temporaryData(temporary, auto)
                mTemporaryCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(temporary)
                }
            } else if auto.category == "事業・副業" {
                businessData(business, auto)
                mBusinessCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(business)
                }
            } else if auto.category == "年金" {
                pensionData(pension, auto)
                mPensionCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(pension)
                }
            } else if auto.category == "配当所得" {
                devidentData(devident, auto)
                mDevidentCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(devident)
                }
            } else if auto.category == "不動産所得" {
                estateData(estate, auto)
                mEstateCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(estate)
                }
            } else if auto.category == "その他入金" {
                paymentData(payment, auto)
                mPaymentCreate(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(payment)
                }
            } else if auto.category == "未分類" {
                unCategory2Data(unCategory2, auto)
                mUnCategory2Create(auto, yyyy_mm, yearMonthTotal, firstDayString, lastDayString)
                try! realm.write {
                    realm.add(unCategory2)
                }
            }
            
            try! realm.write {
                if auto.autofillDay == "月末" {
                    
                    day = Int(lastDay2String)!
                    dateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month + 1, day: day))
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                } else {
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                }
                auto.month = Int(month)! + 1
                auto.day = day
                auto.isInput = true
            }
            dateString = income.month + "月分"
            totalString = "合計\(autoArray4.count)件の自動入力を行いました"
            setCategoryIncomeImage(income: income, title: dateString, body: totalString)
        }
        tableView.reloadData()
    }
    
    private func prepareUpdate(_ auto: Auto) {
        
        var day = auto.day
        let calendar = Calendar.current
        var dateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month + 1, day: day))
        let nextDateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month + 1, day: 1))
        
        if auto.autofillDay == "月末" {
            
            day = Int(lastDay2String)!
            dateComp = calendar.date(from: DateComponents(year: Int(auto.year), month: auto.month + 1, day: day))
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
        spending.year = String(auto.year)
        spending.month = String(auto.month)
        spending.day = String(auto.day)
        spending.id = auto.id
    }
    
    private func foodData(_ food: Food, _ auto: Auto) {
        
        food.price = auto.price
        food.category = auto.category
        food.memo = auto.memo
        food.timestamp = auto.timestamp
        food.year = String(auto.year)
        food.month = String(auto.month)
        food.day = String(auto.day)
        food.id = auto.id
    }
    
    private func brushData(_ brush: Brush, _ auto: Auto) {
        
        brush.price = auto.price
        brush.category = auto.category
        brush.memo = auto.memo
        brush.timestamp = auto.timestamp
        brush.year = String(auto.year)
        brush.month = String(auto.month)
        brush.day = String(auto.day)
        brush.id = auto.id
    }
    
    private func hobbyData(_ hobby: Hobby, _ auto: Auto) {
        
        hobby.price = auto.price
        hobby.category = auto.category
        hobby.memo = auto.memo
        hobby.timestamp = auto.timestamp
        hobby.year = String(auto.year)
        hobby.month = String(auto.month)
        hobby.day = String(auto.day)
        hobby.id = auto.id
    }
    
    private func datingData(_ dating: Dating, _ auto: Auto) {
        
        dating.price = auto.price
        dating.category = auto.category
        dating.memo = auto.memo
        dating.timestamp = auto.timestamp
        dating.year = String(auto.year)
        dating.month = String(auto.month)
        dating.day = String(auto.day)
        dating.id = auto.id
    }
    
    private func trafficData(_ traffic: Traffic, _ auto: Auto) {
        
        traffic.price = auto.price
        traffic.category = auto.category
        traffic.memo = auto.memo
        traffic.timestamp = auto.timestamp
        traffic.year = String(auto.year)
        traffic.month = String(auto.month)
        traffic.day = String(auto.day)
        traffic.id = auto.id
    }
    
    private func clotheData(_ clothe: Clothe, _ auto: Auto) {
        
        clothe.price = auto.price
        clothe.category = auto.category
        clothe.memo = auto.memo
        clothe.timestamp = auto.timestamp
        clothe.year = String(auto.year)
        clothe.month = String(auto.month)
        clothe.day = String(auto.day)
        clothe.id = auto.id
    }
    
    private func healthData(_ health: Health, _ auto: Auto) {
        
        health.price = auto.price
        health.category = auto.category
        health.memo = auto.memo
        health.timestamp = auto.timestamp
        health.year = String(auto.year)
        health.month = String(auto.month)
        health.day = String(auto.day)
        health.id = auto.id
    }
    
    private func carData(_ car: Car, _ auto: Auto) {
        
        car.price = auto.price
        car.category = auto.category
        car.memo = auto.memo
        car.timestamp = auto.timestamp
        car.year = String(auto.year)
        car.month = String(auto.month)
        car.day = String(auto.day)
        car.id = auto.id
    }
    
    private func educationData(_ education: Education, _ auto: Auto) {
        
        education.price = auto.price
        education.category = auto.category
        education.memo = auto.memo
        education.timestamp = auto.timestamp
        education.year = String(auto.year)
        education.month = String(auto.month)
        education.day = String(auto.day)
        education.id = auto.id
    }
    
    private func specialData(_ special: Special, _ auto: Auto) {
        
        special.price = auto.price
        special.category = auto.category
        special.memo = auto.memo
        special.timestamp = auto.timestamp
        special.year = String(auto.year)
        special.month = String(auto.month)
        special.day = String(auto.day)
        special.id = auto.id
    }
    
    private func cardData(_ card: Card, _ auto: Auto) {
        
        card.price = auto.price
        card.category = auto.category
        card.memo = auto.memo
        card.timestamp = auto.timestamp
        card.year = String(auto.year)
        card.month = String(auto.month)
        card.day = String(auto.day)
        card.id = auto.id
    }
    
    private func utilityData(_ utility: Utility, _ auto: Auto) {
        
        utility.price = auto.price
        utility.category = auto.category
        utility.memo = auto.memo
        utility.timestamp = auto.timestamp
        utility.year = String(auto.year)
        utility.month = String(auto.month)
        utility.day = String(auto.day)
        utility.id = auto.id
    }
    
    private func communicationData(_ communication: Communicaton, _ auto: Auto) {
        
        communication.price = auto.price
        communication.category = auto.category
        communication.memo = auto.memo
        communication.timestamp = auto.timestamp
        communication.year = String(auto.year)
        communication.month = String(auto.month)
        communication.day = String(auto.day)
        communication.id = auto.id
    }
    
    private func houseData(_ house: House, _ auto: Auto) {
        
        house.price = auto.price
        house.category = auto.category
        house.memo = auto.memo
        house.timestamp = auto.timestamp
        house.year = String(auto.year)
        house.month = String(auto.month)
        house.day = String(auto.day)
        house.id = auto.id
    }
    
    private func taxData(_ tax: Tax, _ auto: Auto) {
        
        tax.price = auto.price
        tax.category = auto.category
        tax.memo = auto.memo
        tax.timestamp = auto.timestamp
        tax.year = String(auto.year)
        tax.month = String(auto.month)
        tax.day = String(auto.day)
        tax.id = auto.id
    }
    
    private func insranceData(_ insrance: Insrance, _ auto: Auto) {
        
        insrance.price = auto.price
        insrance.category = auto.category
        insrance.memo = auto.memo
        insrance.timestamp = auto.timestamp
        insrance.year = String(auto.year)
        insrance.month = String(auto.month)
        insrance.day = String(auto.day)
        insrance.id = auto.id
    }
    
    private func etcetoraData(_ etcetora: Etcetora, _ auto: Auto) {
        
        etcetora.price = auto.price
        etcetora.category = auto.category
        etcetora.memo = auto.memo
        etcetora.timestamp = auto.timestamp
        etcetora.year = String(auto.year)
        etcetora.month = String(auto.month)
        etcetora.day = String(auto.day)
        etcetora.id = auto.id
    }
    
    private func unCategoryData(_ unCategory: UnCategory, _ auto: Auto) {
        
        unCategory.price = auto.price
        unCategory.category = auto.category
        unCategory.memo = auto.memo
        unCategory.timestamp = auto.timestamp
        unCategory.year = String(auto.year)
        unCategory.month = String(auto.month)
        unCategory.day = String(auto.day)
        unCategory.id = auto.id
    }
    
    // MARK: - Monthly create
    
    private func mFoodCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mFood = realm.objects(MonthlyFood.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mFood.count == 0 {
            let mFood = MonthlyFood()
            mFood.totalPrice = auto.price
            mFood.category = "食費"
            mFood.timestamp = yearMonthTotal
            mFood.monthly = "(\(firstDayString)~\(lastDayString))"
            mFood.date = yyyy_mm
            mFood.year = String(auto.year)
            mFood.month = String(auto.month)
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
    
    private func mBrushCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mBrush = realm.objects(MonthlyBrush.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mBrush.count == 0 {
            let mBrush = MonthlyBrush()
            mBrush.totalPrice = auto.price
            mBrush.category = "日用品"
            mBrush.timestamp = yearMonthTotal
            mBrush.monthly = "(\(firstDayString)~\(lastDayString))"
            mBrush.date = yyyy_mm
            mBrush.year = String(auto.year)
            mBrush.month = String(auto.month)
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
    
    private func mHobbyCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mHobby = realm.objects(MonthlyHobby.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mHobby.count == 0 {
            let mHobby = MonthlyHobby()
            mHobby.totalPrice = auto.price
            mHobby.category = "趣味"
            mHobby.timestamp = yearMonthTotal
            mHobby.monthly = "(\(firstDayString)~\(lastDayString))"
            mHobby.date = yyyy_mm
            mHobby.year = String(auto.year)
            mHobby.month = String(auto.month)
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
    
    private func mDatingCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mDating = realm.objects(MonthlyDating.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mDating.count == 0 {
            let mDating = MonthlyDating()
            mDating.totalPrice = auto.price
            mDating.category = "交際費"
            mDating.timestamp = yearMonthTotal
            mDating.monthly = "(\(firstDayString)~\(lastDayString))"
            mDating.date = yyyy_mm
            mDating.year = String(auto.year)
            mDating.month = String(auto.month)
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
    
    private func mTrafficCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mTraffic.count == 0 {
            let mTraffic = MonthlyTraffic()
            mTraffic.totalPrice = auto.price
            mTraffic.category = "交通費"
            mTraffic.timestamp = yearMonthTotal
            mTraffic.monthly = "(\(firstDayString)~\(lastDayString))"
            mTraffic.date = yyyy_mm
            mTraffic.year = String(auto.year)
            mTraffic.month = String(auto.month)
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
    
    private func mClotheCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mClothe.count == 0 {
            let mClothe = MonthlyClothe()
            mClothe.totalPrice = auto.price
            mClothe.category = "衣服・美容"
            mClothe.timestamp = yearMonthTotal
            mClothe.monthly = "(\(firstDayString)~\(lastDayString))"
            mClothe.date = yyyy_mm
            mClothe.year = String(auto.year)
            mClothe.month = String(auto.month)
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
    
    private func mHealthCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mHealth = realm.objects(MonthlyHealth.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mHealth.count == 0 {
            let mHealth = MonthlyHealth()
            mHealth.totalPrice = auto.price
            mHealth.category = "健康・医療"
            mHealth.timestamp = yearMonthTotal
            mHealth.monthly = "(\(firstDayString)~\(lastDayString))"
            mHealth.date = yyyy_mm
            mHealth.year = String(auto.year)
            mHealth.month = String(auto.month)
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
    
    private func mCarCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mCar = realm.objects(MonthlyCar.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mCar.count == 0 {
            let mCar = MonthlyCar()
            mCar.totalPrice = auto.price
            mCar.category = "自動車"
            mCar.timestamp = yearMonthTotal
            mCar.monthly = "(\(firstDayString)~\(lastDayString))"
            mCar.date = yyyy_mm
            mCar.year = String(auto.year)
            mCar.month = String(auto.month)
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
    
    private func mEducationCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mEducation.count == 0 {
            let mEducation = MonthlyEducation()
            mEducation.totalPrice = auto.price
            mEducation.category = "教養・教育"
            mEducation.timestamp = yearMonthTotal
            mEducation.monthly = "(\(firstDayString)~\(lastDayString))"
            mEducation.date = yyyy_mm
            mEducation.year = String(auto.year)
            mEducation.month = String(auto.month)
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
    
    private func mSpecialCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mSpecial.count == 0 {
            let mSpecial = MonthlySpecial()
            mSpecial.totalPrice = auto.price
            mSpecial.category = "特別な支出"
            mSpecial.timestamp = yearMonthTotal
            mSpecial.monthly = "(\(firstDayString)~\(lastDayString))"
            mSpecial.date = yyyy_mm
            mSpecial.year = String(auto.year)
            mSpecial.month = String(auto.month)
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
    
    private func mUtilityCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mUtility.count == 0 {
            let mUtility = MonthlyUtility()
            mUtility.totalPrice = auto.price
            mUtility.category = "水道・光熱費"
            mUtility.timestamp = yearMonthTotal
            mUtility.monthly = "(\(firstDayString)~\(lastDayString))"
            mUtility.date = yyyy_mm
            mUtility.year = String(auto.year)
            mUtility.month = String(auto.month)
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
    
    private func mCommunicationCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mCommunication.count == 0 {
            let mCommunication = MonthlyCommunication()
            mCommunication.totalPrice = auto.price
            mCommunication.category = "通信費"
            mCommunication.timestamp = yearMonthTotal
            mCommunication.monthly = "(\(firstDayString)~\(lastDayString))"
            mCommunication.date = yyyy_mm
            mCommunication.year = String(auto.year)
            mCommunication.month = String(auto.month)
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
    
    private func mHouseCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mHouse.count == 0 {
            let mHouse = MonthlyHouse()
            mHouse.totalPrice = auto.price
            mHouse.category = "住宅"
            mHouse.timestamp = yearMonthTotal
            mHouse.monthly = "(\(firstDayString)~\(lastDayString))"
            mHouse.date = yyyy_mm
            mHouse.year = String(auto.year)
            mHouse.month = String(auto.month)
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
    
    private func mCardCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mCard = realm.objects(MonthlyCard.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mCard.count == 0 {
            let mCard = MonthlyCard()
            mCard.totalPrice = auto.price
            mCard.category = "現金・カード"
            mCard.timestamp = yearMonthTotal
            mCard.monthly = "(\(firstDayString)~\(lastDayString))"
            mCard.date = yyyy_mm
            mCard.year = String(auto.year)
            mCard.month = String(auto.month)
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
    
    private func mTaxCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mTax = realm.objects(MonthlyTax.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mTax.count == 0 {
            let mTax = MonthlyTax()
            mTax.totalPrice = auto.price
            mTax.category = "税・社会保険"
            mTax.timestamp = yearMonthTotal
            mTax.monthly = "(\(firstDayString)~\(lastDayString))"
            mTax.date = yyyy_mm
            mTax.year = String(auto.year)
            mTax.month = String(auto.month)
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
    
    private func mInsranceCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mInsrance.count == 0 {
            let mInsrance = MonthlyInsrance()
            mInsrance.totalPrice = auto.price
            mInsrance.category = "保険"
            mInsrance.timestamp = yearMonthTotal
            mInsrance.monthly = "(\(firstDayString)~\(lastDayString))"
            mInsrance.date = yyyy_mm
            mInsrance.year = String(auto.year)
            mInsrance.month = String(auto.month)
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
    
    private func mEtcetoraCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mEtcetora.count == 0 {
            let mEtcetora = MonthlyEtcetora()
            mEtcetora.totalPrice = auto.price
            mEtcetora.category = "その他"
            mEtcetora.timestamp = yearMonthTotal
            mEtcetora.monthly = "(\(firstDayString)~\(lastDayString))"
            mEtcetora.date = yyyy_mm
            mEtcetora.year = String(auto.year)
            mEtcetora.month = String(auto.month)
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
    
    private func mUnCategoryCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mUnCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mUnCategory.count == 0 {
            let mUnCategory = MonthlyUnCategory()
            mUnCategory.totalPrice = auto.price
            mUnCategory.category = "未分類"
            mUnCategory.timestamp = yearMonthTotal
            mUnCategory.monthly = "(\(firstDayString)~\(lastDayString))"
            mUnCategory.date = yyyy_mm
            mUnCategory.year = String(auto.year)
            mUnCategory.month = String(auto.month)
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
    
    private func mSalaryCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mSalary = realm.objects(MonthlySalary.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mSalary.count == 0 {
            let mSalary = MonthlySalary()
            mSalary.totalPrice = auto.price
            mSalary.category = "給与"
            mSalary.timestamp = yearMonthTotal
            mSalary.monthly = "(\(firstDayString)~\(lastDayString))"
            mSalary.date = yyyy_mm
            mSalary.year = String(auto.year)
            mSalary.month = String(auto.month)
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
    
    private func mTemporaryCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mTemporary.count == 0 {
            let mTemporary = MonthlyTemporary()
            mTemporary.totalPrice = auto.price
            mTemporary.category = "一時所得"
            mTemporary.timestamp = yearMonthTotal
            mTemporary.monthly = "(\(firstDayString)~\(lastDayString))"
            mTemporary.date = yyyy_mm
            mTemporary.year = String(auto.year)
            mTemporary.month = String(auto.month)
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
    
    private func mBusinessCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mBusiness.count == 0 {
            let mBusiness = MonthlyBusiness()
            mBusiness.totalPrice = auto.price
            mBusiness.category = "事業・副業"
            mBusiness.timestamp = yearMonthTotal
            mBusiness.monthly = "(\(firstDayString)~\(lastDayString))"
            mBusiness.date = yyyy_mm
            mBusiness.year = String(auto.year)
            mBusiness.month = String(auto.month)
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
    
    private func mPensionCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mPension = realm.objects(MonthlyPension.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mPension.count == 0 {
            let mPension = MonthlyPension()
            mPension.totalPrice = auto.price
            mPension.category = "年金"
            mPension.timestamp = yearMonthTotal
            mPension.monthly = "(\(firstDayString)~\(lastDayString))"
            mPension.date = yyyy_mm
            mPension.year = String(auto.year)
            mPension.month = String(auto.month)
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
    
    private func mDevidentCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mDevident = realm.objects(MonthlyDevident.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mDevident.count == 0 {
            let mDevident = MonthlyDevident()
            mDevident.totalPrice = auto.price
            mDevident.category = "配当所得"
            mDevident.timestamp = yearMonthTotal
            mDevident.monthly = "(\(firstDayString)~\(lastDayString))"
            mDevident.date = yyyy_mm
            mDevident.year = String(auto.year)
            mDevident.month = String(auto.month)
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
    
    private func mEstateCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mEstate = realm.objects(MonthlyEstate.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mEstate.count == 0 {
            let mEstate = MonthlyEstate()
            mEstate.totalPrice = auto.price
            mEstate.category = "不動産所得"
            mEstate.timestamp = yearMonthTotal
            mEstate.monthly = "(\(firstDayString)~\(lastDayString))"
            mEstate.date = yyyy_mm
            mEstate.year = String(auto.year)
            mEstate.month = String(auto.month)
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
    
    private func mPaymentCreate(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mPayment = realm.objects(MonthlyPayment.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mPayment.count == 0 {
            let mPayment = MonthlyPayment()
            mPayment.totalPrice = auto.price
            mPayment.category = "その他入金"
            mPayment.timestamp = yearMonthTotal
            mPayment.monthly = "(\(firstDayString)~\(lastDayString))"
            mPayment.date = yyyy_mm
            mPayment.year = String(auto.year)
            mPayment.month = String(auto.month)
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
    
    private func mUnCategory2Create(_ auto: Auto, _ yyyy_mm: String, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let mUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(auto.year)'").filter("month == '\(auto.month)'")
        
        if mUnCategory2.count == 0 {
            let mUnCategory2 = MonthlyUnCategory2()
            mUnCategory2.totalPrice = auto.price
            mUnCategory2.category = "未分類"
            mUnCategory2.timestamp = yearMonthTotal
            mUnCategory2.monthly = "(\(firstDayString)~\(lastDayString))"
            mUnCategory2.date = yyyy_mm
            mUnCategory2.year = String(auto.year)
            mUnCategory2.month = String(auto.month)
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
        income.year = String(auto.year)
        income.month = String(auto.month)
        income.day = String(auto.day)
        income.id = auto.id
    }
    
    private func salaryData(_ salary: Salary, _ auto: Auto) {
        
        salary.price = auto.price
        salary.category = auto.category
        salary.memo = auto.memo
        salary.timestamp = auto.timestamp
        salary.year = String(auto.year)
        salary.month = String(auto.month)
        salary.day = String(auto.day)
        salary.id = auto.id
    }
    
    private func temporaryData(_ temporary: Temporary, _ auto: Auto) {
        
        temporary.price = auto.price
        temporary.category = auto.category
        temporary.memo = auto.memo
        temporary.timestamp = auto.timestamp
        temporary.year = String(auto.year)
        temporary.month = String(auto.month)
        temporary.day = String(auto.day)
        temporary.id = auto.id
    }
    
    private func businessData(_ business: Business, _ auto: Auto) {
        
        business.price = auto.price
        business.category = auto.category
        business.memo = auto.memo
        business.timestamp = auto.timestamp
        business.year = String(auto.year)
        business.month = String(auto.month)
        business.day = String(auto.day)
        business.id = auto.id
    }
    
    private func pensionData(_ pension: Pension, _ auto: Auto) {
        
        pension.price = auto.price
        pension.category = auto.category
        pension.memo = auto.memo
        pension.timestamp = auto.timestamp
        pension.year = String(auto.year)
        pension.month = String(auto.month)
        pension.day = String(auto.day)
        pension.id = auto.id
    }
    
    private func devidentData(_ devident: Devident, _ auto: Auto) {
        
        devident.price = auto.price
        devident.category = auto.category
        devident.memo = auto.memo
        devident.timestamp = auto.timestamp
        devident.year = String(auto.year)
        devident.month = String(auto.month)
        devident.day = String(auto.day)
        devident.id = auto.id
    }
    
    private func estateData(_ estate: Estate, _ auto: Auto) {
        
        estate.price = auto.price
        estate.category = auto.category
        estate.memo = auto.memo
        estate.timestamp = auto.timestamp
        estate.year = String(auto.year)
        estate.month = String(auto.month)
        estate.day = String(auto.day)
        estate.id = auto.id
    }
    
    private func paymentData(_ payment: Payment, _ auto: Auto) {
        
        payment.price = auto.price
        payment.category = auto.category
        payment.memo = auto.memo
        payment.timestamp = auto.timestamp
        payment.year = String(auto.year)
        payment.month = String(auto.month)
        payment.day = String(auto.day)
        payment.id = auto.id
    }
    
    private func unCategory2Data(_ unCategory2: UnCategory2, _ auto: Auto) {
        
        unCategory2.price = auto.price
        unCategory2.category = auto.category
        unCategory2.memo = auto.memo
        unCategory2.timestamp = auto.timestamp
        unCategory2.year = String(auto.year)
        unCategory2.month = String(auto.month)
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
        let year = auto.year
        
        try! realm.write {
            auto.timestamp = timestamp
            auto.date = date
            auto.year = year
            auto.month = auto.month + 1
            auto.day = day
            auto.nextMonth = nextMonth
            auto.onRegister = false
        }
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func checkRegister() {
        
        let realm = try! Realm()
        let money = realm.objects(Money.self)
        if money.count == 1 {
            registerHeight.constant = 0
        } else {
            registerHeight.constant = 44
        }
    }
    
    private func noticeAnimation() {
        
        let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rollingAnimation.fromValue = 0
        rollingAnimation.toValue = CGFloat.pi * 0.1
        rollingAnimation.duration = 0.1
        rollingAnimation.repeatDuration = CFTimeInterval.zero
        noticeButton.layer.add(rollingAnimation, forKey: "rollingImage")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rollingAnimation.fromValue = 0
            rollingAnimation.toValue = CGFloat.pi * -0.1
            rollingAnimation.duration = 0.1
            rollingAnimation.repeatDuration = CFTimeInterval.zero
            noticeButton.layer.add(rollingAnimation, forKey: "rollingImage")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rollingAnimation.fromValue = 0
                rollingAnimation.toValue = CGFloat.pi * 0.1
                rollingAnimation.duration = 0.1
                rollingAnimation.repeatDuration = CFTimeInterval.zero
                noticeButton.layer.add(rollingAnimation, forKey: "rollingImage")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                    let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    rollingAnimation.fromValue = 0
                    rollingAnimation.toValue = CGFloat.pi * -0.1
                    rollingAnimation.duration = 0.1
                    rollingAnimation.repeatDuration = CFTimeInterval.zero
                    noticeButton.layer.add(rollingAnimation, forKey: "rollingImage")
                }
            }
        }
    }
    
    private func setup() {
        navigationItem.title = "ホーム"
        tableView.tableFooterView = UIView()
        hintView.alpha = 0
        hintView.layer.cornerRadius = 10
        noticeView.layer.cornerRadius = 5
        noticeView.isHidden = true
        closeButton.layer.cornerRadius = 30 / 2
        descriptionLabel.text = "操作が分からなくなった場合や、他のことも知りたい場合は、ホーム画面右上の歯車マークから'使い方'をタップで確認できます。"
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        switch UIScreen.main.nativeBounds.height {
        case 1334:
            topViewHeight.constant = 63
        case 2208:
            topViewHeight.constant = 63
        default:
            break
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
    
    private func setCategorySpendingImage(spending: Spending, title: String, body: String) {
        if spending.category == "未分類" {
            categoryImage = UIImage(systemName: "questionmark.circle")!
        } else if spending.category == "食費" {
            categoryImage = UIImage(named: "food")!
        } else if spending.category == "日用品" {
            categoryImage = UIImage(named: "brush")!
        } else if spending.category == "趣味" {
            categoryImage = UIImage(named: "hobby")!
        } else if spending.category == "交際費" {
            categoryImage = UIImage(named: "dating")!
        } else if spending.category == "交通費" {
            categoryImage = UIImage(named: "traffic")!
        } else if spending.category == "衣服・美容" {
            categoryImage = UIImage(named: "clothe")!
        } else if spending.category == "健康・医療" {
            categoryImage = UIImage(named: "health")!
        } else if spending.category == "自動車" {
            categoryImage = UIImage(named: "car")!
        } else if spending.category == "教養・教育" {
            categoryImage = UIImage(named: "education")!
        } else if spending.category == "特別な支出" {
            categoryImage = UIImage(named: "special")!
        } else if spending.category == "現金・カード" {
            categoryImage = UIImage(named: "card")!
        } else if spending.category == "水道・光熱費" {
            categoryImage = UIImage(named: "utility")!
        } else if spending.category == "通信費" {
            categoryImage = UIImage(named: "communication")!
        } else if spending.category == "住宅" {
            categoryImage = UIImage(named: "house")!
        } else if spending.category == "税・社会保険" {
            categoryImage = UIImage(named: "tax")!
        } else if spending.category == "保険" {
            categoryImage = UIImage(named: "insrance")!
        } else if spending.category == "その他" {
            categoryImage = UIImage(named: "etcetra")!
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            player.play()
            NotificationBanner.show(title: title, body: body, image: categoryImage)
            tableView.reloadData()
        }
    }
    
    private func setCategoryIncomeImage(income: Income, title: String, body: String) {
        
        if income.category == "未分類" {
            categoryImage = UIImage(systemName: "questionmark.circle")!
        } else if income.category == "給与" {
            categoryImage = UIImage(named: "en_mark")!
        } else if income.category == "一時所得" {
            categoryImage = UIImage(named: "en_mark")!
        } else if income.category == "事業・副業" {
            categoryImage = UIImage(named: "en_mark")!
        } else if income.category == "年金" {
            categoryImage = UIImage(named: "en_mark")!
        } else if income.category == "配当所得" {
            categoryImage = UIImage(named: "en_mark")!
        } else if income.category == "不動産所得" {
            categoryImage = UIImage(named: "en_mark")!
        } else if income.category == "その他入金" {
            categoryImage = UIImage(named: "en_mark")!
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            player.play()
            NotificationBanner.show(title: title, body: body, image: categoryImage)
            tableView.reloadData()
        }
    }
}

// MARK: - Table view

extension HomeViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TotalMoneyTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! BalanceTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3") as! LineChartTableViewCell
        
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

extension HomeViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    checkRegister()
    checkNotice1()
    isAutofill()
    tableView.reloadData()
  }
}
