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
    private var count3: Double = 0
    private var count4 = 0
    private var count5 = 0
    private var user = User()
    private var interstitial: GADInterstitial!
    
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
            if user.backupFile != "" {
                backupLabel.text = user.backupFile
            } else {
                backupLabel.text = "バックアップはありません"
            }
        }
    }
    
    private func doBackup() {
        
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
            
            if money.createMoney == false {
                HUD.flash(.labeledError(title: "", subtitle: "バックアップを行うには\n 資産の登録を行ってください "), delay: 2)
                return
            }
            backupTitleLbl.isHidden = false
            countLabel.isHidden = false
            
            let dict = [TOTAL_MONEY: money.totalMoney,
                        HOLD_MONEY: money.holdMoney,
                        CREATE_MONEY: money.createMoney,
                        NEXT_MONTH: money.nextMonth] as [String : Any]
            FMoney.saveMoney(value: dict) {
                self.count3 += 1
                self.count5 += 1
                self.countLabel.text = String(self.count3)
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                }
            }
        }
        
        FMonthly.fetchMonthly { (data) in
            if data.money == 0 {
                monthlyArray.forEach { (monthly) in
                    
                    let dict = [MONEY: monthly.money,
                                DATE: monthly.date,
                                PREVIOUS_MONTH: monthly.previousMonth] as [String : Any]
                    FMonthly.saveMonthy(date: monthly.date, value: dict) {
                        self.count3 += 1
                        self.countLabel.text = String(self.count3)
                    }
                }
            } else {
                var dataArray = [FMonthly]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthly.deleteMonthlry(date: data.date) { [self] in
                        count += 1
                        count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
                            monthlyArray.forEach { (monthly) in
                                
                                let dict = [MONEY: monthly.money,
                                            DATE: monthly.date,
                                            PREVIOUS_MONTH: monthly.previousMonth] as [String : Any]
                                FMonthly.saveMonthy(date: monthly.date, value: dict) {
                                    self.count3 += 1
                                    self.countLabel.text = String(self.count3)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        FAuto.fetchAuto { (data) in
            
            if data.price == 0 {
                autoArray.forEach { (auto) in
                    
                    let dict = [PRICE: auto.price,
                                CATEGORY: auto.category,
                                MEMO: auto.memo,
                                PAYMENT: auto.payment,
                                TIMESTAMP: auto.timestamp,
                                DATE: auto.date,
                                NEXT_MONTH: auto.nextMonth,
                                YEAR: auto.year,
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
                    }
                }
            } else {
                var dataArray = [FAuto]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    
                    FAuto.deleteAuto(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
                            autoArray.forEach { (auto) in
                                
                                let dict = [PRICE: auto.price,
                                            CATEGORY: auto.category,
                                            MEMO: auto.memo,
                                            PAYMENT: auto.payment,
                                            TIMESTAMP: auto.timestamp,
                                            DATE: auto.date,
                                            NEXT_MONTH: auto.nextMonth,
                                            YEAR: auto.year,
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
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // MARK: - Spending data
        
        FFood.fetchFood { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FFood]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FFood.deleteFood(id: d.id) { [self] in
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
                            
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
                        }
                    }
                }
            }
        }
        
        FHobby.fetchHobby { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FHobby]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FHobby.deleteHobby(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
            
        FBrush.fetchBrush { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FBrush]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FBrush.deleteBrush(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FDating.fetchDating { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FDating]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FDating.deleteDating(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FTraffic.fetchTraffic { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FTraffic]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FTraffic.deleteTraffic(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FClothe.fetchClothe { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FClothe]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FClothe.deleteClothe(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FHealth.fetchFHealth { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FHealth]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FHealth.deleteHealth(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FCar.fetchCar { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FCar]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FCar.deleteCar(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FEducation.fetchFEducation { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FEducation]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FEducation.deleteEducation(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FSpecial.fetchFSpecial { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FSpecial]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FSpecial.deleteSpecial(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FUtility.fetchFUtility { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FUtility]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FUtility.deleteUtility(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FCommmunication.fetchFCommmunication { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FCommmunication]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FCommmunication.deleteCommmunication(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FHouse.fetchFHouse { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FHouse]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FHouse.deleteHouse(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FTax.fetchFTax { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FTax]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FTax.deleteTax(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FInsrance.fetchFInsrance { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FInsrance]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FInsrance.deleteInsrance(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FEtcetora.fetchFEtcetora{ (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FEtcetora]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FEtcetora.deleteEtcetora(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FUnCategory.fetchFUnCategory { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FUnCategory]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FUnCategory.deleteUnCategory(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FCard.fetchFCard { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FCard]()
                var count = 0
                dataArray.append(data)
                
                dataArray.forEach { (d) in
                    FCard.deleteCard(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        // MARK: - Income data
        
        FSalary.fetchFSalary { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FSalary]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FSalary.deleteSalary(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
                
        FTemporary.fetchFTemporary { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FTemporary]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FTemporary.deleteTemporary(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FBusiness.fetchFBusiness { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FBusiness]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FBusiness.deleteBusiness(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FPension.fetchFPension { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FPension]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FPension.deletePension(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FDevident.fetchFDevident { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FDevident]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FDevident.deleteDevident(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FEstate.fetchFEstate { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FEstate]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FEstate.deleteEstate(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FPayment.fetchFPayment { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FPayment]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FPayment.deletePayment(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FUnCategory2.fetchFUnCategory2 { (data) in
            if data.price == 0 {
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
            } else {
                var dataArray = [FUnCategory2]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FUnCategory2.deleteUnCategory2(id: d.id) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        // MARK: - Monthly spending
        
        FMonthlyFood.fetchMFood { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyFood]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyFood.deleteMFood(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyBrush.fetchMBrush { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyBrush]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyBrush.deleteMBrush(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyHobby.fetchMHobby { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyHobby]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyHobby.deleteMHobby(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyDating.fetchMDating { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyDating]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyDating.deleteMDating(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyTraffic.fetchMTraffic { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyTraffic]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyTraffic.deleteMTraffic(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyClothe.fetchMClothe { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyClothe]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyClothe.deleteMClothe(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyHealth.fetchMHealth { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyHealth]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyHealth.deleteMHealth(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyCar.fetchMCar { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyCar]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyCar.deleteMCar(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyEducation.fetchMEducation { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyEducation]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyEducation.deleteMEducation(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlySpecial.fetchMSpecial { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlySpecial]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlySpecial.deleteMSpecial(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyCard.fetchMCard { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyCard]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyCard.deleteMCard(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
    
        FMonthlyUtility.fetchMUtility { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyUtility]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyUtility.deleteMUtility(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyCommunication.fetchMCommunication { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyCommunication]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyCommunication.deleteMCommunication(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyHouse.fetchMHouse { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyHouse]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyHouse.deleteMHouse(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyTax.fetchMTax { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyTax]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyTax.deleteMTax(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyInsrance.fetchMInsrance { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyInsrance]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyInsrance.deleteMInsrance(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyEtcetora.fetchMEtcetora { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyEtcetora]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyEtcetora.deleteMEtcetora(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyUnCategory.fetchMUnCategory { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyUnCategory]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyUnCategory.deleteMUnCategory(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        // MARK: - Monthly income

        FMonthlySalary.fetchMSalary { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlySalary]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlySalary.deleteMSalary(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyTemporary.fetchMTemporary { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyTemporary]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyTemporary.deleteMTemporary(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyBusiness.fetchMBusiness { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyBusiness]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyBusiness.deleteMBusiness(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyPension.fetchMPension { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyPension]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyPension.deleteMPension(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyDevident.fetchMDevident { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyDevident]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyDevident.deleteMDevident(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyEstate.fetchMEstate { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyEstate]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyEstate.deleteMEstate(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyPayment.fetchMPayment { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyPayment]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyPayment.deleteMPayment(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        FMonthlyUnCategory2.fetchMUnCategory2 { (data) in
            if data.totalPrice == 0 {
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
            } else {
                var dataArray = [FMonthlyUnCategory2]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FMonthlyUnCategory2.deleteMUnCategory2(timestamp: data.timestamp) {
                        count += 1
                        self.count3 -= 0.5
                        self.countLabel.text = String(self.count3)
                        if count == dataArray.count {
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
                        }
                    }
                }
            }
        }
        
        // MARK: - Model
        
        FIncome.fetchIncome { (data) in
            if data.price == 0 {
                incomeArray.forEach { (income) in
                     
                    let dict = [PRICE: income.price,
                                CATEGORY: income.category,
                                TIMESTAMP: income.timestamp,
                                MEMO: income.memo,
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
                    }
                }
            } else {
                var dataArray = [FIncome]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FIncome.deleteIncome(id: d.id) { [self] in
                        count += 1
                        self.count3 -= 0.5
                        countLabel.text = String(self.count3)
                        if count == dataArray.count {
                            incomeArray.forEach { (income) in
                                 
                                let dict = [PRICE: income.price,
                                            CATEGORY: income.category,
                                            TIMESTAMP: income.timestamp,
                                            MEMO: income.memo,
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
                                }
                            }
                        }
                    }
                }
            }
        }
        
        FSpending.fetchSpending { (data) in
            if data.price == 0 {
                spendingArray.forEach { (spending) in
                    
                    let dict = [PRICE: spending.price,
                                CATEGORY: spending.category,
                                TIMESTAMP: spending.timestamp,
                                MEMO: spending.memo,
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
                            HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 2)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            } else {
                var dataArray = [FSpending]()
                var count = 0
                dataArray.append(data)
                dataArray.forEach { (d) in
                    FSpending.deleteSpending(id: d.id) { [self] in
                        count += 1
                        self.count3 -= 0.5
                        countLabel.text = String(self.count3)
                        if count == dataArray.count {
                            spendingArray.forEach { (spending) in
                                
                                let dict = [PRICE: spending.price,
                                            CATEGORY: spending.category,
                                            TIMESTAMP: spending.timestamp,
                                            MEMO: spending.memo,
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
                                        HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 2)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            navigationController?.popViewController(animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func setup() {
        
        navigationItem.title = "バックアップ"
        backupLabel.text = ""
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
