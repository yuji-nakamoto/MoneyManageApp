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
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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

    var category = ""
    var year = ""
    var month = ""
    private var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectCategory()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchFood() {
        
        let realm = try! Realm()
        let food = realm.objects(Food.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mFood = realm.objects(MonthlyFood.self).filter("year == '\(year)'").filter("month == '\(month)'")
        foodArray.removeAll()
        foodArray.append(contentsOf: food)
        if foodArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        foodArray.forEach { (food) in
            navigationItem.title = food.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color1")
        }
        mFood.forEach { (mfood) in
            let result = String.localizedStringWithFormat("%d", mfood.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mfood.timestamp
            dateLabel.text = mfood.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchBrush() {
        
        let realm = try! Realm()
        let brush = realm.objects(Brush.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mbrush = realm.objects(MonthlyBrush.self).filter("year == '\(year)'").filter("month == '\(month)'")
        brushArray.removeAll()
        brushArray.append(contentsOf: brush)
        if brushArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        brushArray.forEach { (brush) in
            navigationItem.title = brush.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color2")
        }
        mbrush.forEach { (mbrush) in
            let result = String.localizedStringWithFormat("%d", mbrush.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mbrush.timestamp
            dateLabel.text = mbrush.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchHobby() {
        
        let realm = try! Realm()
        let hobby = realm.objects(Hobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mhobby = realm.objects(MonthlyHobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
        hobbyArray.removeAll()
        hobbyArray.append(contentsOf: hobby)
        if hobbyArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        hobbyArray.forEach { (hobby) in
            navigationItem.title = hobby.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color3")
        }
        mhobby.forEach { (mhobby) in
            let result = String.localizedStringWithFormat("%d", mhobby.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mhobby.timestamp
            dateLabel.text = mhobby.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchDating() {
        
        let realm = try! Realm()
        let dating = realm.objects(Dating.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mDating = realm.objects(MonthlyDating.self).filter("year == '\(year)'").filter("month == '\(month)'")
        datingArray.removeAll()
        datingArray.append(contentsOf: dating)
        if datingArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        datingArray.forEach { (dating) in
            navigationItem.title = dating.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color4")
        }
        mDating.forEach { (mDating) in
            let result = String.localizedStringWithFormat("%d", mDating.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mDating.timestamp
            dateLabel.text = mDating.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchTraffic() {
        
        let realm = try! Realm()
        let traffic = realm.objects(Traffic.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(year)'").filter("month == '\(month)'")

        trafficArray.removeAll()
        trafficArray.append(contentsOf: traffic)
        if trafficArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        trafficArray.forEach { (traffic) in
            navigationItem.title = traffic.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color5")
        }
        mTraffic.forEach { (mTraffic) in
            let result = String.localizedStringWithFormat("%d", mTraffic.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mTraffic.timestamp
            dateLabel.text = mTraffic.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchClothe() {
        
        let realm = try! Realm()
        let clothe = realm.objects(Clothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        clotheArray.removeAll()
        clotheArray.append(contentsOf: clothe)
        if clotheArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        clotheArray.forEach { (clothe) in
            navigationItem.title = clothe.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color6")
        }
        mClothe.forEach { (mClothe) in
            let result = String.localizedStringWithFormat("%d", mClothe.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mClothe.timestamp
            dateLabel.text = mClothe.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchHealth() {
        
        let realm = try! Realm()
        let health = realm.objects(Health.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mHealth = realm.objects(MonthlyHealth.self).filter("year == '\(year)'").filter("month == '\(month)'")

        healthArray.removeAll()
        healthArray.append(contentsOf: health)
        if healthArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        healthArray.forEach { (health) in
            navigationItem.title = health.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color7")
        }
        mHealth.forEach { (mHealth) in
            let result = String.localizedStringWithFormat("%d", mHealth.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mHealth.timestamp
            dateLabel.text = mHealth.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchCar() {
        
        let realm = try! Realm()
        let car = realm.objects(Car.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mCar = realm.objects(MonthlyCar.self).filter("year == '\(year)'").filter("month == '\(month)'")

        carArray.removeAll()
        carArray.append(contentsOf: car)
        if cardArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        carArray.forEach { (car) in
            navigationItem.title = car.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color8")
        }
        mCar.forEach { (mCar) in
            let result = String.localizedStringWithFormat("%d", mCar.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mCar.timestamp
            dateLabel.text = mCar.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchEducation() {
        
        let realm = try! Realm()
        let education = realm.objects(Education.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(year)'").filter("month == '\(month)'")

        educationArray.removeAll()
        educationArray.append(contentsOf: education)
        if educationArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        educationArray.forEach { (education) in
            navigationItem.title = education.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color9")
        }
        mEducation.forEach { (mEducation) in
            let result = String.localizedStringWithFormat("%d", mEducation.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mEducation.timestamp
            dateLabel.text = mEducation.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchSpecial() {
        
        let realm = try! Realm()
        let special = realm.objects(Special.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(year)'").filter("month == '\(month)'")

        specialArray.removeAll()
        specialArray.append(contentsOf: special)
        if specialArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        specialArray.forEach { (special) in
            navigationItem.title = special.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color10")
        }
        mSpecial.forEach { (mSpecial) in
            let result = String.localizedStringWithFormat("%d", mSpecial.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mSpecial.timestamp
            dateLabel.text = mSpecial.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchCard() {
        
        let realm = try! Realm()
        let card = realm.objects(Card.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mCard = realm.objects(MonthlyCard.self).filter("year == '\(year)'").filter("month == '\(month)'")

        cardArray.removeAll()
        cardArray.append(contentsOf: card)
        if cardArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        cardArray.forEach { (card) in
            navigationItem.title = card.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color24")
        }
        mCard.forEach { (mCard) in
            let result = String.localizedStringWithFormat("%d", mCard.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mCard.timestamp
            dateLabel.text = mCard.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchUtility() {
        
        let realm = try! Realm()
        let utility = realm.objects(Utility.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(year)'").filter("month == '\(month)'")

        utilityArray.removeAll()
        utilityArray.append(contentsOf: utility)
        if utilityArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        utilityArray.forEach { (utility) in
            navigationItem.title = utility.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color11")
        }
        mUtility.forEach { (mUtility) in
            let result = String.localizedStringWithFormat("%d", mUtility.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mUtility.timestamp
            dateLabel.text = mUtility.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchCommunicaton() {
        
        let realm = try! Realm()
        let communication = realm.objects(Communicaton.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(year)'").filter("month == '\(month)'")

        communicationArray.removeAll()
        communicationArray.append(contentsOf: communication)
        if communicationArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        communicationArray.forEach { (communication) in
            navigationItem.title = communication.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color12")
        }
        mCommunication.forEach { (mCommunication) in
            let result = String.localizedStringWithFormat("%d", mCommunication.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mCommunication.timestamp
            dateLabel.text = mCommunication.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchHouse() {
        
        let realm = try! Realm()
        let house = realm.objects(House.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(year)'").filter("month == '\(month)'")

        houseArray.removeAll()
        houseArray.append(contentsOf: house)
        if houseArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        houseArray.forEach { (house) in
            navigationItem.title = house.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color13")
        }
        mHouse.forEach { (mHouse) in
            let result = String.localizedStringWithFormat("%d", mHouse.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mHouse.timestamp
            dateLabel.text = mHouse.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchTax() {
        
        let realm = try! Realm()
        let tax = realm.objects(Tax.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mTax = realm.objects(MonthlyTax.self).filter("year == '\(year)'").filter("month == '\(month)'")

        taxArray.removeAll()
        taxArray.append(contentsOf: tax)
        if taxArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        taxArray.forEach { (tax) in
            navigationItem.title = tax.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color14")
        }
        mTax.forEach { (mTax) in
            let result = String.localizedStringWithFormat("%d", mTax.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mTax.timestamp
            dateLabel.text = mTax.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchInsrance() {
        
        let realm = try! Realm()
        let insrance = realm.objects(Insrance.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(year)'").filter("month == '\(month)'")

        insranceArray.removeAll()
        insranceArray.append(contentsOf: insrance)
        if insranceArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        insranceArray.forEach { (insrance) in
            navigationItem.title = insrance.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color15")
        }
        mInsrance.forEach { (mInsrance) in
            let result = String.localizedStringWithFormat("%d", mInsrance.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mInsrance.timestamp
            dateLabel.text = mInsrance.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchEtcetora() {
        
        let realm = try! Realm()
        let etcetora = realm.objects(Etcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")

        etcetoraArray.removeAll()
        etcetoraArray.append(contentsOf: etcetora)
        if etcetoraArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        etcetoraArray.forEach { (etcetora) in
            navigationItem.title = etcetora.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color16")
        }
        mEtcetora.forEach { (mEtcetora) in
            let result = String.localizedStringWithFormat("%d", mEtcetora.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mEtcetora.timestamp
            dateLabel.text = mEtcetora.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchUnCategory() {
        
        let realm = try! Realm()
        let unCategory = realm.objects(UnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mUncategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")

        unCategoryArray.removeAll()
        unCategoryArray.append(contentsOf: unCategory)
        if unCategoryArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        unCategoryArray.forEach { (unCategory) in
            navigationItem.title = unCategory.category
            navigationController?.navigationBar.barTintColor = .systemGray
        }
        mUncategory.forEach { (mUncategory) in
            let result = String.localizedStringWithFormat("%d", mUncategory.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mUncategory.timestamp
            dateLabel.text = mUncategory.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchSalary() {
        
        let realm = try! Realm()
        let salary = realm.objects(Salary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mSalary = realm.objects(MonthlySalary.self).filter("year == '\(year)'").filter("month == '\(month)'")

        salaryArray.removeAll()
        salaryArray.append(contentsOf: salary)
        if salaryArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        salaryArray.forEach { (salary) in
            navigationItem.title = salary.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color17")
        }
        mSalary.forEach { (mSalary) in
            let result = String.localizedStringWithFormat("%d", mSalary.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mSalary.timestamp
            dateLabel.text = mSalary.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchTemporary() {
        
        let realm = try! Realm()
        let temporary = realm.objects(Temporary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(year)'").filter("month == '\(month)'")

        temporaryArray.removeAll()
        temporaryArray.append(contentsOf: temporary)
        if temporaryArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        temporaryArray.forEach { (temporary) in
            navigationItem.title = temporary.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color18")
        }
        mTemporary.forEach { (mTemporary) in
            let result = String.localizedStringWithFormat("%d", mTemporary.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mTemporary.timestamp
            dateLabel.text = mTemporary.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchBusiness() {
        
        let realm = try! Realm()
        let business = realm.objects(Business.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(year)'").filter("month == '\(month)'")

        businessArray.removeAll()
        businessArray.append(contentsOf: business)
        if businessArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        businessArray.forEach { (business) in
            navigationItem.title = business.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color19")
        }
        mBusiness.forEach { (mBusiness) in
            let result = String.localizedStringWithFormat("%d", mBusiness.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mBusiness.timestamp
            dateLabel.text = mBusiness.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchPension() {
        
        let realm = try! Realm()
        let pension = realm.objects(Pension.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mPension = realm.objects(MonthlyPension.self).filter("year == '\(year)'").filter("month == '\(month)'")

        pensionArray.removeAll()
        pensionArray.append(contentsOf: pension)
        if pensionArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        pensionArray.forEach { (pension) in
            navigationItem.title = pension.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color20")
        }
        mPension.forEach { (mPension) in
            let result = String.localizedStringWithFormat("%d", mPension.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mPension.timestamp
            dateLabel.text = mPension.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchDevident() {
        
        let realm = try! Realm()
        let devident = realm.objects(Devident.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mDevident = realm.objects(MonthlyDevident.self).filter("year == '\(year)'").filter("month == '\(month)'")

        devidentArray.removeAll()
        devidentArray.append(contentsOf: devident)
        if devidentArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        devidentArray.forEach { (devident) in
            navigationItem.title = devident.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color21")
        }
        mDevident.forEach { (mDevident) in
            let result = String.localizedStringWithFormat("%d", mDevident.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mDevident.timestamp
            dateLabel.text = mDevident.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchEstate() {
        
        let realm = try! Realm()
        let estate = realm.objects(Estate.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mEstate = realm.objects(MonthlyEstate.self).filter("year == '\(year)'").filter("month == '\(month)'")

        estateArray.removeAll()
        estateArray.append(contentsOf: estate)
        if estateArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        estateArray.forEach { (estate) in
            navigationItem.title = estate.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color22")
        }
        mEstate.forEach { (mEstate) in
            let result = String.localizedStringWithFormat("%d", mEstate.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mEstate.timestamp
            dateLabel.text = mEstate.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchPayment() {
        
        let realm = try! Realm()
        let payment = realm.objects(Payment.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mPayment = realm.objects(MonthlyPayment.self).filter("year == '\(year)'").filter("month == '\(month)'")

        paymentArray.removeAll()
        paymentArray.append(contentsOf: payment)
        if paymentArray.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        paymentArray.forEach { (payment) in
            navigationItem.title = payment.category
            navigationController?.navigationBar.barTintColor = UIColor(named: "icon_color23")
        }
        mPayment.forEach { (mPayment) in
            let result = String.localizedStringWithFormat("%d", mPayment.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mPayment.timestamp
            dateLabel.text = mPayment.monthly
        }
        tableView.reloadData()
    }
    
    private func fetchUnCategory2() {
        
        let realm = try! Realm()
        let unCategory2 = realm.objects(UnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let mUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")

        unCategory2Array.removeAll()
        unCategory2Array.append(contentsOf: unCategory2)
        if unCategory2Array.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        unCategory2Array.forEach { (unCategory2) in
            navigationItem.title = unCategory2.category
            navigationController?.navigationBar.barTintColor = .systemGray
        }
        mUnCategory2.forEach { (mUnCategory2) in
            let result = String.localizedStringWithFormat("%d", mUnCategory2.totalPrice)
            priceLabel.text = "¥" + result
            timestampLabel.text = mUnCategory2.timestamp
            dateLabel.text = mUnCategory2.monthly
        }
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func selectCategory() {
        
        if UserDefaults.standard.object(forKey: CHANGE) == nil {
            if category == "食費" {
                fetchFood()
            } else if category == "日用品" {
                fetchBrush()
            } else if category == "趣味" {
                fetchHobby()
            } else if category == "交際費" {
                fetchDating()
            } else if category == "交通費" {
                fetchTraffic()
            } else if category == "衣服・美容" {
                fetchClothe()
            } else if category == "健康・医療" {
                fetchHealth()
            } else if category == "自動車" {
                fetchCar()
            } else if category == "教養・教育" {
                fetchEducation()
            } else if category == "特別な支出" {
                fetchSpecial()
            } else if category == "現金・カード" {
                fetchCard()
            } else if category == "水道・光熱費" {
                fetchUtility()
            } else if category == "通信費" {
                fetchCommunicaton()
            } else if category == "住宅" {
                fetchHouse()
            } else if category == "税・社会保険" {
                fetchTax()
            } else if category == "保険" {
                fetchInsrance()
            } else if category == "その他" {
                fetchEtcetora()
            } else if category == "未分類" {
                fetchUnCategory()
            }
        } else {
            if category == "給与" {
                fetchSalary()
            } else if category == "一時所得" {
                fetchTemporary()
            } else if category == "事業・副業" {
                fetchBusiness()
            } else if category == "年金" {
                fetchPension()
            } else if category == "配当所得" {
                fetchDevident()
            } else if category == "不動産所得" {
                fetchEstate()
            } else if category == "その他入金" {
                fetchPayment()
            } else if category == "未分類" {
                fetchUnCategory2()
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
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1")
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! DetailTableViewCell
        
        if indexPath.row == 0 {
            return cell1!
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
