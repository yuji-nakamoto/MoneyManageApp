//
//  CloudRestoreTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/20.
//

import UIKit
import PKHUD
import GoogleMobileAds
import RealmSwift

class CloudRestoreTableViewController: UITableViewController, GADInterstitialDelegate {
    
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var restoreLabel: UILabel!
    @IBOutlet weak var restoreButton: UIButton!
    
    var backupFile = ""
    private var user = User()
    private var interstitial: GADInterstitial!
    
    private var count = 0
    private var fMoney = FMoney()
    private var fSpendingArray = [FSpending]()
    private var fIncomeArray = [FIncome]()
    private var fAutoArray = [FAuto]()
    private var fMonthlyArray = [FMonthly]()
    private var fMonthlyFoodArray = [FMonthlyFood]()
    private var fMonthlyBrushArray = [FMonthlyBrush]()
    private var fMonthlyHobbyArray = [FMonthlyHobby]()
    private var fMonthlyDatingArray = [FMonthlyDating]()
    private var fMonthlyTrafficArray = [FMonthlyTraffic]()
    private var fMonthlyClotheArray = [FMonthlyClothe]()
    private var fMonthlyHealthArray = [FMonthlyHealth]()
    private var fMonthlyCarArray = [FMonthlyCar]()
    private var fMonthlyEducationArray = [FMonthlyEducation]()
    private var fMonthlySpecialArray = [FMonthlySpecial]()
    private var fMonthlyCardArray = [FMonthlyCard]()
    private var fMonthlyUtilityArray = [FMonthlyUtility]()
    private var fMonthlyCommunicationArray = [FMonthlyCommunication]()
    private var fMonthlyHouseArray = [FMonthlyHouse]()
    private var fMonthlyTaxArray = [FMonthlyTax]()
    private var fMonthlyInsranceArray = [FMonthlyInsrance]()
    private var fMonthlyEtcetoraArray = [FMonthlyEtcetora]()
    private var fMonthlyUnCategoryArray = [FMonthlyUnCategory]()
    private var fMonthlySalaryArray = [FMonthlySalary]()
    private var fMonthlyTemporaryArray = [FMonthlyTemporary]()
    private var fMonthlyBusinessArray = [FMonthlyBusiness]()
    private var fMonthlyPensionArray = [FMonthlyPension]()
    private var fMonthlyDevidentArray = [FMonthlyDevident]()
    private var fMonthlyEstateArray = [FMonthlyEstate]()
    private var fMonthlyPaymentArray = [FMonthlyPayment]()
    private var fMonthlyUnCategory2Array = [FMonthlyUnCategory2]()
    private var fFoodArray = [FFood]()
    private var fBrushArray = [FBrush]()
    private var fHobbyArray = [FHobby]()
    private var fDatingArray = [FDating]()
    private var fTrafficArray = [FTraffic]()
    private var fClotheArray = [FClothe]()
    private var fHealthArray = [FHealth]()
    private var fCarArray = [FCar]()
    private var fEducationArray = [FEducation]()
    private var fSpecialArray = [FSpecial]()
    private var fCardArray = [FCard]()
    private var fUtilityArray = [FUtility]()
    private var fCommunicationArray = [FCommmunication]()
    private var fHouseArray = [FHouse]()
    private var fTaxArray = [FTax]()
    private var fInsranceArray = [FInsrance]()
    private var fEtcetoraArray = [FEtcetora]()
    private var fUnCategoryArray = [FUnCategory]()
    private var fSalaryArray = [FSalary]()
    private var fTemporaryArray = [FTemporary]()
    private var fBusinessArray = [FBusiness]()
    private var fPensionArray = [FPension]()
    private var fDevidentArray = [FDevident]()
    private var fEstateArray = [FEstate]()
    private var fPaymentArray = [FPayment]()
    private var fUnCategory2Array = [FUnCategory2]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUser()
        fetchData()
        setSwipeBack()
        interstitial = createAndLoadIntersitial()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "バックアップ数：\(user.backupCount ?? 0)", message: "復元しますか？", preferredStyle: .alert)
        let backup = UIAlertAction(title: "復元する", style: UIAlertAction.Style.default) { [self] (alert) in
            doRestore()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(backup)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    private func fetchUser() {
        User.fetchUser { (user) in
            self.user = user
        }
    }
    
    private func doRestore() {
        
        let realm = try! Realm()
        let money = Money()
        let moneyArray = realm.objects(Money.self)
        let spendingArray = realm.objects(Spending.self)
        let incomeArray = realm.objects(Income.self)
        let autoArray = realm.objects(Auto.self)
        let monthlyArray = realm.objects(Monthly.self)
        let mFoodArray = realm.objects(MonthlyFood.self)
        let mBrushArray = realm.objects(MonthlyBrush.self)
        let mHobbyArray = realm.objects(MonthlyHobby.self)
        let mDatingArray = realm.objects(MonthlyDating.self)
        let mTrafficArray = realm.objects(MonthlyTraffic.self)
        let mClotheArray = realm.objects(MonthlyClothe.self)
        let mHealthArray = realm.objects(MonthlyHealth.self)
        let mCarArray = realm.objects(MonthlyCar.self)
        let mEducationArray = realm.objects(MonthlyEducation.self)
        let mSpecialArray = realm.objects(MonthlySpecial.self)
        let mCardArray = realm.objects(MonthlyCard.self)
        let mUtilityArray = realm.objects(MonthlyUtility.self)
        let mCommunicatonArray = realm.objects(MonthlyCommunication.self)
        let mHouseArray = realm.objects(MonthlyHouse.self)
        let mTaxArray = realm.objects(MonthlyTax.self)
        let mInsranceArray = realm.objects(MonthlyInsrance.self)
        let mEtcetoraArray = realm.objects(MonthlyEtcetora.self)
        let mUnCategoryArray = realm.objects(MonthlyUnCategory.self)
        let mSalaryArray = realm.objects(MonthlySalary.self)
        let mTemporaryArray = realm.objects(MonthlyTemporary.self)
        let mBusinessArray = realm.objects(MonthlyBusiness.self)
        let mPensionArray = realm.objects(MonthlyPension.self)
        let mDevidentArray = realm.objects(MonthlyDevident.self)
        let mEstateArray = realm.objects(MonthlyEstate.self)
        let mPaymentArray = realm.objects(MonthlyPayment.self)
        let mUnCategory2Array = realm.objects(MonthlyUnCategory2.self)
        let foodArray = realm.objects(Food.self)
        let hobbyArray = realm.objects(Hobby.self)
        let brushArray = realm.objects(Brush.self)
        let datingArray = realm.objects(Dating.self)
        let trafficArray = realm.objects(Traffic.self)
        let clotheArray = realm.objects(Clothe.self)
        let healtheArray = realm.objects(Health.self)
        let carArray = realm.objects(Car.self)
        let educationArray = realm.objects(Education.self)
        let specialArray = realm.objects(Special.self)
        let cardArray = realm.objects(Card.self)
        let utilityArray = realm.objects(Utility.self)
        let communicationArray = realm.objects(Communicaton.self)
        let houseArray = realm.objects(House.self)
        let taxArray = realm.objects(Tax.self)
        let insranceArray = realm.objects(Insrance.self)
        let etcetoraArray = realm.objects(Etcetora.self)
        let unCategoryArray = realm.objects(UnCategory.self)
        let salaryArray = realm.objects(Salary.self)
        let temporaryArray = realm.objects(Temporary.self)
        let businessArray = realm.objects(Business.self)
        let pensionArray = realm.objects(Pension.self)
        let devidentArray = realm.objects(Devident.self)
        let estateArray = realm.objects(Estate.self)
        let paymentArray = realm.objects(Payment.self)
        let unCategory2Array = realm.objects(UnCategory2.self)
        
        try! realm.write {
            realm.delete(moneyArray)
            realm.delete(spendingArray)
            realm.delete(incomeArray)
            realm.delete(autoArray)
            realm.delete(monthlyArray)
            realm.delete(mFoodArray)
            realm.delete(mBrushArray)
            realm.delete(mHobbyArray)
            realm.delete(mDatingArray)
            realm.delete(mTrafficArray)
            realm.delete(mClotheArray)
            realm.delete(mHealthArray)
            realm.delete(mCarArray)
            realm.delete(mEducationArray)
            realm.delete(mSpecialArray)
            realm.delete(mCardArray)
            realm.delete(mUtilityArray)
            realm.delete(mCommunicatonArray)
            realm.delete(mHouseArray)
            realm.delete(mTaxArray)
            realm.delete(mInsranceArray)
            realm.delete(mEtcetoraArray)
            realm.delete(mUnCategoryArray)
            realm.delete(mSalaryArray)
            realm.delete(mTemporaryArray)
            realm.delete(mBusinessArray)
            realm.delete(mPensionArray)
            realm.delete(mDevidentArray)
            realm.delete(mEstateArray)
            realm.delete(mPaymentArray)
            realm.delete(mUnCategory2Array)
            realm.delete(foodArray)
            realm.delete(brushArray)
            realm.delete(hobbyArray)
            realm.delete(datingArray)
            realm.delete(trafficArray)
            realm.delete(clotheArray)
            realm.delete(healtheArray)
            realm.delete(carArray)
            realm.delete(educationArray)
            realm.delete(specialArray)
            realm.delete(cardArray)
            realm.delete(utilityArray)
            realm.delete(communicationArray)
            realm.delete(houseArray)
            realm.delete(taxArray)
            realm.delete(insranceArray)
            realm.delete(etcetoraArray)
            realm.delete(unCategoryArray)
            realm.delete(salaryArray)
            realm.delete(temporaryArray)
            realm.delete(businessArray)
            realm.delete(pensionArray)
            realm.delete(devidentArray)
            realm.delete(estateArray)
            realm.delete(paymentArray)
            realm.delete(unCategory2Array)
        }
        
        // MARK: - Spending data
        
        fFoodArray.forEach { (data) in
            
            let spending = Food()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fBrushArray.forEach { (data) in
            
            let spending = Brush()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fHobbyArray.forEach { (data) in
            
            let spending = Hobby()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fDatingArray.forEach { (data) in
            
            let spending = Dating()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fTrafficArray.forEach { (data) in
            
            let spending = Traffic()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fClotheArray.forEach { (data) in
            
            let spending = Clothe()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fHealthArray.forEach { (data) in
            
            let spending = Health()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fCarArray.forEach { (data) in
            
            let spending = Car()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fEducationArray.forEach { (data) in
            
            let spending = Education()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fSpecialArray.forEach { (data) in
            
            let spending = Special()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fCardArray.forEach { (data) in
            
            let spending = Card()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fUtilityArray.forEach { (data) in
            
            let spending = Utility()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fCommunicationArray.forEach { (data) in
            
            let spending = Communicaton()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fHouseArray.forEach { (data) in
            
            let spending = House()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fTaxArray.forEach { (data) in
            
            let spending = Tax()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fInsranceArray.forEach { (data) in
            
            let spending = Insrance()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fEtcetoraArray.forEach { (data) in
            
            let spending = Etcetora()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fUnCategoryArray.forEach { (data) in
            
            let spending = UnCategory()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        // MARK: - Income data
        
        fSalaryArray.forEach { (data) in
            
            let spending = Salary()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fTemporaryArray.forEach { (data) in
            
            let spending = Temporary()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fBusinessArray.forEach { (data) in
            
            let spending = Business()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fPensionArray.forEach { (data) in
            
            let spending = Pension()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fDevidentArray.forEach { (data) in
            
            let spending = Devident()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fEstateArray.forEach { (data) in
            
            let spending = Estate()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fPaymentArray.forEach { (data) in
            
            let spending = Payment()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        fUnCategory2Array.forEach { (data) in
            
            let spending = UnCategory2()
            spending.price = data.price
            spending.category = data.category
            spending.memo = data.memo
            spending.timestamp = data.timestamp
            spending.year = data.year
            spending.month = data.month
            spending.day = data.day
            spending.id = data.id
            try! realm.write() {
                realm.add(spending)
            }
        }
        
        // MARK: - Monthly spending
        
        fMonthlyFoodArray.forEach { (data) in
            
            let month = MonthlyFood()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyBrushArray.forEach { (data) in
            
            let month = MonthlyBrush()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyHobbyArray.forEach { (data) in
            
            let month = MonthlyHobby()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyDatingArray.forEach { (data) in
            
            let month = MonthlyDating()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyTrafficArray.forEach { (data) in
            
            let month = MonthlyTraffic()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyClotheArray.forEach { (data) in
            
            let month = MonthlyClothe()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyHealthArray.forEach { (data) in
            
            let month = MonthlyHealth()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyCarArray.forEach { (data) in
            
            let month = MonthlyCar()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyEducationArray.forEach { (data) in
            
            let month = MonthlyEducation()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlySpecialArray.forEach { (data) in
            
            let month = MonthlySpecial()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyCardArray.forEach { (data) in
            
            let month = MonthlyCard()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyUtilityArray.forEach { (data) in
            
            let month = MonthlyUtility()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyCommunicationArray.forEach { (data) in
            
            let month = MonthlyCommunication()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyHouseArray.forEach { (data) in
            
            let month = MonthlyHouse()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyTaxArray.forEach { (data) in
            
            let month = MonthlyTax()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyInsranceArray.forEach { (data) in
            
            let month = MonthlyInsrance()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyEtcetoraArray.forEach { (data) in
            
            let month = MonthlyEtcetora()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyUnCategoryArray.forEach { (data) in
            
            let month = MonthlyUnCategory()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        // MARK: - Monthly income
        
        fMonthlySalaryArray.forEach { (data) in
            
            let month = MonthlySalary()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyTemporaryArray.forEach { (data) in
            
            let month = MonthlyTemporary()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyBusinessArray.forEach { (data) in
            
            let month = MonthlyBusiness()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyPensionArray.forEach { (data) in
            
            let month = MonthlyPension()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyDevidentArray.forEach { (data) in
            
            let month = MonthlyDevident()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyEstateArray.forEach { (data) in
            
            let month = MonthlyEstate()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyPaymentArray.forEach { (data) in
            
            let month = MonthlyPayment()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        fMonthlyUnCategory2Array.forEach { (data) in
            
            let month = MonthlyUnCategory2()
            month.totalPrice = data.totalPrice
            month.category = data.category
            month.timestamp = data.timestamp
            month.date = data.date
            month.monthly = data.monthly
            month.year = data.year
            month.month = data.month
            try! realm.write() {
                realm.add(month)
            }
        }
        
        // MARK: - Main model
        
        money.totalMoney = fMoney.totalMoney
        money.holdMoney = fMoney.holdMoney
        money.createMoney = fMoney.createMoney
        money.nextMonth = fMoney.nextMonth
        try! realm.write() {
            realm.add(money)
        }
        
        fMonthlyArray.forEach { (fMonthly) in
            
            let monthly = Monthly()
            monthly.money = fMonthly.money
            monthly.date = fMonthly.date
            monthly.previousMonth = fMonthly.previousMonth
            try! realm.write() {
                realm.add(monthly)
            }
        }
        
        fAutoArray.forEach { (fAuto) in
            
            let auto = Auto()
            auto.price = fAuto.price
            auto.category = fAuto.category
            auto.memo = fAuto.memo
            auto.timestamp = fAuto.timestamp
            auto.date = fAuto.date
            auto.month = fAuto.month
            auto.day = fAuto.day
            auto.nextMonth = fAuto.nextMonth
            auto.payment = fAuto.payment
            auto.isInput = fAuto.isInput
            auto.onRegister = fAuto.onRegister
            auto.isRegister = fAuto.isRegister
            auto.autofillDay = fAuto.autofillDay
            auto.id = fAuto.id
            try! realm.write() {
                realm.add(auto)
            }
        }
        
        fIncomeArray.forEach { (fIncome) in
            
            let income = Income()
            income.price = fIncome.price
            income.category = fIncome.category
            income.memo = fIncome.memo
            income.timestamp = fIncome.timestamp
            income.date = fIncome.date
            income.year = fIncome.year
            income.month = fIncome.month
            income.day = fIncome.day
            income.isAutofill = fIncome.isAutofill
            income.id = fIncome.id
            try! realm.write() {
                realm.add(income)
            }
        }
        
        fSpendingArray.forEach { (fSpending) in

            let spending = Spending()
            spending.price = fSpending.price
            spending.category = fSpending.category
            spending.memo = fSpending.memo
            spending.timestamp = fSpending.timestamp
            spending.date = fSpending.date
            spending.year = fSpending.year
            spending.month = fSpending.month
            spending.day = fSpending.day
            spending.isAutofill = fSpending.isAutofill
            spending.id = fSpending.id
            try! realm.write() {
                count += 1
                realm.add(spending)
                
                if count == fSpendingArray.count {
                    HUD.flash(.labeledSuccess(title: "", subtitle: "復元しました"), delay: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if self.interstitial.isReady {
                            self.interstitial.present(fromRootViewController: self)
                        } else {
                            print("Error interstitial")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func fetchData() {
        
        FMoney.fetchMoney { (money) in
            self.fMoney = money
        }
        
        FSpending.fetchSpending { (spending) in
            self.fSpendingArray.append(spending)
        }
        
        FIncome.fetchIncome { (income) in
            self.fIncomeArray.append(income)
        }
        
        FAuto.fetchAuto { (auto) in
            self.fAutoArray.append(auto)
        }
        
        FMonthly.fetchMonthly { (monthly) in
            self.fMonthlyArray.append(monthly)
        }
        
        FMonthlyFood.fetchMFood { (data) in
            self.fMonthlyFoodArray.append(data)
        }
        
        FMonthlyBrush.fetchMBrush { (data) in
            self.fMonthlyBrushArray.append(data)
        }
        
        FMonthlyHobby.fetchMHobby { (data) in
            self.fMonthlyHobbyArray.append(data)
        }
        
        FMonthlyDating.fetchMDating { (data) in
            self.fMonthlyDatingArray.append(data)
        }
        
        FMonthlyTraffic.fetchMTraffic { (data) in
            self.fMonthlyTrafficArray.append(data)
        }
        
        FMonthlyClothe.fetchMClothe { (data) in
            self.fMonthlyClotheArray.append(data)
        }
        
        FMonthlyHealth.fetchMHealth { (data) in
            self.fMonthlyHealthArray.append(data)
        }
        
        FMonthlyCar.fetchMCar { (data) in
            self.fMonthlyCarArray.append(data)
        }
        
        FMonthlyEducation.fetchMEducation { (data) in
            self.fMonthlyEducationArray.append(data)
        }
        
        FMonthlySpecial.fetchMSpecial { (data) in
            self.fMonthlySpecialArray.append(data)
        }
        
        FMonthlyCard.fetchMCard { (data) in
            self.fMonthlyCardArray.append(data)
        }
        
        FMonthlyUtility.fetchMUtility { (data) in
            self.fMonthlyUtilityArray.append(data)
        }
        
        FMonthlyCommunication.fetchMCommunication { (data) in
            self.fMonthlyCommunicationArray.append(data)
        }
        
        FMonthlyHouse.fetchMHouse { (data) in
            self.fMonthlyHouseArray.append(data)
        }
        
        FMonthlyTax.fetchMTax { (data) in
            self.fMonthlyTaxArray.append(data)
        }
        
        FMonthlyInsrance.fetchMInsrance { (data) in
            self.fMonthlyInsranceArray.append(data)
        }
        
        FMonthlyEtcetora.fetchMEtcetora { (data) in
            self.fMonthlyEtcetoraArray.append(data)
        }
        
        FMonthlyUnCategory.fetchMUnCategory { (data) in
            self.fMonthlyUnCategoryArray.append(data)
        }
        
        FMonthlySalary.fetchMSalary { (data) in
            self.fMonthlySalaryArray.append(data)
        }
        
        FMonthlyTemporary.fetchMTemporary { (data) in
            self.fMonthlyTemporaryArray.append(data)
        }
        
        FMonthlyBusiness.fetchMBusiness { (data) in
            self.fMonthlyBusinessArray.append(data)
        }
        
        FMonthlyPension.fetchMPension { (data) in
            self.fMonthlyPensionArray.append(data)
        }
        
        FMonthlyDevident.fetchMDevident { (data) in
            self.fMonthlyDevidentArray.append(data)
        }
        
        FMonthlyEstate.fetchMEstate { (data) in
            self.fMonthlyEstateArray.append(data)
        }
        
        FMonthlyPayment.fetchMPayment { (data) in
            self.fMonthlyPaymentArray.append(data)
        }
        
        FMonthlyUnCategory2.fetchMUnCategory2 { (data) in
            self.fMonthlyUnCategory2Array.append(data)
        }
        
        FFood.fetchFood { (data) in
            self.fFoodArray.append(data)
        }
        
        FBrush.fetchBrush { (data) in
            self.fBrushArray.append(data)
        }
        
        FHobby.fetchHobby { (data) in
            self.fHobbyArray.append(data)
        }
        
        FDating.fetchDating { (data) in
            self.fDatingArray.append(data)
        }
        
        FTraffic.fetchTraffic { (data) in
            self.fTrafficArray.append(data)
        }
        
        FClothe.fetchClothe { (data) in
            self.fClotheArray.append(data)
        }
        
        FHealth.fetchFHealth { (data) in
            self.fHealthArray.append(data)
        }
        
        FCar.fetchCar { (data) in
            self.fCarArray.append(data)
        }
        
        FEducation.fetchFEducation { (data) in
            self.fEducationArray.append(data)
        }
        
        FSpecial.fetchFSpecial { (data) in
            self.fSpecialArray.append(data)
        }
        
        FCard.fetchFCard { (data) in
            self.fCardArray.append(data)
        }
        
        FUtility.fetchFUtility { (data) in
            self.fUtilityArray.append(data)
        }
        
        FCommmunication.fetchFCommmunication { (data) in
            self.fCommunicationArray.append(data)
        }
        
        FHouse.fetchFHouse { (data) in
            self.fHouseArray.append(data)
        }
        
        FTax.fetchFTax { (data) in
            self.fTaxArray.append(data)
        }
        
        FInsrance.fetchFInsrance { (data) in
            self.fInsranceArray.append(data)
        }
        
        FEtcetora.fetchFEtcetora { (data) in
            self.fEtcetoraArray.append(data)
        }
        
        FUnCategory.fetchFUnCategory { (data) in
            self.fUnCategoryArray.append(data)
        }
        
        FSalary.fetchFSalary { (data) in
            self.fSalaryArray.append(data)
        }
        
        FTemporary.fetchFTemporary { (data) in
            self.fTemporaryArray.append(data)
        }
        
        FBusiness.fetchFBusiness { (data) in
            self.fBusinessArray.append(data)
        }
        
        FPension.fetchFPension { (data) in
            self.fPensionArray.append(data)
        }
        
        FDevident.fetchFDevident { (data) in
            self.fDevidentArray.append(data)
        }
        
        FEstate.fetchFEstate { (data) in
            self.fEstateArray.append(data)
        }
        
        FPayment.fetchFPayment { (data) in
            self.fPaymentArray.append(data)
        }
        
        FUnCategory2.fetchFUnCategory2 { (data) in
            self.fUnCategory2Array.append(data)
        }
    }
    
    private func setup() {
        
        navigationItem.title = "クラウドバックアップの復元"
        if backupFile == "" {
            restoreLabel.text = "バックアップはありません"
        } else {
            restoreLabel.text = backupFile
        }
        restoreButton.layer.cornerRadius = 10
        restoreButton.isEnabled = false
        checkMark.isHidden = true
        
        UserDefaults.standard.removeObject(forKey: CHECK1)
    }
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4750883229624981/7295600156")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 && backupFile != "" {
            checkMark.isHidden =  false
            UserDefaults.standard.set(true, forKey: CHECK1)
            restoreButton.isEnabled = true
        }
    }
}
