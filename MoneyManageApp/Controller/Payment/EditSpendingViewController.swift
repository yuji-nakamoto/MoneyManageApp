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
    
    lazy var buttons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, clearButton, multiplyButton, minusButton, plusButton, devideButton]
    private var firstNumeric = false
    private var lastNumeric = false
    private var year_month_day2 = ""
    private var year2 = ""
    private var month2 = ""
    private var day2 = ""
    
    var id = ""
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
            year_month_day2 = spending.date
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
                            let mCard = realm.objects(MonthlyFood.self).filter("year == '\(card.year)'").filter("month == '\(card.month)'")
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
                        navigationController?.popViewController(animated: true)
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
        navigationController?.popViewController(animated: true)
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
                auto.date = self.year_month_day2
                auto.isInput = true
                auto.onRegister = true
                auto.isRegister = true
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
                updateFood(spending)
            } else if spending.category == "日用品" {
                updateBrush(spending)
            } else if spending.category == "趣味" {
                updateHobby(spending)
            } else if spending.category == "交際費" {
                updateDating(spending)
            } else if spending.category == "交通費" {
                updateTraffic(spending)
            } else if spending.category == "衣服・美容" {
                updateClothe(spending)
            } else if spending.category == "健康・医療" {
                updateHealth(spending)
            } else if spending.category == "自動車" {
                updateCar(spending)
            } else if spending.category == "教養・教育" {
                updateEducation(spending)
            } else if spending.category == "特別な支出" {
                updateSpecial(spending)
            } else if spending.category == "現金・カード" {
                updateCard(spending)
            } else if spending.category == "水道・光熱費" {
                updateUtility(spending)
            } else if spending.category == "通信費" {
                updateCommunicaton(spending)
            } else if spending.category == "住宅" {
                updateHouse(spending)
            } else if spending.category == "税・社会保険" {
                updateTax(spending)
            } else if spending.category == "保険" {
                updateInsrance(spending)
            } else if spending.category == "その他" {
                updateEtcetora(spending)
            } else if spending.category == "未分類" {
                updateUnCategory(spending)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func spendingData(_ spending: Spending) {
        
        spending.price = Int(numberLabel.text!) ?? 0
        spending.category = categoryLabel.text ?? ""
        spending.memo = textField.text ?? ""
        spending.timestamp = dateLabel.text ?? ""
        spending.date = year_month_day2
        spending.year = year2
        spending.month = month2
        spending.day = day2
    }
    
    private func updateFood(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let food = realm.objects(Food.self).filter("id = '\(id)'")
        
        food.forEach { (food) in
            try! realm.write {
                let mFood = realm.objects(MonthlyFood.self).filter("year == '\(food.year)'").filter("month == '\(food.month)'")
                mFood.forEach { (mFood) in
                    mFood.totalPrice = mFood.totalPrice - food.price
                    mFood.totalPrice = mFood.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateBrush(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let brush = realm.objects(Brush.self).filter("id = '\(id)'")
        brush.forEach { (brush) in
            try! realm.write {
                let mBrush = realm.objects(MonthlyBrush.self).filter("year == '\(brush.year)'").filter("month == '\(brush.month)'")
                mBrush.forEach { (mBrush) in
                    mBrush.totalPrice = mBrush.totalPrice - brush.price
                    mBrush.totalPrice = mBrush.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateHobby(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let hobby = realm.objects(Hobby.self).filter("id = '\(id)'")
        hobby.forEach { (hobby) in
            try! realm.write {
                let mHobby = realm.objects(MonthlyHobby.self).filter("year == '\(hobby.year)'").filter("month == '\(hobby.month)'")
                mHobby.forEach { (mHobby) in
                    mHobby.totalPrice = mHobby.totalPrice - hobby.price
                    mHobby.totalPrice = mHobby.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateDating(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let dating = realm.objects(Dating.self).filter("id = '\(id)'")
        dating.forEach { (dating) in
            try! realm.write {
                let mDating = realm.objects(MonthlyDating.self).filter("year == '\(dating.year)'").filter("month == '\(dating.month)'")
                mDating.forEach { (mDating) in
                    mDating.totalPrice = mDating.totalPrice - dating.price
                    mDating.totalPrice = mDating.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateTraffic(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let traffic = realm.objects(Traffic.self).filter("id = '\(id)'")
        traffic.forEach { (traffic) in
            try! realm.write {
                let mTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(traffic.year)'").filter("month == '\(traffic.month)'")
                mTraffic.forEach { (mTraffic) in
                    mTraffic.totalPrice = mTraffic.totalPrice - traffic.price
                    mTraffic.totalPrice = mTraffic.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateClothe(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let clothe = realm.objects(Clothe.self).filter("id = '\(id)'")
        clothe.forEach { (clothe) in
            try! realm.write {
                let mClothe = realm.objects(MonthlyClothe.self).filter("year == '\(clothe.year)'").filter("month == '\(clothe.month)'")
                mClothe.forEach { (mClothe) in
                    mClothe.totalPrice = mClothe.totalPrice - clothe.price
                    mClothe.totalPrice = mClothe.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateHealth(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let health = realm.objects(Health.self).filter("id = '\(id)'")
        health.forEach { (health) in
            try! realm.write {
                let mHealth = realm.objects(MonthlyHealth.self).filter("year == '\(health.year)'").filter("month == '\(health.month)'")
                mHealth.forEach { (mHealth) in
                    mHealth.totalPrice = mHealth.totalPrice - health.price
                    mHealth.totalPrice = mHealth.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateCar(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let car = realm.objects(Car.self).filter("id = '\(id)'")
        car.forEach { (car) in
            try! realm.write {
                let mCar = realm.objects(MonthlyCar.self).filter("year == '\(car.year)'").filter("month == '\(car.month)'")
                mCar.forEach { (mCar) in
                    mCar.totalPrice = mCar.totalPrice - car.price
                    mCar.totalPrice = mCar.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateEducation(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let education = realm.objects(Education.self).filter("id = '\(id)'")
        education.forEach { (education) in
            try! realm.write {
                let mEducation = realm.objects(MonthlyEducation.self).filter("year == '\(education.year)'").filter("month == '\(education.month)'")
                mEducation.forEach { (mEducation) in
                    mEducation.totalPrice = mEducation.totalPrice - education.price
                    mEducation.totalPrice = mEducation.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateSpecial(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let special = realm.objects(Special.self).filter("id = '\(id)'")
        special.forEach { (special) in
            try! realm.write {
                let mSpecial = realm.objects(MonthlySpecial.self).filter("year == '\(special.year)'").filter("month == '\(special.month)'")
                mSpecial.forEach { (mSpecial) in
                    mSpecial.totalPrice = mSpecial.totalPrice - special.price
                    mSpecial.totalPrice = mSpecial.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateCard(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let card = realm.objects(Card.self).filter("id = '\(id)'")
        card.forEach { (card) in
            try! realm.write {
                let mCard = realm.objects(MonthlyCard.self).filter("year == '\(card.year)'").filter("month == '\(card.month)'")
                mCard.forEach { (mCard) in
                    mCard.totalPrice = mCard.totalPrice - card.price
                    mCard.totalPrice = mCard.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateUtility(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let utility = realm.objects(Utility.self).filter("id = '\(id)'")
        utility.forEach { (utility) in
            try! realm.write {
                let mUtility = realm.objects(MonthlyUtility.self).filter("year == '\(utility.year)'").filter("month == '\(utility.month)'")
                mUtility.forEach { (mUtility) in
                    mUtility.totalPrice = mUtility.totalPrice - utility.price
                    mUtility.totalPrice = mUtility.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateCommunicaton(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let communication = realm.objects(Communicaton.self).filter("id = '\(id)'")
        communication.forEach { (communication) in
            try! realm.write {
                let mCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(communication.year)'").filter("month == '\(communication.month)'")
                mCommunication.forEach { (mCommunication) in
                    mCommunication.totalPrice = mCommunication.totalPrice - communication.price
                    mCommunication.totalPrice = mCommunication.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateHouse(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let house = realm.objects(House.self).filter("id = '\(id)'")
        house.forEach { (house) in
            try! realm.write {
                let mHouse = realm.objects(MonthlyHouse.self).filter("year == '\(house.year)'").filter("month == '\(house.month)'")
                mHouse.forEach { (mHouse) in
                    mHouse.totalPrice = mHouse.totalPrice - house.price
                    mHouse.totalPrice = mHouse.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateTax(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let tax = realm.objects(Tax.self).filter("id = '\(id)'")
        tax.forEach { (tax) in
            try! realm.write {
                let mTax = realm.objects(MonthlyTax.self).filter("year == '\(tax.year)'").filter("month == '\(tax.month)'")
                mTax.forEach { (mTax) in
                    mTax.totalPrice = mTax.totalPrice - tax.price
                    mTax.totalPrice = mTax.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateInsrance(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let insrance = realm.objects(Insrance.self).filter("id = '\(id)'")
        insrance.forEach { (insrance) in
            try! realm.write {
                let mInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(insrance.year)'").filter("month == '\(insrance.month)'")
                mInsrance.forEach { (mInsrance) in
                    mInsrance.totalPrice = mInsrance.totalPrice - insrance.price
                    mInsrance.totalPrice = mInsrance.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateEtcetora(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let etcetra = realm.objects(Etcetora.self).filter("id = '\(id)'")
        etcetra.forEach { (etcetra) in
            try! realm.write {
                let mEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(etcetra.year)'").filter("month == '\(etcetra.month)'")
                mEtcetora.forEach { (mEtcetora) in
                    mEtcetora.totalPrice = mEtcetora.totalPrice - etcetra.price
                    mEtcetora.totalPrice = mEtcetora.totalPrice + Int(numberLabel.text!)!
                }
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
    
    private func updateUnCategory(_ spending: Spending) {
        
        let realm = try! Realm()
        let id = spending.id
        let unCategory = realm.objects(UnCategory.self).filter("id = '\(id)'")
        unCategory.forEach { (unCategory) in
            try! realm.write {
                let mUnCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(unCategory.year)'").filter("month == '\(unCategory.month)'")
                mUnCategory.forEach { (mUnCategory) in
                    mUnCategory.totalPrice = mUnCategory.totalPrice - unCategory.price
                    mUnCategory.totalPrice = mUnCategory.totalPrice + Int(numberLabel.text!)!
                }
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
        var date2: String {
            dateFormatter.dateFormat = "yyyy-MM-dd"
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
        year_month_day2 = date2
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
        buttons.forEach({ $0?.layer.borderWidth = 0.2; $0?.layer.borderColor = UIColor.systemGray.cgColor })
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
            caluclatorView.isHidden = true
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
