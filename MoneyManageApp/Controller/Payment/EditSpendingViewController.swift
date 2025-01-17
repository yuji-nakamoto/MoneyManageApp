//
//  EditSpendingViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import PKHUD
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class EditSpendingViewController: UIViewController, UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // MARK: - Properties
    
    @IBOutlet weak var caluclatorView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberLabel2: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var devideButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var autofillSwitch: UISwitch!
    @IBOutlet weak var autofillLabel: UILabel!
    @IBOutlet weak var numberLbl2TopConst: NSLayoutConstraint!
    @IBOutlet weak var numberLbl2BottomConst: NSLayoutConstraint!
    @IBOutlet weak var enMarkLabel: UILabel!
    @IBOutlet weak var categoryImageTopConst: NSLayoutConstraint!
    @IBOutlet weak var categoryImageBottomConst: NSLayoutConstraint!
    @IBOutlet weak var calenderImageTopConst: NSLayoutConstraint!
    @IBOutlet weak var calenderImageBottomConst: NSLayoutConstraint!
    @IBOutlet weak var memoImageTopConst: NSLayoutConstraint!
    @IBOutlet weak var memoImageBottomConst: NSLayoutConstraint!
    @IBOutlet weak var calenderHeight: NSLayoutConstraint!
    
    lazy var buttons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, clearButton, multiplyButton, minusButton, plusButton, devideButton]
    private var firstNumeric = false
    private var lastNumeric = false
    private var yyyy_mm_dd2 = ""
    private var yyyy_mm2 = ""
    private var year2 = ""
    private var month2 = ""
    private var day2 = ""
    
    var id = UserDefaults.standard.object(forKey: SPENDING_ID) as! String
    let realm = try? Realm()
    lazy var food = realm!.objects(Food.self).filter("id = '\(id)'")
    lazy var brush = realm!.objects(Brush.self).filter("id = '\(id)'")
    lazy var hobby = realm!.objects(Hobby.self).filter("id = '\(id)'")
    lazy var dating = realm!.objects(Dating.self).filter("id = '\(id)'")
    lazy var traffic = realm!.objects(Traffic.self).filter("id = '\(id)'")
    lazy var clothe = realm!.objects(Clothe.self).filter("id = '\(id)'")
    lazy var health = realm!.objects(Health.self).filter("id = '\(id)'")
    lazy var car = realm!.objects(Car.self).filter("id = '\(id)'")
    lazy var education = realm!.objects(Education.self).filter("id = '\(id)'")
    lazy var special = realm!.objects(Special.self).filter("id = '\(id)'")
    lazy var utility = realm!.objects(Utility.self).filter("id = '\(id)'")
    lazy var communication = realm!.objects(Communicaton.self).filter("id = '\(id)'")
    lazy var house = realm!.objects(House.self).filter("id = '\(id)'")
    lazy var tax = realm!.objects(Tax.self).filter("id = '\(id)'")
    lazy var insrance = realm!.objects(Insrance.self).filter("id = '\(id)'")
    lazy var etcetora = realm!.objects(Etcetora.self).filter("id = '\(id)'")
    lazy var unCategory = realm!.objects(UnCategory.self).filter("id = '\(id)'")
    lazy var card = realm!.objects(Card.self).filter("id = '\(id)'")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSpending()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCategory()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Fetch
    
    private func fetchSpending() {
        
        let realm = try! Realm()
        let spending = realm.objects(Spending.self).filter("id = '\(id)'")
        
        spending.forEach { (spending) in
            numberLabel.text = String(spending.price)
            
            let number = Int(numberLabel.text!)
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
            numberLabel2.text = result
            categoryLabel.text = spending.category
            dateLabel.text = spending.timestamp
            textField.text = spending.memo
            yyyy_mm_dd2 = spending.date
            year2 = spending.year
            month2 = spending.month
            day2 = spending.month
            id = spending.id
            
            if spending.isAutofill == true {
                autofillLabel.text = "自動入力に登録済み"
                autofillLabel.textColor = .systemGray
                autofillSwitch.isEnabled = false
            } else {
                autofillLabel.text = "自動入力に登録"
                autofillLabel.textColor = UIColor(named: O_BLACK)
                autofillSwitch.isEnabled = true
            }
            
            if spending.category == "未分類" {
                categoryImageView.image = UIImage(systemName: "questionmark.circle")
                categoryImageView.tintColor = .systemGray
                categoryLabel.text = "未分類"
            } else if spending.category == "食費" {
                categoryImageView.image = UIImage(named: "food")
                categoryLabel.text = "食費"
            } else if spending.category == "日用品" {
                categoryImageView.image = UIImage(named: "brush")
                categoryLabel.text = "日用品"
            } else if spending.category == "趣味" {
                categoryImageView.image = UIImage(named: "hobby")
                categoryLabel.text = "趣味"
            } else if spending.category == "交際費" {
                categoryImageView.image = UIImage(named: "dating")
                categoryLabel.text = "交際費"
            } else if spending.category == "交通費" {
                categoryImageView.image = UIImage(named: "traffic")
                categoryLabel.text = "交通費"
            } else if spending.category == "衣服・美容" {
                categoryImageView.image = UIImage(named: "clothe")
                categoryLabel.text = "衣服・美容"
            } else if spending.category == "健康・医療" {
                categoryImageView.image = UIImage(named: "health")
                categoryLabel.text = "健康・医療"
            } else if spending.category == "自動車" {
                categoryImageView.image = UIImage(named: "car")
                categoryLabel.text = "自動車"
            } else if spending.category == "教養・教育" {
                categoryImageView.image = UIImage(named: "education")
                categoryLabel.text = "教養・教育"
            } else if spending.category == "特別な支出" {
                categoryImageView.image = UIImage(named: "special")
                categoryLabel.text = "特別な支出"
            } else if spending.category == "現金・カード" {
                categoryImageView.image = UIImage(named: "card")
                categoryLabel.text = "現金・カード"
            } else if spending.category == "水道・光熱費" {
                categoryImageView.image = UIImage(named: "utility")
                categoryLabel.text = "水道・光熱費"
            } else if spending.category == "通信費" {
                categoryImageView.image = UIImage(named: "communication")
                categoryLabel.text = "通信費"
            } else if spending.category == "住宅" {
                categoryImageView.image = UIImage(named: "house")
                categoryLabel.text = "住宅"
            } else if spending.category == "税・社会保険" {
                categoryImageView.image = UIImage(named: "tax")
                categoryLabel.text = "税・社会保険"
            } else if spending.category == "保険" {
                categoryImageView.image = UIImage(named: "insrance")
                categoryLabel.text = "保険"
            } else if spending.category == "その他" {
                categoryImageView.image = UIImage(named: "etcetra")
                categoryLabel.text = "その他"
            }
        }
    }
    
    // MARK: - Delete
    
    @IBAction func deleteButtonPressd(_ sender: Any) {
        
        let realm = try! Realm()
        let spending = realm.objects(Spending.self).filter("id = '\(id)'")
        spending.forEach { (spending) in
            let alert = UIAlertController(title: spending.category, message: "データを削除しますか？", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                try! realm.write {
                    if spending.category == "食費" {
                        food.forEach { (food) in
                            let mFood = realm.objects(MonthlyFood.self).filter("year == '\(food.year)'").filter("month == '\(food.month)'")
                            mFood.forEach { (data) in
                                data.totalPrice = data.totalPrice - food.price
                                if data.totalPrice == 0 {
                                    realm.delete(mFood)
                                }
                            }
                        }
                        realm.delete(food)
                    } else if spending.category == "日用品" {
                        brush.forEach { (brush) in
                            let mBrush = realm.objects(MonthlyBrush.self).filter("year == '\(brush.year)'").filter("month == '\(brush.month)'")
                            mBrush.forEach { (data) in
                                data.totalPrice = data.totalPrice - brush.price
                                if data.totalPrice == 0 {
                                    realm.delete(mBrush)
                                }
                            }
                        }
                        realm.delete(brush)
                    } else if spending.category == "趣味" {
                        hobby.forEach { (hobby) in
                            let mHobby = realm.objects(MonthlyHobby.self).filter("year == '\(hobby.year)'").filter("month == '\(hobby.month)'")
                            mHobby.forEach { (data) in
                                data.totalPrice = data.totalPrice - hobby.price
                                if data.totalPrice == 0 {
                                    realm.delete(mHobby)
                                }
                            }
                        }
                        realm.delete(hobby)
                    } else if spending.category == "交際費" {
                        dating.forEach { (dating) in
                            let mDating = realm.objects(MonthlyDating.self).filter("year == '\(dating.year)'").filter("month == '\(dating.month)'")
                            mDating.forEach { (data) in
                                data.totalPrice = data.totalPrice - dating.price
                                if data.totalPrice == 0 {
                                    realm.delete(mDating)
                                }
                            }
                        }
                        realm.delete(dating)
                    } else if spending.category == "交通費" {
                        traffic.forEach { (traffic) in
                            let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(traffic.year)'").filter("month == '\(traffic.month)'")
                            mTraffic.forEach { (data) in
                                data.totalPrice = data.totalPrice - traffic.price
                                if data.totalPrice == 0 {
                                    realm.delete(mTraffic)
                                }
                            }
                        }
                        realm.delete(traffic)
                    } else if spending.category == "衣服・美容" {
                        clothe.forEach { (clothe) in
                            let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(clothe.year)'").filter("month == '\(clothe.month)'")
                            mClothe.forEach { (data) in
                                data.totalPrice = data.totalPrice - clothe.price
                                if data.totalPrice == 0 {
                                    realm.delete(mClothe)
                                }
                            }
                        }
                        realm.delete(clothe)
                    } else if spending.category == "健康・医療" {
                        health.forEach { (health) in
                            let mhealth = realm.objects(MonthlyHealth.self).filter("year == '\(health.year)'").filter("month == '\(health.month)'")
                            mhealth.forEach { (data) in
                                data.totalPrice = data.totalPrice - health.price
                                if data.totalPrice == 0 {
                                    realm.delete(mhealth)
                                }
                            }
                        }
                        realm.delete(health)
                    } else if spending.category == "自動車" {
                        car.forEach { (car) in
                            let mCar = realm.objects(MonthlyCar.self).filter("year == '\(car.year)'").filter("month == '\(car.month)'")
                            mCar.forEach { (data) in
                                data.totalPrice = data.totalPrice - car.price
                                if data.totalPrice == 0 {
                                    realm.delete(mCar)
                                }
                            }
                        }
                        realm.delete(car)
                    } else if spending.category == "教養・教育" {
                        education.forEach { (education) in
                            let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(education.year)'").filter("month == '\(education.month)'")
                            mEducation.forEach { (data) in
                                data.totalPrice = data.totalPrice - education.price
                                if data.totalPrice == 0 {
                                    realm.delete(mEducation)
                                }
                            }
                        }
                        realm.delete(education)
                    } else if spending.category == "特別な支出" {
                        special.forEach { (special) in
                            let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(special.year)'").filter("month == '\(special.month)'")
                            mSpecial.forEach { (data) in
                                data.totalPrice = data.totalPrice - special.price
                                if data.totalPrice == 0 {
                                    realm.delete(mSpecial)
                                }
                            }
                        }
                        realm.delete(special)
                    } else if spending.category == "現金・カード" {
                        card.forEach { (card) in
                            let mCard = realm.objects(MonthlyCard.self).filter("year == '\(card.year)'").filter("month == '\(card.month)'")
                            mCard.forEach { (data) in
                                data.totalPrice = data.totalPrice - card.price
                                if data.totalPrice == 0 {
                                    realm.delete(mCard)
                                }
                            }
                        }
                        realm.delete(card)
                    } else if spending.category == "水道・光熱費" {
                        utility.forEach { (utility) in
                            let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(utility.year)'").filter("month == '\(utility.month)'")
                            mUtility.forEach { (data) in
                                data.totalPrice = data.totalPrice - utility.price
                                if data.totalPrice == 0 {
                                    realm.delete(mUtility)
                                }
                            }
                        }
                        realm.delete(utility)
                    } else if spending.category == "通信費" {
                        communication.forEach { (communication) in
                            let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(communication.year)'").filter("month == '\(communication.month)'")
                            mCommunication.forEach { (data) in
                                data.totalPrice = data.totalPrice - communication.price
                                if data.totalPrice == 0 {
                                    realm.delete(mCommunication)
                                }
                            }
                        }
                        realm.delete(communication)
                    } else if spending.category == "住宅" {
                        house.forEach { (house) in
                            let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(house.year)'").filter("month == '\(house.month)'")
                            mHouse.forEach { (data) in
                                data.totalPrice = data.totalPrice - house.price
                                if data.totalPrice == 0 {
                                    realm.delete(mHouse)
                                }
                            }
                        }
                        realm.delete(house)
                    } else if spending.category == "税・社会保険" {
                        tax.forEach { (tax) in
                            let mTax = realm.objects(MonthlyTax.self).filter("year == '\(tax.year)'").filter("month == '\(tax.month)'")
                            mTax.forEach { (data) in
                                data.totalPrice = data.totalPrice - tax.price
                                if data.totalPrice == 0 {
                                    realm.delete(mTax)
                                }
                            }
                        }
                        realm.delete(tax)
                    } else if spending.category == "保険" {
                        insrance.forEach { (insrance) in
                            let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(insrance.year)'").filter("month == '\(insrance.month)'")
                            mInsrance.forEach { (data) in
                                data.totalPrice = data.totalPrice - insrance.price
                                if data.totalPrice == 0 {
                                    realm.delete(mInsrance)
                                }
                            }
                        }
                        realm.delete(insrance)
                    } else if spending.category == "その他" {
                        etcetora.forEach { (etcetora) in
                            let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(etcetora.year)'").filter("month == '\(etcetora.month)'")
                            mEtcetora.forEach { (data) in
                                data.totalPrice = data.totalPrice - etcetora.price
                                if data.totalPrice == 0 {
                                    realm.delete(mEtcetora)
                                }
                            }
                        }
                        realm.delete(etcetora)
                    } else if spending.category == "未分類" {
                        unCategory.forEach { (unCategory) in
                            let mUnCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(unCategory.year)'").filter("month == '\(unCategory.month)'")
                            mUnCategory.forEach { (data) in
                                data.totalPrice = data.totalPrice - unCategory.price
                                if data.totalPrice == 0 {
                                    realm.delete(mUnCategory)
                                }
                            }
                        }
                        realm.delete(unCategory)
                    }
                    realm.delete(spending)
                    HUD.flash(.labeledSuccess(title: "", subtitle: "削除しました"), delay: 0.5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        dismiss(animated: true, completion: nil)
                    }
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            let screenSize = UIScreen.main.bounds
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    // MARK: - Actions
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerButtonPressed(_ sender: Any) {
        
        textField.resignFirstResponder()
        caluclatorView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.calender.isHidden = !self.calender.isHidden
        }
    }
    
    @IBAction func calculatorButtonPressed(_ sender: Any) {
        
        textField.resignFirstResponder()
        calender.isHidden = true
        UIView.animate(withDuration: 0.25) {
            self.caluclatorView.isHidden = !self.caluclatorView.isHidden
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if numberLabel.text == "0" {
            HUD.flash(.labeledError(title: "", subtitle: "価格を入力してください"), delay: 1)
            return
        }
        
        textField.resignFirstResponder()
        updateSpending()
    }
    
    @IBAction func zeroButtonPressed(_ sender: Any) {
        
        zeroButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            zeroButton.backgroundColor = UIColor(named: O_BLACK)
        }
        
        if !lastNumeric {
            if UserDefaults.standard.object(forKey: PLUS) != nil || UserDefaults.standard.object(forKey: MINUS) != nil || UserDefaults.standard.object(forKey: MULTIPLY) != nil || UserDefaults.standard.object(forKey: DEVIDE) != nil {
                return
            }
        }
        
        if firstNumeric {
            if numberLabel.text!.count > 12 { return }
            if numberLabel2.text!.count > 12 { return }
            numberLabel.text?.append("0")
            let number = Int(numberLabel.text!)
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
            numberLabel2.text = result
        }
    }
    
    @IBAction func oneButtonPressed(_ sender: Any) {
        oneButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            oneButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("1")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func twoButtonPressed(_ sender: Any) {
        twoButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            twoButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("2")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func threeButtonPressed(_ sender: Any) {
        threeButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            threeButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("3")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func fourButtonPressed(_ sender: Any) {
        fourButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            fourButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("4")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func fiveButtonPressed(_ sender: Any) {
        fiveButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            fiveButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("5")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func sixButtonPressed(_ sender: Any) {
        sixButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            sixButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("6")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func sevenButtonPressed(_ sender: Any) {
        sevenButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            sevenButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("7")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func eightButtonPressed(_ sender: Any) {
        eightButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            eightButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("8")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func nineButtonPressed(_ sender: Any) {
        nineButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            nineButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericTrue()
        if numberLabel.text!.count > 12 { return }
        if numberLabel2.text!.count > 12 { return }
        numberLabel.text?.append("9")
        let number = Int(numberLabel.text!)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
        numberLabel2.text = result
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        clearButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            clearButton.backgroundColor = UIColor(named: O_BLACK)
        }
        numberLabel.text = "0"
        numberLabel2.text = "0"
        firstNumeric = false
        lastNumeric = false
        removeUserDefaults()
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        plusButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            plusButton.backgroundColor = .darkGray
        }
        if UserDefaults.standard.object(forKey: PLUS) == nil {
            UserDefaults.standard.set(Int(numberLabel.text!), forKey: PLUS)
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        minusButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            minusButton.backgroundColor = .darkGray
        }
        if UserDefaults.standard.object(forKey: MINUS) == nil {
            UserDefaults.standard.set(Int(numberLabel.text!), forKey: MINUS)
        }
    }
    
    @IBAction func multiplyButtonPressed(_ sender: Any) {
        multiplyButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            multiplyButton.backgroundColor = .darkGray
        }
        if UserDefaults.standard.object(forKey: MULTIPLY) == nil {
            UserDefaults.standard.set(Int(numberLabel.text!), forKey: MULTIPLY)
        }
    }
    
    @IBAction func divideButtonPressed(_ sender: Any) {
        devideButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            devideButton.backgroundColor = .darkGray
        }
        if UserDefaults.standard.object(forKey: DEVIDE) == nil {
            UserDefaults.standard.set(Int(numberLabel.text!), forKey: DEVIDE)
        }
    }
    
    @IBAction func equalButtonPressd(_ sender: Any) {
        equalButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            equalButton.backgroundColor = .systemOrange
        }
        
        if UserDefaults.standard.object(forKey: PLUS) != nil {
            let numeric = UserDefaults.standard.object(forKey: PLUS)
            let lastNumeric = Int(numberLabel.text!)
            let totalNumeric = numeric as! Int + lastNumeric!
            
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: totalNumeric))!
            numberLabel2.text = result
            numberLabel.text = String(totalNumeric)
            if numberLabel.text!.count > 11 && numberLabel2.text!.count > 11 {
                numberLabel.text = "99999999999"
                numberLabel2.text = "99,999,999,999"
            }
        }
        
        if UserDefaults.standard.object(forKey: MINUS) != nil {
            let numeric = UserDefaults.standard.object(forKey: MINUS)
            let lastNumeric = Int(numberLabel.text!)
            var totalNumeric = numeric as! Int - lastNumeric!
            if totalNumeric <= 0 {
                totalNumeric = 0
                firstNumeric = false
            }
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: totalNumeric))!
            numberLabel2.text = result
            numberLabel.text = String(totalNumeric)
        }
        
        if UserDefaults.standard.object(forKey: MULTIPLY) != nil {
            let numeric = UserDefaults.standard.object(forKey: MULTIPLY)
            let lastNumeric = Int(numberLabel.text!)
            let totalNumeric = numeric as! Int * lastNumeric!
            
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: totalNumeric))!
            numberLabel2.text = result
            numberLabel.text = String(totalNumeric)
            if numberLabel.text!.count > 11 && numberLabel2.text!.count > 11 {
                numberLabel.text = "99999999999"
                numberLabel2.text = "99,999,999,999"
            }
        }
        
        if UserDefaults.standard.object(forKey: DEVIDE) != nil {
            let numeric = UserDefaults.standard.object(forKey: DEVIDE)
            let lastNumeric = Int(numberLabel.text!)
            guard lastNumeric != 0 else { return }
            let totalNumeric = numeric as! Int / lastNumeric!
            if totalNumeric == 0 { firstNumeric = false }
            
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: totalNumeric))!
            numberLabel2.text = result
            numberLabel.text = String(totalNumeric)
        }
        removeUserDefaults()
        lastNumeric = false
    }
    
    // MARK: - Update spending
    
    private func updateSpending() {
        
        let realm = try! Realm()
        let spending = realm.objects(Spending.self).filter("id = '\(id)'")
        
        let calendar = Calendar.current
        let firstDateComp = calendar.date(from: DateComponents(year: Int(year2), month: Int(month2)!, day: 1))
        let comps = calendar.dateComponents([.year, .month,], from: firstDateComp!)
        let firstday = calendar.date(from: comps)
        let add = DateComponents(month: 1, day: -1)
        let lastday = calendar.date(byAdding: add, to: firstday!)
        
        var yearMonthTotal: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月合計"
            return dateFormatter.string(from: firstDateComp!)
        }
        var firstDayString: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "M月d日"
            return dateFormatter.string(from: firstDateComp!)
        }
        var lastDayString: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "M月d日"
            return dateFormatter.string(from: lastday!)
        }
        spending.forEach { (spending) in
            
            if autofillSwitch.isOn {
                let auto = Auto()
                let id = UUID().uuidString
                conversionDay(auto, day2)
                auto.id = id
                auto.price = Int(numberLabel.text!) ?? 0
                auto.category = categoryLabel.text ?? ""
                auto.memo = textField.text ?? ""
                auto.payment = "支出"
                auto.timestamp = dateLabel.text ?? ""
                auto.date = yyyy_mm_dd2
                auto.isInput = true
                auto.onRegister = true
                auto.isRegister = true
                auto.year = Int(self.year2) ?? 0
                auto.month = Int(self.month2) ?? 0
                auto.day = Int(self.day2) ?? 0
                
                try! realm.write {
                    realm.add(auto)
                }
                
                try! realm.write {
                    spendingData(spending)
                    spending.isAutofill = true
                }
            } else {
                try! realm.write {
                    spendingData(spending)
                }
            }
            
            if spending.category == "食費" {
                updateFood(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "日用品" {
                updateBrush(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "趣味" {
                updateHobby(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "交際費" {
                updateDating(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "交通費" {
                updateTraffic(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "衣服・美容" {
                updateClothe(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "健康・医療" {
                updateHealth(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "自動車" {
                updateCar(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "教養・教育" {
                updateEducation(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "特別な支出" {
                updateSpecial(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "現金・カード" {
                updateCard(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "水道・光熱費" {
                updateUtility(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "通信費" {
                updateCommunicaton(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "住宅" {
                updateHouse(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "税・社会保険" {
                updateTax(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "保険" {
                updateInsrance(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "その他" {
                updateEtcetora(spending, yearMonthTotal, firstDayString, lastDayString)
            } else if spending.category == "未分類" {
                updateUnCategory(spending, yearMonthTotal, firstDayString, lastDayString)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func spendingData(_ spending: Spending) {
        
        spending.price = Int(numberLabel.text!) ?? 0
        spending.category = categoryLabel.text ?? ""
        spending.memo = textField.text ?? ""
        spending.timestamp = dateLabel.text ?? ""
        spending.date = yyyy_mm_dd2
        spending.year = year2
        spending.month = month2
        spending.day = day2
    }
    
    private func updateFood(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let food = realm.objects(Food.self).filter("id = '\(id)'")
        
        food.forEach { (food) in
            let mFood = realm.objects(MonthlyFood.self).filter("year == '\(food.year)'").filter("month == '\(food.month)'")
            
            mFood.forEach { (mData) in
                /* mFoodの年と選択年が等しくない && mFoodの月と選択月が等しくない
                   mFoodの年と選択年が等しい && mFoodの月と選択月が等しくない
                   mFoodの年と選択年が等しくない && mFoodの月と選択月が等しい */
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mFood2 = realm.objects(MonthlyFood.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mFood2.count == 0 {
                        let mFood2 = MonthlyFood()
                        mFood2.totalPrice = Int(numberLabel.text!) ?? 0
                        mFood2.category = "食費"
                        mFood2.timestamp = yearMonthTotal
                        mFood2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mFood2.date = yyyy_mm2
                        mFood2.year = year2
                        mFood2.month = month2
                        try! realm.write() {
                            realm.add(mFood2)
                        }
                    } else {
                        mFood2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - food.price
                        if mData.totalPrice <= 0 {
                            realm.delete(mFood)
                        }
                    }
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - food.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    food.price = Int(numberLabel.text!) ?? 0
                    food.category = categoryLabel.text ?? ""
                    food.memo = textField.text ?? ""
                    food.timestamp = dateLabel.text ?? ""
                    food.year = year2
                    food.month = month2
                    food.day = day2
                }
            }
        }
    }
    
    private func updateBrush(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let brush = realm.objects(Brush.self).filter("id = '\(id)'")
        brush.forEach { (brush) in
            let mBrush = realm.objects(MonthlyBrush.self).filter("year == '\(brush.year)'").filter("month == '\(brush.month)'")
            
            mBrush.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mBrush2 = realm.objects(MonthlyBrush.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mBrush2.count == 0 {
                        let mBrush2 = MonthlyBrush()
                        mBrush2.totalPrice = Int(numberLabel.text!) ?? 0
                        mBrush2.category = "日用品"
                        mBrush2.timestamp = yearMonthTotal
                        mBrush2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mBrush2.date = yyyy_mm2
                        mBrush2.year = year2
                        mBrush2.month = month2
                        try! realm.write() {
                            realm.add(mBrush2)
                        }
                    } else {
                        mBrush2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - brush.price
                        if mData.totalPrice == 0 {
                            realm.delete(mBrush)
                        }
                    }
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - brush.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    brush.price = Int(numberLabel.text!) ?? 0
                    brush.category = categoryLabel.text ?? ""
                    brush.memo = textField.text ?? ""
                    brush.timestamp = dateLabel.text ?? ""
                    brush.year = year2
                    brush.month = month2
                    brush.day = day2
                }
            }
        }
    }
    
    private func updateHobby(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let hobby = realm.objects(Hobby.self).filter("id = '\(id)'")
        hobby.forEach { (hobby) in
            let mHobby = realm.objects(MonthlyHobby.self).filter("year == '\(hobby.year)'").filter("month == '\(hobby.month)'")
            
            mHobby.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mHobby2 = realm.objects(MonthlyHobby.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mHobby2.count == 0 {
                        let mHobby2 = MonthlyHobby()
                        mHobby2.totalPrice = Int(numberLabel.text!) ?? 0
                        mHobby2.category = "趣味"
                        mHobby2.timestamp = yearMonthTotal
                        mHobby2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mHobby2.date = yyyy_mm2
                        mHobby2.year = year2
                        mHobby2.month = month2
                        try! realm.write() {
                            realm.add(mHobby2)
                        }
                    } else {
                        mHobby2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - hobby.price
                        if mData.totalPrice == 0 {
                            realm.delete(mHobby)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - hobby.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    hobby.price = Int(numberLabel.text!) ?? 0
                    hobby.category = categoryLabel.text ?? ""
                    hobby.memo = textField.text ?? ""
                    hobby.timestamp = dateLabel.text ?? ""
                    hobby.year = year2
                    hobby.month = month2
                    hobby.day = day2
                }
            }
        }
    }
    
    private func updateDating(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let dating = realm.objects(Dating.self).filter("id = '\(id)'")
        dating.forEach { (dating) in
            let mDating = realm.objects(MonthlyDating.self).filter("year == '\(dating.year)'").filter("month == '\(dating.month)'")
            
            mDating.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mDating2 = realm.objects(MonthlyDating.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mDating2.count == 0 {
                        let mDating2 = MonthlyDating()
                        mDating2.totalPrice = Int(numberLabel.text!) ?? 0
                        mDating2.category = "交際費"
                        mDating2.timestamp = yearMonthTotal
                        mDating2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mDating2.date = yyyy_mm2
                        mDating2.year = year2
                        mDating2.month = month2
                        try! realm.write() {
                            realm.add(mDating2)
                        }
                    } else {
                        mDating2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - dating.price
                        if mData.totalPrice == 0 {
                            realm.delete(mDating)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - dating.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    dating.price = Int(numberLabel.text!) ?? 0
                    dating.category = categoryLabel.text ?? ""
                    dating.memo = textField.text ?? ""
                    dating.timestamp = dateLabel.text ?? ""
                    dating.year = year2
                    dating.month = month2
                    dating.day = day2
                }
            }
        }
    }
    
    private func updateTraffic(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let traffic = realm.objects(Traffic.self).filter("id = '\(id)'")
        traffic.forEach { (traffic) in
            let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(traffic.year)'").filter("month == '\(traffic.month)'")
            
            mTraffic.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mTraffic2 = realm.objects(MonthlyTraffic.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mTraffic2.count == 0 {
                        let mTraffic2 = MonthlyTraffic()
                        mTraffic2.totalPrice = Int(numberLabel.text!) ?? 0
                        mTraffic2.category = "交通費"
                        mTraffic2.timestamp = yearMonthTotal
                        mTraffic2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mTraffic2.date = yyyy_mm2
                        mTraffic2.year = year2
                        mTraffic2.month = month2
                        try! realm.write() {
                            realm.add(mTraffic2)
                        }
                    } else {
                        mTraffic2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - traffic.price
                        if mData.totalPrice == 0 {
                            realm.delete(mTraffic)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - traffic.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    traffic.price = Int(numberLabel.text!) ?? 0
                    traffic.category = categoryLabel.text ?? ""
                    traffic.memo = textField.text ?? ""
                    traffic.timestamp = dateLabel.text ?? ""
                    traffic.year = year2
                    traffic.month = month2
                    traffic.day = day2
                }
            }
        }
    }
    
    private func updateClothe(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let clothe = realm.objects(Clothe.self).filter("id = '\(id)'")
        clothe.forEach { (clothe) in
            let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(clothe.year)'").filter("month == '\(clothe.month)'")
            
            mClothe.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mClothe2 = realm.objects(MonthlyClothe.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mClothe2.count == 0 {
                        let mClothe2 = MonthlyClothe()
                        mClothe2.totalPrice = Int(numberLabel.text!) ?? 0
                        mClothe2.category = "衣服・美容"
                        mClothe2.timestamp = yearMonthTotal
                        mClothe2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mClothe2.date = yyyy_mm2
                        mClothe2.year = year2
                        mClothe2.month = month2
                        try! realm.write() {
                            realm.add(mClothe2)
                        }
                    } else {
                        mClothe2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - clothe.price
                        if mData.totalPrice == 0 {
                            realm.delete(mClothe)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - clothe.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    clothe.price = Int(numberLabel.text!) ?? 0
                    clothe.category = categoryLabel.text ?? ""
                    clothe.memo = textField.text ?? ""
                    clothe.timestamp = dateLabel.text ?? ""
                    clothe.year = year2
                    clothe.month = month2
                    clothe.day = day2
                }
            }
        }
    }
    
    private func updateHealth(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let health = realm.objects(Health.self).filter("id = '\(id)'")
        health.forEach { (health) in
            let mHealth = realm.objects(MonthlyHealth.self).filter("year == '\(health.year)'").filter("month == '\(health.month)'")
            
            mHealth.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mHealth2 = realm.objects(MonthlyHealth.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mHealth2.count == 0 {
                        let mHealth2 = MonthlyHealth()
                        mHealth2.totalPrice = Int(numberLabel.text!) ?? 0
                        mHealth2.category = "健康・医療"
                        mHealth2.timestamp = yearMonthTotal
                        mHealth2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mHealth2.date = yyyy_mm2
                        mHealth2.year = year2
                        mHealth2.month = month2
                        try! realm.write() {
                            realm.add(mHealth2)
                        }
                    } else {
                        mHealth2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - health.price
                        if mData.totalPrice == 0 {
                            realm.delete(mHealth)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - health.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    health.price = Int(numberLabel.text!) ?? 0
                    health.category = categoryLabel.text ?? ""
                    health.memo = textField.text ?? ""
                    health.timestamp = dateLabel.text ?? ""
                    health.year = year2
                    health.month = month2
                    health.day = day2
                }
            }
        }
    }
    
    private func updateCar(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let car = realm.objects(Car.self).filter("id = '\(id)'")
        car.forEach { (car) in
            let mCar = realm.objects(MonthlyCar.self).filter("year == '\(car.year)'").filter("month == '\(car.month)'")
            
            mCar.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mCar2 = realm.objects(MonthlyCar.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mCar2.count == 0 {
                        let mCar2 = MonthlyCar()
                        mCar2.totalPrice = Int(numberLabel.text!) ?? 0
                        mCar2.category = "自動車"
                        mCar2.timestamp = yearMonthTotal
                        mCar2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mCar2.date = yyyy_mm2
                        mCar2.year = year2
                        mCar2.month = month2
                        try! realm.write() {
                            realm.add(mCar2)
                        }
                    } else {
                        mCar2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - car.price
                        if mData.totalPrice == 0 {
                            realm.delete(mCar)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - car.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    car.price = Int(numberLabel.text!) ?? 0
                    car.category = categoryLabel.text ?? ""
                    car.memo = textField.text ?? ""
                    car.timestamp = dateLabel.text ?? ""
                    car.year = year2
                    car.month = month2
                    car.day = day2
                }
            }
        }
    }
    
    private func updateEducation(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let education = realm.objects(Education.self).filter("id = '\(id)'")
        education.forEach { (education) in
            let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(education.year)'").filter("month == '\(education.month)'")
            
            mEducation.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mEducation2 = realm.objects(MonthlyEducation.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mEducation2.count == 0 {
                        let mEducation2 = MonthlyEducation()
                        mEducation2.totalPrice = Int(numberLabel.text!) ?? 0
                        mEducation2.category = "教養・教育"
                        mEducation2.timestamp = yearMonthTotal
                        mEducation2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mEducation2.date = yyyy_mm2
                        mEducation2.year = year2
                        mEducation2.month = month2
                        try! realm.write() {
                            realm.add(mEducation2)
                        }
                    } else {
                        mEducation2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - education.price
                        if mData.totalPrice == 0 {
                            realm.delete(mEducation)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - education.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    education.price = Int(numberLabel.text!) ?? 0
                    education.category = categoryLabel.text ?? ""
                    education.memo = textField.text ?? ""
                    education.timestamp = dateLabel.text ?? ""
                    education.year = year2
                    education.month = month2
                    education.day = day2
                }
            }
        }
    }
    
    private func updateSpecial(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let special = realm.objects(Special.self).filter("id = '\(id)'")
        special.forEach { (special) in
            let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(special.year)'").filter("month == '\(special.month)'")
            
            mSpecial.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mSpecial2 = realm.objects(MonthlySpecial.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mSpecial2.count == 0 {
                        let mSpecial2 = MonthlySpecial()
                        mSpecial2.totalPrice = Int(numberLabel.text!) ?? 0
                        mSpecial2.category = "特別な支出"
                        mSpecial2.timestamp = yearMonthTotal
                        mSpecial2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mSpecial2.date = yyyy_mm2
                        mSpecial2.year = year2
                        mSpecial2.month = month2
                        try! realm.write() {
                            realm.add(mSpecial2)
                        }
                    } else {
                        mSpecial2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - special.price
                        if mData.totalPrice == 0 {
                            realm.delete(mSpecial)
                        }
                    }
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - special.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    special.price = Int(numberLabel.text!) ?? 0
                    special.category = categoryLabel.text ?? ""
                    special.memo = textField.text ?? ""
                    special.timestamp = dateLabel.text ?? ""
                    special.year = year2
                    special.month = month2
                    special.day = day2
                }
            }
        }
    }
    
    private func updateCard(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let card = realm.objects(Card.self).filter("id = '\(id)'")
        card.forEach { (card) in
            let mCard = realm.objects(MonthlyCard.self).filter("year == '\(card.year)'").filter("month == '\(card.month)'")
            
            mCard.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mCard2 = realm.objects(MonthlyCard.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mCard2.count == 0 {
                        let mCard2 = MonthlyCard()
                        mCard2.totalPrice = Int(numberLabel.text!) ?? 0
                        mCard2.category = "現金・カード"
                        mCard2.timestamp = yearMonthTotal
                        mCard2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mCard2.date = yyyy_mm2
                        mCard2.year = year2
                        mCard2.month = month2
                        try! realm.write() {
                            realm.add(mCard2)
                        }
                    } else {
                        mCard2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - card.price
                        if mData.totalPrice == 0 {
                            realm.delete(mCard)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - card.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    card.price = Int(numberLabel.text!) ?? 0
                    card.category = categoryLabel.text ?? ""
                    card.memo = textField.text ?? ""
                    card.timestamp = dateLabel.text ?? ""
                    card.year = year2
                    card.month = month2
                    card.day = day2
                }
            }
        }
    }
    
    private func updateUtility(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let utility = realm.objects(Utility.self).filter("id = '\(id)'")
        utility.forEach { (utility) in
            let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(utility.year)'").filter("month == '\(utility.month)'")
            
            mUtility.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mUtility2 = realm.objects(MonthlyUtility.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mUtility2.count == 0 {
                        let mUtility2 = MonthlyUtility()
                        mUtility2.totalPrice = Int(numberLabel.text!) ?? 0
                        mUtility2.category = "水道・光熱費"
                        mUtility2.timestamp = yearMonthTotal
                        mUtility2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mUtility2.date = yyyy_mm2
                        mUtility2.year = year2
                        mUtility2.month = month2
                        try! realm.write() {
                            realm.add(mUtility2)
                        }
                    } else {
                        mUtility2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - utility.price
                        if mData.totalPrice == 0 {
                            realm.delete(mUtility)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - utility.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    utility.price = Int(numberLabel.text!) ?? 0
                    utility.category = categoryLabel.text ?? ""
                    utility.memo = textField.text ?? ""
                    utility.timestamp = dateLabel.text ?? ""
                    utility.year = year2
                    utility.month = month2
                    utility.day = day2
                }
            }
        }
    }
    
    private func updateCommunicaton(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let communication = realm.objects(Communicaton.self).filter("id = '\(id)'")
        communication.forEach { (communication) in
            let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(communication.year)'").filter("month == '\(communication.month)'")
            
            mCommunication.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mCommunication2 = realm.objects(MonthlyCommunication.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mCommunication2.count == 0 {
                        let mCommunication2 = MonthlyCommunication()
                        mCommunication2.totalPrice = Int(numberLabel.text!) ?? 0
                        mCommunication2.category = "通信費"
                        mCommunication2.timestamp = yearMonthTotal
                        mCommunication2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mCommunication2.date = yyyy_mm2
                        mCommunication2.year = year2
                        mCommunication2.month = month2
                        try! realm.write() {
                            realm.add(mCommunication2)
                        }
                    } else {
                        mCommunication2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - communication.price
                        if mData.totalPrice == 0 {
                            realm.delete(mCommunication)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - communication.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    communication.price = Int(numberLabel.text!) ?? 0
                    communication.category = categoryLabel.text ?? ""
                    communication.memo = textField.text ?? ""
                    communication.timestamp = dateLabel.text ?? ""
                    communication.year = year2
                    communication.month = month2
                    communication.day = day2
                }
            }
        }
    }
    
    private func updateHouse(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let house = realm.objects(House.self).filter("id = '\(id)'")
        house.forEach { (house) in
            let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(house.year)'").filter("month == '\(house.month)'")
            
            mHouse.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mHouse2 = realm.objects(MonthlyHouse.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mHouse2.count == 0 {
                        let mHouse2 = MonthlyHouse()
                        mHouse2.totalPrice = Int(numberLabel.text!) ?? 0
                        mHouse2.category = "住宅"
                        mHouse2.timestamp = yearMonthTotal
                        mHouse2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mHouse2.date = yyyy_mm2
                        mHouse2.year = year2
                        mHouse2.month = month2
                        try! realm.write() {
                            realm.add(mHouse2)
                        }
                    } else {
                        mHouse2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - house.price
                        if mData.totalPrice == 0 {
                            realm.delete(mHouse)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - house.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    house.price = Int(numberLabel.text!) ?? 0
                    house.category = categoryLabel.text ?? ""
                    house.memo = textField.text ?? ""
                    house.timestamp = dateLabel.text ?? ""
                    house.year = year2
                    house.month = month2
                    house.day = day2
                }
            }
        }
    }
    
    private func updateTax(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let tax = realm.objects(Tax.self).filter("id = '\(id)'")
        tax.forEach { (tax) in
            let mTax = realm.objects(MonthlyTax.self).filter("year == '\(tax.year)'").filter("month == '\(tax.month)'")
            
            mTax.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mTax2 = realm.objects(MonthlyTax.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mTax2.count == 0 {
                        let mTax2 = MonthlyTax()
                        mTax2.totalPrice = Int(numberLabel.text!) ?? 0
                        mTax2.category = "税・社会保険"
                        mTax2.timestamp = yearMonthTotal
                        mTax2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mTax2.date = yyyy_mm2
                        mTax2.year = year2
                        mTax2.month = month2
                        try! realm.write() {
                            realm.add(mTax2)
                        }
                    } else {
                        mTax2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - tax.price
                        if mData.totalPrice == 0 {
                            realm.delete(mTax)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - tax.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    tax.price = Int(numberLabel.text!) ?? 0
                    tax.category = categoryLabel.text ?? ""
                    tax.memo = textField.text ?? ""
                    tax.timestamp = dateLabel.text ?? ""
                    tax.year = year2
                    tax.month = month2
                    tax.day = day2
                }
            }
        }
    }
    
    private func updateInsrance(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let insrance = realm.objects(Insrance.self).filter("id = '\(id)'")
        insrance.forEach { (insrance) in
            let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(insrance.year)'").filter("month == '\(insrance.month)'")
            
            mInsrance.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mInsrance2 = realm.objects(MonthlyInsrance.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mInsrance2.count == 0 {
                        let mInsrance2 = MonthlyInsrance()
                        mInsrance2.totalPrice = Int(numberLabel.text!) ?? 0
                        mInsrance2.category = "保険"
                        mInsrance2.timestamp = yearMonthTotal
                        mInsrance2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mInsrance2.date = yyyy_mm2
                        mInsrance2.year = year2
                        mInsrance2.month = month2
                        try! realm.write() {
                            realm.add(mInsrance2)
                        }
                    } else {
                        mInsrance2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - insrance.price
                        if mData.totalPrice == 0 {
                            realm.delete(mInsrance)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - insrance.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    insrance.price = Int(numberLabel.text!) ?? 0
                    insrance.category = categoryLabel.text ?? ""
                    insrance.memo = textField.text ?? ""
                    insrance.timestamp = dateLabel.text ?? ""
                    insrance.year = year2
                    insrance.month = month2
                    insrance.day = day2
                }
            }
        }
    }
    
    private func updateEtcetora(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let etcetra = realm.objects(Etcetora.self).filter("id = '\(id)'")
        etcetra.forEach { (etcetra) in
            let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(etcetra.year)'").filter("month == '\(etcetra.month)'")
            
            mEtcetora.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mEtcetora2 = realm.objects(MonthlyEtcetora.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mEtcetora2.count == 0 {
                        let mEtcetora2 = MonthlyEtcetora()
                        mEtcetora2.totalPrice = Int(numberLabel.text!) ?? 0
                        mEtcetora2.category = "その他"
                        mEtcetora2.timestamp = yearMonthTotal
                        mEtcetora2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mEtcetora2.date = yyyy_mm2
                        mEtcetora2.year = year2
                        mEtcetora2.month = month2
                        try! realm.write() {
                            realm.add(mEtcetora2)
                        }
                    } else {
                        mEtcetora2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - etcetra.price
                        if mData.totalPrice == 0 {
                            realm.delete(mEtcetora)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - etcetra.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    etcetra.price = Int(numberLabel.text!) ?? 0
                    etcetra.category = categoryLabel.text ?? ""
                    etcetra.memo = textField.text ?? ""
                    etcetra.timestamp = dateLabel.text ?? ""
                    etcetra.year = year2
                    etcetra.month = month2
                    etcetra.day = day2
                }
            }
        }
    }
    
    private func updateUnCategory(_ spending: Spending, _ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let id = spending.id
        let unCategory = realm.objects(UnCategory.self).filter("id = '\(id)'")
        unCategory.forEach { (unCategory) in
            let mUnCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(unCategory.year)'").filter("month == '\(unCategory.month)'")
            
            mUnCategory.forEach { (mData) in
                if mData.year != year2 && mData.month != month2 || mData.year == year2 && mData.month != month2 || mData.year != year2 && mData.month == month2 {
                    let mUnCategory2 = realm.objects(MonthlyUnCategory.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
                    
                    if mUnCategory2.count == 0 {
                        let mUnCategory2 = MonthlyUnCategory()
                        mUnCategory2.totalPrice = Int(numberLabel.text!) ?? 0
                        mUnCategory2.category = "未分類"
                        mUnCategory2.timestamp = yearMonthTotal
                        mUnCategory2.monthly = "(\(firstDayString)~\(lastDayString))"
                        mUnCategory2.date = yyyy_mm2
                        mUnCategory2.year = year2
                        mUnCategory2.month = month2
                        try! realm.write() {
                            realm.add(mUnCategory2)
                        }
                    } else {
                        mUnCategory2.forEach { (mData2) in
                            try! realm.write() {
                                mData2.totalPrice = mData2.totalPrice + Int(numberLabel.text!)!
                            }
                        }
                    }
                    
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - unCategory.price
                        if mData.totalPrice == 0 {
                            realm.delete(mUnCategory)
                        }
                    }
                    
                } else {
                    try! realm.write {
                        mData.totalPrice = mData.totalPrice - unCategory.price
                        mData.totalPrice = mData.totalPrice + Int(numberLabel.text!)!
                    }
                }
                try! realm.write {
                    unCategory.price = Int(numberLabel.text!) ?? 0
                    unCategory.category = categoryLabel.text ?? ""
                    unCategory.memo = textField.text ?? ""
                    unCategory.timestamp = dateLabel.text ?? ""
                    unCategory.year = year2
                    unCategory.month = month2
                    unCategory.day = day2
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setCategory() {
        
        if UserDefaults.standard.object(forKey: FOOD) != nil {
            categoryLabel.text = "食費"
            categoryImageView.image = UIImage(named: "food")
            UserDefaults.standard.removeObject(forKey: FOOD)
        } else if UserDefaults.standard.object(forKey: NECESSITIES) != nil {
            categoryLabel.text = "日用品"
            categoryImageView.image = UIImage(named: "brush")
            UserDefaults.standard.removeObject(forKey: NECESSITIES)
        } else if UserDefaults.standard.object(forKey: HOBBY) != nil {
            categoryLabel.text = "趣味"
            categoryImageView.image = UIImage(named: "hobby")
            UserDefaults.standard.removeObject(forKey: HOBBY)
        } else if UserDefaults.standard.object(forKey: DATING) != nil {
            categoryLabel.text = "交際費"
            categoryImageView.image = UIImage(named: "dating")
            UserDefaults.standard.removeObject(forKey: DATING)
        } else if UserDefaults.standard.object(forKey: TRAFFIC) != nil {
            categoryLabel.text = "交通費"
            categoryImageView.image = UIImage(named: "traffic")
            UserDefaults.standard.removeObject(forKey: TRAFFIC)
        } else if UserDefaults.standard.object(forKey: CLOTHES) != nil {
            categoryLabel.text = "衣服・美容"
            categoryImageView.image = UIImage(named: "clothe")
            UserDefaults.standard.removeObject(forKey: CLOTHES)
        } else if UserDefaults.standard.object(forKey: HEALTH) != nil {
            categoryLabel.text = "健康・医療"
            categoryImageView.image = UIImage(named: "health")
            UserDefaults.standard.removeObject(forKey: HEALTH)
        } else if UserDefaults.standard.object(forKey: CAR) != nil {
            categoryLabel.text = "自動車"
            categoryImageView.image = UIImage(named: "car")
            UserDefaults.standard.removeObject(forKey: CAR)
        } else if UserDefaults.standard.object(forKey: EDUCATION) != nil {
            categoryLabel.text = "教養・教育"
            categoryImageView.image = UIImage(named: "education")
            UserDefaults.standard.removeObject(forKey: EDUCATION)
        } else if UserDefaults.standard.object(forKey: SPECIAL) != nil {
            categoryLabel.text = "特別な支出"
            categoryImageView.image = UIImage(named: "special")
            UserDefaults.standard.removeObject(forKey: SPECIAL)
        } else if UserDefaults.standard.object(forKey: CARD) != nil {
            categoryLabel.text = "現金・カード"
            categoryImageView.image = UIImage(named: "card")
            UserDefaults.standard.removeObject(forKey: CARD)
        } else if UserDefaults.standard.object(forKey: UTILITY) != nil {
            categoryLabel.text = "水道・光熱費"
            categoryImageView.image = UIImage(named: "utility")
            UserDefaults.standard.removeObject(forKey: UTILITY)
        } else if UserDefaults.standard.object(forKey: COMMUNICATION) != nil {
            categoryLabel.text = "通信費"
            categoryImageView.image = UIImage(named: "communication")
            UserDefaults.standard.removeObject(forKey: COMMUNICATION)
        } else if UserDefaults.standard.object(forKey: HOUSE) != nil {
            categoryLabel.text = "住宅"
            categoryImageView.image = UIImage(named: "house")
            UserDefaults.standard.removeObject(forKey: HOUSE)
        } else if UserDefaults.standard.object(forKey: TAX) != nil {
            categoryLabel.text = "税・社会保険"
            categoryImageView.image = UIImage(named: "tax")
            UserDefaults.standard.removeObject(forKey: TAX)
        } else if UserDefaults.standard.object(forKey: INSRACE) != nil {
            categoryLabel.text = "保険"
            categoryImageView.image = UIImage(named: "insrance")
            UserDefaults.standard.removeObject(forKey: INSRACE)
        } else if UserDefaults.standard.object(forKey: ETCETRA) != nil {
            categoryLabel.text = "その他"
            categoryImageView.image = UIImage(named: "etcetra")
            UserDefaults.standard.removeObject(forKey: ETCETRA)
        } else if UserDefaults.standard.object(forKey: UN_CATEGORY) != nil {
            categoryLabel.text = "未分類"
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            UserDefaults.standard.removeObject(forKey: UN_CATEGORY)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        dateFormatter.locale = Locale(identifier: "ja_JP")
        var timestamp: String {
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: date)
        }
        var yyyy_mm_dd: String {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        var yyyy_mm: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM"
            return dateFormatter.string(from: date)
        }
        var year: String {
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        }
        var month: String {
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: date)
        }
        var day: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }
        
        dateLabel.text = timestamp
        yyyy_mm_dd2 = yyyy_mm_dd
        yyyy_mm2 = yyyy_mm
        year2 = year
        month2 = month
        day2 = day
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.5) {
                    self.calender.isHidden = true
                }
            }
            break
        default:
            break
        }
    }
    
    func judgeHoliday(_ date : Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return UIColor.red
        }
        else if weekday == 7 {
            return UIColor.blue
        }
        return nil
    }
    
    private func isNumericAndValidate() {
        isNumericTrue()
        if numberLabel.text!.count > 10 {
            return
        }
    }
    
    private func isNumericTrue() {
        
        if !lastNumeric {
            if UserDefaults.standard.object(forKey: PLUS) != nil || UserDefaults.standard.object(forKey: MINUS) != nil || UserDefaults.standard.object(forKey: MULTIPLY) != nil || UserDefaults.standard.object(forKey: DEVIDE) != nil {
                numberLabel.text = ""
                numberLabel2.text = ""
                lastNumeric = true
            }
        }
        
        if !firstNumeric {
            numberLabel.text = ""
            numberLabel2.text = ""
        }
        firstNumeric = true
    }
    
    private func setup() {
        
        numberLabel.isHidden = true
        textField.delegate = self
        deleteButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        buttons.forEach({ $0?.layer.borderWidth = 0.3; $0?.layer.borderColor = UIColor.systemGray.cgColor })
        textField.addTarget(self, action: #selector(textFieldTap), for: .editingDidBegin)
        
        calender.calendarWeekdayView.weekdayLabels[0].text = "日"
        calender.calendarWeekdayView.weekdayLabels[1].text = "月"
        calender.calendarWeekdayView.weekdayLabels[2].text = "火"
        calender.calendarWeekdayView.weekdayLabels[3].text = "水"
        calender.calendarWeekdayView.weekdayLabels[4].text = "木"
        calender.calendarWeekdayView.weekdayLabels[5].text = "金"
        calender.calendarWeekdayView.weekdayLabels[6].text = "土"
        navigationItem.title = "出金の修正"
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            numberLbl2TopConst.constant = 10
            numberLbl2BottomConst.constant = 10
            numberLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 30)
                enMarkLabel.font = UIFont(name: "HiraMaruProN-W4", size: 30)
            
            categoryImageTopConst.constant = 10
            categoryImageBottomConst.constant = 10
            calenderImageTopConst.constant = 10
            calenderImageBottomConst.constant = 10
            memoImageTopConst.constant = 10
            memoImageBottomConst.constant = 10
            calenderHeight.constant = 250
            
            break
        default:
            break
        }
    }
    
    private func removeUserDefaults() {
        
        UserDefaults.standard.removeObject(forKey: PLUS)
        UserDefaults.standard.removeObject(forKey: MINUS)
        UserDefaults.standard.removeObject(forKey: MULTIPLY)
        UserDefaults.standard.removeObject(forKey: DEVIDE)
    }
    
    @objc func textFieldTap() {
        calender.isHidden = true
        caluclatorView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
}

extension EditSpendingViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
