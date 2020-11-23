//
//  DetailTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/15.
//

import UIKit
import RealmSwift

class DetailTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var foodArray = [Food]()
    private var brushArray = [Brush]()
    private var hobbyArray = [Hobby]()
    private var datingArray = [Dating]()
    private var trafficArray = [Traffic]()
    private var clotheArray = [Clothe]()
    private var healthArray = [Health]()
    private var carArray = [Car]()
    private var educationArray = [Education]()
    private var specialArray = [Special]()
    private var cardArray = [Card]()
    private var utilityArray = [Utility]()
    private var communicationArray = [Communicaton]()
    private var houseArray = [House]()
    private var taxArray = [Tax]()
    private var insranceArray = [Insrance]()
    private var etcetoraArray = [Etcetora]()
    private var unCategoryArray = [UnCategory]()
    private var salaryArray = [Salary]()
    private var temporaryArray = [Temporary]()
    private var businessArray = [Business]()
    private var pensionArray = [Pension]()
    private var devidentArray = [Devident]()
    private var estateArray = [Estate]()
    private var paymentArray = [Payment]()
    private var unCategory2Array = [UnCategory2]()
    private var categoryArray = [String]()

    var category = ""
    var year = ""
    var month = ""
    private var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        if UserDefaults.standard.object(forKey: CATEGORY) != nil {
            let year = UserDefaults.standard.object(forKey: YEAR) as! String
            let month = UserDefaults.standard.object(forKey: MONTHE) as! String
            let category = UserDefaults.standard.object(forKey: CATEGORY) as! String
            
            if UserDefaults.standard.object(forKey: CHANGE) == nil {
                if category == "食費" {
                    fetchFood(year, month)
                } else if category == "日用品" {
                    fetchBrush(year, month)
                } else if category == "趣味" {
                    fetchHobby(year, month)
                } else if category == "交際費" {
                    fetchDating(year, month)
                } else if category == "交通費" {
                    fetchTraffic(year, month)
                } else if category == "衣服・美容" {
                    fetchClothe(year, month)
                } else if category == "健康・医療" {
                    fetchHealth(year, month)
                } else if category == "自動車" {
                    fetchCar(year, month)
                } else if category == "教養・教育" {
                    fetchEducation(year, month)
                } else if category == "特別な支出" {
                    fetchSpecial(year, month)
                } else if category == "現金・カード" {
                    fetchCard(year, month)
                } else if category == "水道・光熱費" {
                    fetchUtility(year, month)
                } else if category == "通信費" {
                    fetchCommunicaton(year, month)
                } else if category == "住宅" {
                    fetchHouse(year, month)
                } else if category == "税・社会保険" {
                    fetchTax(year, month)
                } else if category == "保険" {
                    fetchInsrance(year, month)
                } else if category == "その他" {
                    fetchEtcetora(year, month)
                } else if category == "未分類" {
                    fetchUnCategory(year, month)
                }
            } else {
                if category == "給与" {
                    fetchSalary(year, month)
                } else if category == "一時所得" {
                    fetchTemporary(year, month)
                } else if category == "事業・副業" {
                    fetchBusiness(year, month)
                } else if category == "年金" {
                    fetchPension(year, month)
                } else if category == "配当所得" {
                    fetchDevident(year, month)
                } else if category == "不動産所得" {
                    fetchEstate(year, month)
                } else if category == "その他入金" {
                    fetchPayment(year, month)
                } else if category == "未分類" {
                    fetchUnCategory2(year, month)
                }
            }
            
        } else {
            selectCategory()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchFood(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let food = realm.objects(Food.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mFood = realm.objects(MonthlyFood.self).filter("year == '\(year)'").filter("month == '\(month)'")
        foodArray.removeAll()
        foodArray.append(contentsOf: food)
        foodArray = foodArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if foodArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        foodArray.forEach { (food) in
            navigationItem.title = food.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color1")
        }
        mFood.forEach { (mfood) in
            categoryArray.append(mfood.category)
        }
        removeObject()
    }
    
    private func fetchBrush(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let brush = realm.objects(Brush.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mbrush = realm.objects(MonthlyBrush.self).filter("year == '\(year)'").filter("month == '\(month)'")
        brushArray.removeAll()
        brushArray.append(contentsOf: brush)
        brushArray = brushArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if brushArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        brushArray.forEach { (brush) in
            navigationItem.title = brush.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color2")
        }
        mbrush.forEach { (mbrush) in
            categoryArray.append(mbrush.category)
        }
        removeObject()
    }
    
    private func fetchHobby(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let hobby = realm.objects(Hobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mhobby = realm.objects(MonthlyHobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
        hobbyArray.removeAll()
        hobbyArray.append(contentsOf: hobby)
        hobbyArray = hobbyArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if hobbyArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        hobbyArray.forEach { (hobby) in
            navigationItem.title = hobby.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color3")
        }
        mhobby.forEach { (mhobby) in
            categoryArray.append(mhobby.category)
        }
        removeObject()
    }
    
    private func fetchDating(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let dating = realm.objects(Dating.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mDating = realm.objects(MonthlyDating.self).filter("year == '\(year)'").filter("month == '\(month)'")
        datingArray.removeAll()
        datingArray.append(contentsOf: dating)
        datingArray = datingArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if datingArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        datingArray.forEach { (dating) in
            navigationItem.title = dating.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color4")
        }
        mDating.forEach { (mDating) in
            categoryArray.append(mDating.category)
        }
        removeObject()
    }
    
    private func fetchTraffic(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let traffic = realm.objects(Traffic.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(year)'").filter("month == '\(month)'")

        trafficArray.removeAll()
        trafficArray.append(contentsOf: traffic)
        trafficArray = trafficArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if trafficArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        trafficArray.forEach { (traffic) in
            navigationItem.title = traffic.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color5")
        }
        mTraffic.forEach { (mTraffic) in
            categoryArray.append(mTraffic.category)
        }
        removeObject()
    }
    
    private func fetchClothe(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let clothe = realm.objects(Clothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        clotheArray.removeAll()
        clotheArray.append(contentsOf: clothe)
        clotheArray = clotheArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if clotheArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        clotheArray.forEach { (clothe) in
            navigationItem.title = clothe.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color6")
        }
        mClothe.forEach { (mClothe) in
            categoryArray.append(mClothe.category)
        }
        removeObject()
    }
    
    private func fetchHealth(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let health = realm.objects(Health.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mHealth = realm.objects(MonthlyHealth.self).filter("year == '\(year)'").filter("month == '\(month)'")

        healthArray.removeAll()
        healthArray.append(contentsOf: health)
        healthArray = healthArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if healthArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        healthArray.forEach { (health) in
            navigationItem.title = health.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color7")
        }
        mHealth.forEach { (mHealth) in
            categoryArray.append(mHealth.category)
        }
        removeObject()
    }
    
    private func fetchCar(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let car = realm.objects(Car.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mCar = realm.objects(MonthlyCar.self).filter("year == '\(year)'").filter("month == '\(month)'")

        carArray.removeAll()
        carArray.append(contentsOf: car)
        carArray = carArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if carArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        carArray.forEach { (car) in
            navigationItem.title = car.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color8")
        }
        mCar.forEach { (mCar) in
            categoryArray.append(mCar.category)
        }
        removeObject()
    }
    
    private func fetchEducation(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let education = realm.objects(Education.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(year)'").filter("month == '\(month)'")

        educationArray.removeAll()
        educationArray.append(contentsOf: education)
        educationArray = educationArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if educationArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        educationArray.forEach { (education) in
            navigationItem.title = education.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color9")
        }
        mEducation.forEach { (mEducation) in
            categoryArray.append(mEducation.category)
        }
        removeObject()
    }
    
    private func fetchSpecial(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let special = realm.objects(Special.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(year)'").filter("month == '\(month)'")

        specialArray.removeAll()
        specialArray.append(contentsOf: special)
        specialArray = specialArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if specialArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        specialArray.forEach { (special) in
            navigationItem.title = special.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color10")
        }
        mSpecial.forEach { (mSpecial) in
            categoryArray.append(mSpecial.category)
        }
        removeObject()
    }
    
    private func fetchCard(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let card = realm.objects(Card.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mCard = realm.objects(MonthlyCard.self).filter("year == '\(year)'").filter("month == '\(month)'")

        cardArray.removeAll()
        cardArray.append(contentsOf: card)
        cardArray = cardArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if cardArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        cardArray.forEach { (card) in
            navigationItem.title = card.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color24")
        }
        mCard.forEach { (mCard) in
            categoryArray.append(mCard.category)
        }
        removeObject()
    }
    
    private func fetchUtility(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let utility = realm.objects(Utility.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(year)'").filter("month == '\(month)'")

        utilityArray.removeAll()
        utilityArray.append(contentsOf: utility)
        utilityArray = utilityArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if utilityArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        utilityArray.forEach { (utility) in
            navigationItem.title = utility.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color11")
        }
        mUtility.forEach { (mUtility) in
            categoryArray.append(mUtility.category)
        }
        removeObject()
    }
    
    private func fetchCommunicaton(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let communication = realm.objects(Communicaton.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(year)'").filter("month == '\(month)'")

        communicationArray.removeAll()
        communicationArray.append(contentsOf: communication)
        communicationArray = communicationArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if communicationArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        communicationArray.forEach { (communication) in
            navigationItem.title = communication.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color12")
        }
        mCommunication.forEach { (mCommunication) in
            categoryArray.append(mCommunication.category)
        }
        removeObject()
    }
    
    private func fetchHouse(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let house = realm.objects(House.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(year)'").filter("month == '\(month)'")

        houseArray.removeAll()
        houseArray.append(contentsOf: house)
        houseArray = houseArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if houseArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        houseArray.forEach { (house) in
            navigationItem.title = house.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color13")
        }
        mHouse.forEach { (mHouse) in
            categoryArray.append(mHouse.category)
        }
        removeObject()
    }
    
    private func fetchTax(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let tax = realm.objects(Tax.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mTax = realm.objects(MonthlyTax.self).filter("year == '\(year)'").filter("month == '\(month)'")

        taxArray.removeAll()
        taxArray.append(contentsOf: tax)
        taxArray = taxArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if taxArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        taxArray.forEach { (tax) in
            navigationItem.title = tax.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color14")
        }
        mTax.forEach { (mTax) in
            categoryArray.append(mTax.category)
        }
        removeObject()
    }
    
    private func fetchInsrance(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let insrance = realm.objects(Insrance.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(year)'").filter("month == '\(month)'")

        insranceArray.removeAll()
        insranceArray.append(contentsOf: insrance)
        insranceArray = insranceArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if insranceArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        insranceArray.forEach { (insrance) in
            navigationItem.title = insrance.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color15")
        }
        mInsrance.forEach { (mInsrance) in
            categoryArray.append(mInsrance.category)
        }
        removeObject()
    }
    
    private func fetchEtcetora(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let etcetora = realm.objects(Etcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")

        etcetoraArray.removeAll()
        etcetoraArray.append(contentsOf: etcetora)
        etcetoraArray = etcetoraArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if etcetoraArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        etcetoraArray.forEach { (etcetora) in
            navigationItem.title = etcetora.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color16")
        }
        mEtcetora.forEach { (mEtcetora) in
            categoryArray.append(mEtcetora.category)
        }
        removeObject()
    }
    
    private func fetchUnCategory(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let unCategory = realm.objects(UnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mUncategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")

        unCategoryArray.removeAll()
        unCategoryArray.append(contentsOf: unCategory)
        unCategoryArray = unCategoryArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if unCategoryArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        unCategoryArray.forEach { (unCategory) in
            navigationItem.title = unCategory.category
            navigationController?.navigationBar.barTintColor = .systemGray
        }
        mUncategory.forEach { (mUncategory) in
            categoryArray.append(mUncategory.category)
        }
        removeObject()
    }
    
    private func fetchSalary(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let salary = realm.objects(Salary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mSalary = realm.objects(MonthlySalary.self).filter("year == '\(year)'").filter("month == '\(month)'")

        salaryArray.removeAll()
        salaryArray.append(contentsOf: salary)
        salaryArray = salaryArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if salaryArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        salaryArray.forEach { (salary) in
            navigationItem.title = salary.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color17")
        }
        mSalary.forEach { (mSalary) in
            categoryArray.append(mSalary.category)
        }
        removeObject()
    }
    
    private func fetchTemporary(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let temporary = realm.objects(Temporary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(year)'").filter("month == '\(month)'")

        temporaryArray.removeAll()
        temporaryArray.append(contentsOf: temporary)
        temporaryArray = temporaryArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if temporaryArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        temporaryArray.forEach { (temporary) in
            navigationItem.title = temporary.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color18")
        }
        mTemporary.forEach { (mTemporary) in
            categoryArray.append(mTemporary.category)
        }
        removeObject()
    }
    
    private func fetchBusiness(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let business = realm.objects(Business.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(year)'").filter("month == '\(month)'")

        businessArray.removeAll()
        businessArray.append(contentsOf: business)
        businessArray = businessArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if businessArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        businessArray.forEach { (business) in
            navigationItem.title = business.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color19")
        }
        mBusiness.forEach { (mBusiness) in
            categoryArray.append(mBusiness.category)
        }
        removeObject()
    }
    
    private func fetchPension(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let pension = realm.objects(Pension.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mPension = realm.objects(MonthlyPension.self).filter("year == '\(year)'").filter("month == '\(month)'")

        pensionArray.removeAll()
        pensionArray.append(contentsOf: pension)
        pensionArray = pensionArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if pensionArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        pensionArray.forEach { (pension) in
            navigationItem.title = pension.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color20")
        }
        mPension.forEach { (mPension) in
            categoryArray.append(mPension.category)
        }
        removeObject()
    }
    
    private func fetchDevident(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let devident = realm.objects(Devident.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mDevident = realm.objects(MonthlyDevident.self).filter("year == '\(year)'").filter("month == '\(month)'")

        devidentArray.removeAll()
        devidentArray.append(contentsOf: devident)
        devidentArray = devidentArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if devidentArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        devidentArray.forEach { (devident) in
            navigationItem.title = devident.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color21")
        }
        mDevident.forEach { (mDevident) in
            categoryArray.append(mDevident.category)
        }
        removeObject()
    }
    
    private func fetchEstate(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let estate = realm.objects(Estate.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mEstate = realm.objects(MonthlyEstate.self).filter("year == '\(year)'").filter("month == '\(month)'")

        estateArray.removeAll()
        estateArray.append(contentsOf: estate)
        estateArray = estateArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if estateArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        estateArray.forEach { (estate) in
            navigationItem.title = estate.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color22")
        }
        mEstate.forEach { (mEstate) in
            categoryArray.append(mEstate.category)
        }
        removeObject()
    }
    
    private func fetchPayment(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let payment = realm.objects(Payment.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mPayment = realm.objects(MonthlyPayment.self).filter("year == '\(year)'").filter("month == '\(month)'")

        paymentArray.removeAll()
        paymentArray.append(contentsOf: payment)
        paymentArray = paymentArray.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if paymentArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        paymentArray.forEach { (payment) in
            navigationItem.title = payment.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color23")
        }
        mPayment.forEach { (mPayment) in
            categoryArray.append(mPayment.category)
        }
        removeObject()
    }
    
    private func fetchUnCategory2(_ year: String, _ month: String) {
        
        let realm = try! Realm()
        let unCategory2 = realm.objects(UnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")

        unCategory2Array.removeAll()
        unCategory2Array.append(contentsOf: unCategory2)
        unCategory2Array = unCategory2Array.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        })
        if unCategory2Array.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        unCategory2Array.forEach { (unCategory2) in
            navigationItem.title = unCategory2.category
            navigationController?.navigationBar.barTintColor = .systemGray
        }
        mUnCategory2.forEach { (mUnCategory2) in
            categoryArray.append(mUnCategory2.category)
        }
        removeObject()
    }
    
    // MARK: - Helpers
    
    private func selectCategory() {
        
        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            if category == "食費" {
                fetchFood(year, month)
            } else if category == "日用品" {
                fetchBrush(year, month)
            } else if category == "趣味" {
                fetchHobby(year, month)
            } else if category == "交際費" {
                fetchDating(year, month)
            } else if category == "交通費" {
                fetchTraffic(year, month)
            } else if category == "衣服・美容" {
                fetchClothe(year, month)
            } else if category == "健康・医療" {
                fetchHealth(year, month)
            } else if category == "自動車" {
                fetchCar(year, month)
            } else if category == "教養・教育" {
                fetchEducation(year, month)
            } else if category == "特別な支出" {
                fetchSpecial(year, month)
            } else if category == "現金・カード" {
                fetchCard(year, month)
            } else if category == "水道・光熱費" {
                fetchUtility(year, month)
            } else if category == "通信費" {
                fetchCommunicaton(year, month)
            } else if category == "住宅" {
                fetchHouse(year, month)
            } else if category == "税・社会保険" {
                fetchTax(year, month)
            } else if category == "保険" {
                fetchInsrance(year, month)
            } else if category == "その他" {
                fetchEtcetora(year, month)
            } else if category == "未分類" {
                fetchUnCategory(year, month)
            }
        } else {
            if category == "給与" {
                fetchSalary(year, month)
            } else if category == "一時所得" {
                fetchTemporary(year, month)
            } else if category == "事業・副業" {
                fetchBusiness(year, month)
            } else if category == "年金" {
                fetchPension(year, month)
            } else if category == "配当所得" {
                fetchDevident(year, month)
            } else if category == "不動産所得" {
                fetchEstate(year, month)
            } else if category == "その他入金" {
                fetchPayment(year, month)
            } else if category == "未分類" {
                fetchUnCategory2(year, month)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditSpendingVC" {
            let editSpendingVC = segue.destination as! EditSpendingViewController
            editSpendingVC.id = id
        }
        
        if segue.identifier == "EditIncomeVC" {
            let editIncomeVC = segue.destination as! EditIncomeViewController
            editIncomeVC.id = id
        }
    }
    
    private func removeObject() {
        UserDefaults.standard.removeObject(forKey: CATEGORY)
        UserDefaults.standard.removeObject(forKey: YEAR)
        UserDefaults.standard.removeObject(forKey: MONTHE)
    }
}

// MARK: - Table view

extension DetailTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            if category == "食費" {
                return 1 + foodArray.count
            } else if category == "日用品" {
                return 1 + brushArray.count
            } else if category == "趣味" {
                return 1 + hobbyArray.count
            } else if category == "交際費" {
                return 1 + datingArray.count
            } else if category == "交通費" {
                return 1 + trafficArray.count
            } else if category == "衣服・美容" {
                return 1 + clotheArray.count
            } else if category == "健康・医療" {
                return 1 + healthArray.count
            } else if category == "自動車" {
                return 1 + carArray.count
            } else if category == "教養・教育" {
                return 1 + educationArray.count
            } else if category == "特別な支出" {
                return 1 + specialArray.count
            } else if category == "現金・カード" {
                return 1 + cardArray.count
            } else if category == "水道・光熱費" {
                return 1 + utilityArray.count
            } else if category == "通信費" {
                return 1 + communicationArray.count
            } else if category == "住宅" {
                return 1 + houseArray.count
            } else if category == "税・社会保険" {
                return 1 + taxArray.count
            } else if category == "保険" {
                return 1 + insranceArray.count
            } else if category == "その他" {
                return 1 + etcetoraArray.count
            } else if category == "未分類" {
                return 1 + unCategoryArray.count
            }
        }
        if category == "給与" {
            return 1 + salaryArray.count
        } else if category == "一時所得" {
            return 1 + temporaryArray.count
        } else if category == "事業・副業" {
            return 1 + businessArray.count
        } else if category == "年金" {
            return 1 + pensionArray.count
        } else if category == "配当所得" {
            return 1 + devidentArray.count
        } else if category == "不動産所得" {
            return 1 + estateArray.count
        } else if category == "その他入金" {
            return 1 + paymentArray.count
        }
        return 1 + unCategory2Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! BarChartTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! DetailTableViewCell
        
        if indexPath.row == 0 {
            cell1.detailVC = self
            cell1.configureBarChartCell(categoryArray[indexPath.row], year, month)
            return cell1
        }
        
        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            if category == "食費" {
                cell2.foodCell(foodArray[indexPath.row - 1])
                return cell2
            } else if category == "日用品" {
                cell2.brushCell(brushArray[indexPath.row - 1])
                return cell2
            } else if category == "趣味" {
                cell2.hobbyCell(hobbyArray[indexPath.row - 1])
                return cell2
            } else if category == "交際費" {
                cell2.datingCell(datingArray[indexPath.row - 1])
                return cell2
            } else if category == "交通費" {
                cell2.trafficCell(trafficArray[indexPath.row - 1])
                return cell2
            } else if category == "衣服・美容" {
                cell2.clotheCell(clotheArray[indexPath.row - 1])
                return cell2
            } else if category == "健康・医療" {
                cell2.healthCell(healthArray[indexPath.row - 1])
                return cell2
            } else if category == "自動車" {
                cell2.carCell(carArray[indexPath.row - 1])
                return cell2
            } else if category == "教養・教育" {
                cell2.educationCell(educationArray[indexPath.row - 1])
                return cell2
            } else if category == "特別な支出" {
                cell2.specialCell(specialArray[indexPath.row - 1])
                return cell2
            } else if category == "現金・カード" {
                cell2.cardCell(cardArray[indexPath.row - 1])
                return cell2
            } else if category == "水道・光熱費" {
                cell2.utilityCell(utilityArray[indexPath.row - 1])
                return cell2
            } else if category == "通信費" {
                cell2.communicationCell(communicationArray[indexPath.row - 1])
                return cell2
            } else if category == "住宅" {
                cell2.houseCell(houseArray[indexPath.row - 1])
                return cell2
            } else if category == "税・社会保険" {
                cell2.taxCell(taxArray[indexPath.row - 1])
                return cell2
            } else if category == "保険" {
                cell2.insranceCell(insranceArray[indexPath.row - 1])
                return cell2
            } else if category == "その他" {
                cell2.etcetoraCell(etcetoraArray[indexPath.row - 1])
                return cell2
            } else if category == "未分類" {
                cell2.unCategoryCell(unCategoryArray[indexPath.row - 1])
                return cell2
            }
        }
        if category == "給与" {
            cell2.salaryCell(salaryArray[indexPath.row - 1])
            return cell2
        } else if category == "一時所得" {
            cell2.temporaryCell(temporaryArray[indexPath.row - 1])
            return cell2
        } else if category == "事業・副業" {
            cell2.businessCell(businessArray[indexPath.row - 1])
            return cell2
        } else if category == "年金" {
            cell2.pensionCell(pensionArray[indexPath.row - 1])
            return cell2
        } else if category == "配当所得" {
            cell2.devidentCell(devidentArray[indexPath.row - 1])
            return cell2
        } else if category == "不動産所得" {
            cell2.estateCell(estateArray[indexPath.row - 1])
            return cell2
        } else if category == "その他入金" {
            cell2.paymentCell(paymentArray[indexPath.row - 1])
            return cell2
        }
        cell2.unCategory2Cell(unCategory2Array[indexPath.row - 1])
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row >= 1 {
            if UserDefaults.standard.object(forKey: CHANGE) == nil {
                if category == "食費" {
                    id = foodArray[indexPath.row - 1].id
                } else if category == "日用品" {
                    id = brushArray[indexPath.row - 1].id
                } else if category == "趣味" {
                    id = hobbyArray[indexPath.row - 1].id
                } else if category == "交際費" {
                    id = datingArray[indexPath.row - 1].id
                } else if category == "交通費" {
                    id = trafficArray[indexPath.row - 1].id
                } else if category == "衣服・美容" {
                    id = clotheArray[indexPath.row - 1].id
                } else if category == "健康・医療" {
                    id = healthArray[indexPath.row - 1].id
                } else if category == "自動車" {
                    id = carArray[indexPath.row - 1].id
                } else if category == "教養・教育" {
                    id = educationArray[indexPath.row - 1].id
                } else if category == "特別な支出" {
                    id = specialArray[indexPath.row - 1].id
                } else if category == "現金・カード" {
                    id = cardArray[indexPath.row - 1].id
                } else if category == "水道・光熱費" {
                    id = utilityArray[indexPath.row - 1].id
                } else if category == "通信費" {
                    id = communicationArray[indexPath.row - 1].id
                } else if category == "住宅" {
                    id = houseArray[indexPath.row - 1].id
                } else if category == "税・社会保険" {
                    id = taxArray[indexPath.row - 1].id
                } else if category == "保険" {
                    id = insranceArray[indexPath.row - 1].id
                } else if category == "その他" {
                    id = etcetoraArray[indexPath.row - 1].id
                } else if category == "未分類" {
                    id = unCategoryArray[indexPath.row - 1].id
                }
                performSegue(withIdentifier: "EditSpendingVC", sender: nil)
                return
            }
            if category == "給与" {
                id = salaryArray[indexPath.row - 1].id
            } else if category == "一時所得" {
                id = temporaryArray[indexPath.row - 1].id
            } else if category == "事業・副業" {
                id = businessArray[indexPath.row - 1].id
            } else if category == "年金" {
                id = pensionArray[indexPath.row - 1].id
            } else if category == "配当所得" {
                id = devidentArray[indexPath.row - 1].id
            } else if category == "不動産所得" {
                id = estateArray[indexPath.row - 1].id
            } else if category == "その他入金" {
                id = paymentArray[indexPath.row - 1].id
            } else {
                id = unCategory2Array[indexPath.row - 1].id
            }
            performSegue(withIdentifier: "EditIncomeVC", sender: nil)
        }
    }
}
