//
//  CloudBackupTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/20.
//

import UIKit
import PKHUD
import GoogleMobileAds
import RealmSwift

class CloudBackupTableViewController: UITableViewController, GADInterstitialDelegate {
    
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var backupLabel: UILabel!
    @IBOutlet weak var backupButton: UIButton!
    @IBOutlet weak var backupTitleLbl: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    private var count1 = 0
    private var count2 = 0
    private var count3 = 0
    private var count4 = 0
    private var count5 = 0
    private var user = User()
    private var interstitial: GADInterstitial!
    var backupFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUser()
        setSwipeBack()
        interstitial = createAndLoadIntersitial()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backupButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "バックアップしますか？", preferredStyle: .alert)
        let alert2 = UIAlertController(title: "前回のバックアップ数：\(user.backupCount ?? 0)", message: "バックアップを上書きしますか？", preferredStyle: .alert)
        let backup = UIAlertAction(title: "バックアップする", style: UIAlertAction.Style.default) { [self] (alert) in
            doBackup()
        }
        let overwrite = UIAlertAction(title: "上書きする", style: UIAlertAction.Style.default) { [self] (alert) in
            doBackup()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        if user.backupCount > 0 {
            alert2.addAction(overwrite)
            alert2.addAction(cancel)
            self.present(alert2, animated: true,completion: nil)
        } else {
            alert.addAction(backup)
            alert.addAction(cancel)
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    private func fetchUser() {
        User.fetchUser { [self] (user) in
            self.user = user
        }
    }
    
    private func doBackup() {
        
        backupTitleLbl.isHidden = false
        countLabel.isHidden = false
        
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        dateformater.locale = Locale(identifier: "ja_JP")
        let fileName = "バックアップ " + dateformater.string(from: Date())
        User.updateUser(value: [BACKUP_FILE: fileName])
        
        HUD.show(.labeledProgress(title: "保存中です...", subtitle: "しばらくお待ちください"))
        let realm = try! Realm()
        let money = realm.objects(Money.self)
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
        let mCommunicationArray = realm.objects(MonthlyCommunication.self)
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
        let brushArray = realm.objects(Brush.self)
        let hobbyArray = realm.objects(Hobby.self)
        let datingArray = realm.objects(Dating.self)
        let trafficArray = realm.objects(Traffic.self)
        let clotheArray = realm.objects(Clothe.self)
        let healthArray = realm.objects(Health.self)
        let carArray = realm.objects(Car.self)
        let EducationArray = realm.objects(Education.self)
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
        
        // MARK: - Model
        
        money.forEach { (money) in
            
            let dict = [TOTAL_MONEY: money.totalMoney,
                        HOLD_MONEY: money.holdMoney,
                        CREATE_MONEY: money.createMoney,
                        NEXT_MONTH: money.nextMonth] as [String : Any]
            FMoney.saveMoney(value: dict) {
                self.count3 += 1
                self.count5 += 1
                self.countLabel.text = String(self.count3)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                    if count5 == count3 {
                        HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        monthlyArray.forEach { (monthly) in
            
            let dict = [MONEY: monthly.money,
                        DATE: monthly.date,
                        PREVIOUS_MONTH: monthly.previousMonth] as [String : Any]
            
            FMonthly.saveMonthy(date: monthly.date, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        autoArray.forEach { (auto) in
            
            let dict = [PRICE: auto.price,
                        CATEGORY: auto.category,
                        MEMO: auto.memo,
                        PAYMENT: auto.payment,
                        TIMESTAMP: auto.timestamp,
                        DATE: auto.date,
                        NEXT_MONTH: auto.nextMonth,
                        MONTHE: auto.month,
                        DAY: auto.day,
                        IS_INPUT: auto.isInput,
                        ON_REGISTER: auto.onRegister,
                        IS_REGISTER: auto.isRegister,
                        AUTOFILL_DAY: auto.autofillDay,
                        ID: auto.id] as [String : Any]
            
            FAuto.saveAutofill(id: auto.id, value: dict) {
                self.count2 += 1
                self.count3 += 1
                self.countLabel.text = String(self.count3)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                    if count2 >= count3 {
                        HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        // MARK: - Spending data
        
        foodArray.forEach { (data) in
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FFood.saveFood(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        hobbyArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FHobby.saveHobby(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        brushArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FBrush.saveBrush(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        datingArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FDating.saveDating(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        trafficArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FTraffic.saveTraffic(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        clotheArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FClothe.saveClothe(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        healthArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FHealth.saveFHealth(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        carArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FCar.saveFCar(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        EducationArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FEducation.saveFEducation(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        specialArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FSpecial.saveFSpecial(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        utilityArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FUtility.saveFUtility(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        communicationArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FCommmunication.saveFCommmunication(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        houseArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FHouse.saveFHouse(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        taxArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FTax.saveFTax(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        insranceArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FInsrance.saveFInsrance(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        etcetoraArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FEtcetora.saveFEtcetora(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        unCategoryArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FUnCategory.saveFUnCategory(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        cardArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FCard.saveFCard(id: data.id, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        // MARK: - Income data
        
        salaryArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FSalary.saveFSalary(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        temporaryArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FTemporary.saveFTemporary(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        businessArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FBusiness.saveFBusiness(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        pensionArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FPension.saveFPension(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        devidentArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FDevident.saveFDevident(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        estateArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FEstate.saveFEstate(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        paymentArray.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FPayment.saveFPayment(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        unCategory2Array.forEach { (data) in
            
            let dict = [PRICE: data.price,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MEMO: data.memo,
                        YEAR: data.year,
                        MONTHE: data.month,
                        DAY: data.day,
                        ID: data.id] as [String : Any]
            FUnCategory2.saveFUnCategory2(id: data.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        // MARK: - Monthly spending
        
        mFoodArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyFood.saveMonthyFood(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mBrushArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyBrush.saveMonthyBrush(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mHobbyArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyHobby.saveMonthyHobby(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mDatingArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyDating.saveMonthyDating(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mTrafficArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyTraffic.saveMonthyTraffic(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mClotheArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyClothe.saveMonthyClothe(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mHealthArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyHealth.saveMonthyHealth(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mCarArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyCar.saveMonthyCar(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mEducationArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyEducation.saveMonthyEducation(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mSpecialArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlySpecial.saveMonthySpecial(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mCardArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyCard.saveMonthyCard(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mUtilityArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyUtility.saveMonthyUtility(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mCommunicationArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyCommunication.saveMonthyCommunication(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mHouseArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyHouse.saveMonthyHouse(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mTaxArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyTax.saveMonthyTax(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mInsranceArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyInsrance.saveMonthyInsrance(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mEtcetoraArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyEtcetora.saveMonthyEtcetora(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mUnCategoryArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyUnCategory.saveMonthyUnCategory(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        // MARK: - Monthly income

        mSalaryArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlySalary.saveMonthySalary(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mTemporaryArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyTemporary.saveMonthyTemporary(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mBusinessArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyBusiness.saveMonthyBusiness(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mPensionArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyPension.saveMonthyPension(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mDevidentArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyDevident.saveMonthyDevident(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        mEstateArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyEstate.saveMonthyEstate(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }

        mPaymentArray.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyPayment.saveMonthyPayment(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }

        mUnCategory2Array.forEach { (data) in
            
            let dict = [TOTAL_PRICE: data.totalPrice,
                        CATEGORY: data.category,
                        TIMESTAMP: data.timestamp,
                        MONTHLY: data.monthly,
                        DATE: data.date,
                        YEAR: data.year,
                        MONTHE: data.month] as [String : Any]
            FMonthlyUnCategory2.saveMonthyUnCategory2(timestamp: data.timestamp, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
            }
        }
        
        // MARK: - Model
        
        incomeArray.forEach { (income) in
             
            let dict = [PRICE: income.price,
                        CATEGORY: income.category,
                        TIMESTAMP: income.timestamp,
                        DATE: income.date,
                        YEAR: income.year,
                        MONTHE: income.month,
                        DAY: income.day,
                        IS_AUTOFILL: income.isAutofill,
                        ID: income.id] as [String : Any]
            
            FIncome.saveIncome(id: income.id, value: dict) {
                self.count3 += 1
                self.count4 += 1
                self.countLabel.text = String(self.count3)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                    if count4 >= count3 {
                        HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        spendingArray.forEach { (spending) in
            
            let dict = [PRICE: spending.price,
                        CATEGORY: spending.category,
                        TIMESTAMP: spending.timestamp,
                        DATE: spending.date,
                        YEAR: spending.year,
                        MONTHE: spending.month,
                        DAY: spending.day,
                        IS_AUTOFILL: spending.isAutofill,
                        ID: spending.id] as [String : Any]
            
            FSpending.saveSpending(id: spending.id, value: dict) { [self] in

                count1 += 1
                count3 += 1
                countLabel.text = String(self.count3)
                
                if count1 == spendingArray.count {
                    User.updateUser(value: [BACKUP_COUNT: count3])
                    HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            if count2 == 0 && count5 == 0 {
                HUD.flash(.labeledError(title: "", subtitle: "バックアップするデータがありません"), delay: 1)
                generator.notificationOccurred(.error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Error interstitial")
            }
        }
    }
    
    private func setup() {
        
        navigationItem.title = "クラウドバックアップ"
        if backupFile == "" {
            backupLabel.text = "バックアップはありません"
        } else {
            backupLabel.text = backupFile
        }
        backupButton.layer.cornerRadius = 10
        backupButton.isEnabled = false
        checkMark.isHidden = true
        backupTitleLbl.isHidden = true
        countLabel.isHidden = true
        
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            checkMark.isHidden =  false
            UserDefaults.standard.set(true, forKey: CHECK1)
            backupButton.isEnabled = true
        }
    }
}
