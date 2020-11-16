//
//  EditIncomeViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import PKHUD
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class EditIncomeViewController: UIViewController, UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
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
    lazy var salary = realm!.objects(Salary.self).filter("id = '\(id)'")
    lazy var temporary = realm!.objects(Temporary.self).filter("id = '\(id)'")
    lazy var business = realm!.objects(Business.self).filter("id = '\(id)'")
    lazy var pension = realm!.objects(Pension.self).filter("id = '\(id)'")
    lazy var devident = realm!.objects(Devident.self).filter("id = '\(id)'")
    lazy var estate = realm!.objects(Estate.self).filter("id = '\(id)'")
    lazy var payment = realm!.objects(Payment.self).filter("id = '\(id)'")
    lazy var unCategory2 = realm!.objects(UnCategory2.self).filter("id = '\(id)'")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchIncome()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCategory()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Fetch
    
    private func fetchIncome() {
        
        let realm = try! Realm()
        let income = realm.objects(Income.self).filter("id = '\(id)'")
        income.forEach { (income) in
            
            numberLabel.text = String(income.price)
            
            let number = Int(numberLabel.text!)
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
            numberLabel2.text = result
            categoryLabel.text = income.category
            dateLabel.text = income.timestamp
            textField.text = income.memo
            year_month_day2 = income.date
            year2 = income.year
            month2 = income.month
            day2 = income.day
            
            if income.isAutofill == true {
                autofillLabel.text = "自動入力に登録済み"
                autofillLabel.textColor = .systemGray
                autofillSwitch.isEnabled = false
            } else {
                autofillLabel.text = "自動入力に登録"
                autofillLabel.textColor = UIColor(named: O_BLACK)
                autofillSwitch.isEnabled = true
            }
            
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
    
    // MARK: - Delete
    
    @IBAction func deleteButtonPressd(_ sender: Any) {
        
        let realm = try! Realm()
        let income = realm.objects(Income.self).filter("id = '\(id)'")
        income.forEach { (income) in
            
            let alert = UIAlertController(title: income.category, message: "データを削除しますか？", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                try! realm.write {
                    if income.category == "給与" {
                        salary.forEach { (salary) in
                            let mSalary = realm.objects(MonthlySalary.self).filter("year == '\(salary.year)'").filter("month == '\(salary.month)'")
                            mSalary.forEach { (data) in
                                data.totalPrice = data.totalPrice - salary.price
                                if data.totalPrice == 0 {
                                    realm.delete(mSalary)
                                }
                            }
                        }
                        realm.delete(salary)
                    } else if income.category == "一時所得" {
                        temporary.forEach { (temporary) in
                            let mTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(temporary.year)'").filter("month == '\(temporary.month)'")
                            mTemporary.forEach { (data) in
                                data.totalPrice = data.totalPrice - temporary.price
                                if data.totalPrice == 0 {
                                    realm.delete(mTemporary)
                                }
                            }
                        }
                        realm.delete(temporary)
                    } else if income.category == "事業・副業" {
                        business.forEach { (business) in
                            let mBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(business.year)'").filter("month == '\(business.month)'")
                            mBusiness.forEach { (data) in
                                data.totalPrice = data.totalPrice - business.price
                                if data.totalPrice == 0 {
                                    realm.delete(mBusiness)
                                }
                            }
                        }
                        realm.delete(business)
                    } else if income.category == "年金" {
                        pension.forEach { (pension) in
                            let mPension = realm.objects(MonthlyPension.self).filter("year == '\(pension.year)'").filter("month == '\(pension.month)'")
                            mPension.forEach { (data) in
                                data.totalPrice = data.totalPrice - pension.price
                                if data.totalPrice == 0 {
                                    realm.delete(mPension)
                                }
                            }
                        }
                        realm.delete(pension)
                    } else if income.category == "配当所得" {
                        devident.forEach { (devident) in
                            let mDevident = realm.objects(MonthlyDevident.self).filter("year == '\(devident.year)'").filter("month == '\(devident.month)'")
                            mDevident.forEach { (data) in
                                data.totalPrice = data.totalPrice - devident.price
                                if data.totalPrice == 0 {
                                    realm.delete(mDevident)
                                }
                            }
                        }
                        realm.delete(devident)
                    } else if income.category == "不動産所得" {
                        estate.forEach { (estate) in
                            let mEstate = realm.objects(MonthlyEstate.self).filter("year == '\(estate.year)'").filter("month == '\(estate.month)'")
                            mEstate.forEach { (data) in
                                data.totalPrice = data.totalPrice - estate.price
                                if data.totalPrice == 0 {
                                    realm.delete(mEstate)
                                }
                            }
                        }
                        realm.delete(estate)
                    } else if income.category == "その他入金" {
                        payment.forEach { (payment) in
                            let mPayment = realm.objects(MonthlyPayment.self).filter("year == '\(payment.year)'").filter("month == '\(payment.month)'")
                            mPayment.forEach { (data) in
                                data.totalPrice = data.totalPrice - payment.price
                                if data.totalPrice == 0 {
                                    realm.delete(mPayment)
                                }
                            }
                        }
                        realm.delete(payment)
                    } else if income.category == "未分類" {
                        unCategory2.forEach { (unCategory2) in
                            let mUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(unCategory2.year)'").filter("month == '\(unCategory2.month)'")
                            mUnCategory2.forEach { (data) in
                                data.totalPrice = data.totalPrice - unCategory2.price
                                if data.totalPrice == 0 {
                                    realm.delete(mUnCategory2)
                                }
                            }
                        }
                        realm.delete(unCategory2)
                    }
                    realm.delete(income)
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
        updateIncome()
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
    
    // MARK: - Update income
    
    private func updateIncome() {
        
        let realm = try! Realm()
        let income = realm.objects(Income.self).filter("id = '\(id)'")
        income.forEach { (income) in
            
            if autofillSwitch.isOn {
                let auto = Auto()
                let id = UUID().uuidString
                conversionDay(auto, day2)
                auto.id = id
                auto.price = Int(numberLabel.text!) ?? 0
                auto.category = categoryLabel.text ?? ""
                auto.memo = textField.text ?? ""
                auto.payment = "収入"
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
                    incomeData(income)
                    income.isAutofill = true
                }
            } else {
                try! realm.write {
                    incomeData(income)
                }
            }
            
            if income.category == "給与" {
                updateSalary(income)
            } else if income.category == "一時所得" {
                updateTemporary(income)
            } else if income.category == "事業・副業" {
                updateBusiness(income)
            } else if income.category == "年金" {
                updatePension(income)
            } else if income.category == "配当所得" {
                updateDevident(income)
            } else if income.category == "不動産所得" {
                updateEstate(income)
            } else if income.category == "その他入金" {
                updatePayment(income)
            } else if income.category == "未分類" {
                updateUnCategory2(income)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func incomeData(_ income: Income) {
        
        income.price = Int(numberLabel.text!) ?? 0
        income.category = categoryLabel.text ?? ""
        income.memo = textField.text ?? ""
        income.timestamp = dateLabel.text ?? ""
        income.date = year_month_day2
        income.year = year2
        income.month = month2
        income.day = day2
    }
    
    private func updateSalary(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let salary = realm.objects(Salary.self).filter("id = '\(id)'")
        salary.forEach { (salary) in
            try! realm.write {
                let mSalary = realm.objects(MonthlySalary.self).filter("year == '\(salary.year)'").filter("month == '\(salary.month)'")
                mSalary.forEach { (mSalary) in
                    mSalary.totalPrice = mSalary.totalPrice - salary.price
                    mSalary.totalPrice = mSalary.totalPrice + Int(numberLabel.text!)!
                }
                salary.price = Int(numberLabel.text!) ?? 0
                salary.category = categoryLabel.text ?? ""
                salary.memo = textField.text ?? ""
                salary.timestamp = dateLabel.text ?? ""
                salary.year = year2
                salary.month = month2
                salary.day = day2
            }
        }
    }
    
    private func updateTemporary(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let temporary = realm.objects(Temporary.self).filter("id = '\(id)'")
        temporary.forEach { (temporary) in
            try! realm.write {
                let mTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(temporary.year)'").filter("month == '\(temporary.month)'")
                mTemporary.forEach { (mTemporary) in
                    mTemporary.totalPrice = mTemporary.totalPrice - temporary.price
                    mTemporary.totalPrice = mTemporary.totalPrice + Int(numberLabel.text!)!
                }
                temporary.price = Int(numberLabel.text!) ?? 0
                temporary.category = categoryLabel.text ?? ""
                temporary.memo = textField.text ?? ""
                temporary.timestamp = dateLabel.text ?? ""
                temporary.year = year2
                temporary.month = month2
                temporary.day = day2
            }
        }
    }
    
    private func updateBusiness(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let business = realm.objects(Business.self).filter("id = '\(id)'")
        business.forEach { (business) in
            try! realm.write {
                let mBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(business.year)'").filter("month == '\(business.month)'")
                mBusiness.forEach { (mBusiness) in
                    mBusiness.totalPrice = mBusiness.totalPrice - business.price
                    mBusiness.totalPrice = mBusiness.totalPrice + Int(numberLabel.text!)!
                }
                business.price = Int(numberLabel.text!) ?? 0
                business.category = categoryLabel.text ?? ""
                business.memo = textField.text ?? ""
                business.timestamp = dateLabel.text ?? ""
                business.year = year2
                business.month = month2
                business.day = day2
            }
        }
    }
    
    private func updatePension(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let pension = realm.objects(Pension.self).filter("id = '\(id)'")
        pension.forEach { (pension) in
            try! realm.write {
                let mPension = realm.objects(MonthlyPension.self).filter("year == '\(pension.year)'").filter("month == '\(pension.month)'")
                mPension.forEach { (mPension) in
                    mPension.totalPrice = mPension.totalPrice - pension.price
                    mPension.totalPrice = mPension.totalPrice + Int(numberLabel.text!)!
                }
                pension.price = Int(numberLabel.text!) ?? 0
                pension.category = categoryLabel.text ?? ""
                pension.memo = textField.text ?? ""
                pension.timestamp = dateLabel.text ?? ""
                pension.year = year2
                pension.month = month2
                pension.day = day2
            }
        }
    }
    
    private func updateDevident(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let devident = realm.objects(Devident.self).filter("id = '\(id)'")
        devident.forEach { (devident) in
            try! realm.write {
                let mDevident = realm.objects(MonthlyDevident.self).filter("year == '\(devident.year)'").filter("month == '\(devident.month)'")
                mDevident.forEach { (mDevident) in
                    mDevident.totalPrice = mDevident.totalPrice - devident.price
                    mDevident.totalPrice = mDevident.totalPrice + Int(numberLabel.text!)!
                }
                devident.price = Int(numberLabel.text!) ?? 0
                devident.category = categoryLabel.text ?? ""
                devident.memo = textField.text ?? ""
                devident.timestamp = dateLabel.text ?? ""
                devident.year = year2
                devident.month = month2
                devident.day = day2
            }
        }
    }
    
    private func updateEstate(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let estate = realm.objects(Estate.self).filter("id = '\(id)'")
        estate.forEach { (estate) in
            try! realm.write {
                let mEstate = realm.objects(MonthlyEstate.self).filter("year == '\(estate.year)'").filter("month == '\(estate.month)'")
                mEstate.forEach { (mEstate) in
                    mEstate.totalPrice = mEstate.totalPrice - estate.price
                    mEstate.totalPrice = mEstate.totalPrice + Int(numberLabel.text!)!
                }
                estate.price = Int(numberLabel.text!) ?? 0
                estate.category = categoryLabel.text ?? ""
                estate.memo = textField.text ?? ""
                estate.timestamp = dateLabel.text ?? ""
                estate.year = year2
                estate.month = month2
                estate.day = day2
            }
        }
    }
    
    private func updatePayment(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let payment = realm.objects(Payment.self).filter("id = '\(id)'")
        payment.forEach { (payment) in
            try! realm.write {
                let mPayment = realm.objects(MonthlyPayment.self).filter("year == '\(payment.year)'").filter("month == '\(payment.month)'")
                mPayment.forEach { (mPayment) in
                    mPayment.totalPrice = mPayment.totalPrice - payment.price
                    mPayment.totalPrice = mPayment.totalPrice + Int(numberLabel.text!)!
                }
                payment.price = Int(numberLabel.text!) ?? 0
                payment.category = categoryLabel.text ?? ""
                payment.memo = textField.text ?? ""
                payment.timestamp = dateLabel.text ?? ""
                payment.year = year2
                payment.month = month2
                payment.day = day2
            }
        }
    }
    
    private func updateUnCategory2(_ income: Income) {
        
        let realm = try! Realm()
        let id = income.id
        let unCategory2 = realm.objects(UnCategory2.self).filter("id = '\(id)'")
        unCategory2.forEach { (unCategory2) in
            try! realm.write {
                let mUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(unCategory2.year)'").filter("month == '\(unCategory2.month)'")
                mUnCategory2.forEach { (mUnCategory2) in
                    mUnCategory2.totalPrice = mUnCategory2.totalPrice - unCategory2.price
                    mUnCategory2.totalPrice = mUnCategory2.totalPrice + Int(numberLabel.text!)!
                }
                unCategory2.price = Int(numberLabel.text!) ?? 0
                unCategory2.category = categoryLabel.text ?? ""
                unCategory2.memo = textField.text ?? ""
                unCategory2.timestamp = dateLabel.text ?? ""
                unCategory2.year = year2
                unCategory2.month = month2
                unCategory2.day = day2
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setCategory() {
        
        if UserDefaults.standard.object(forKey: SALARY) != nil {
            categoryLabel.text = "給与"
            categoryImageView.image = UIImage(named: "en_mark")
            UserDefaults.standard.removeObject(forKey: SALARY)
        } else if UserDefaults.standard.object(forKey: TEMPORARY) != nil {
            categoryLabel.text = "一時所得"
            categoryImageView.image = UIImage(named: "en_mark")
            UserDefaults.standard.removeObject(forKey: TEMPORARY)
        } else if UserDefaults.standard.object(forKey: BUSINESS) != nil {
            categoryLabel.text = "事業・副業"
            categoryImageView.image = UIImage(named: "en_mark")
            UserDefaults.standard.removeObject(forKey: BUSINESS)
        } else if UserDefaults.standard.object(forKey: PENSION) != nil {
            categoryLabel.text = "年金"
            categoryImageView.image = UIImage(named: "en_mark")
            UserDefaults.standard.removeObject(forKey: PENSION)
        } else if UserDefaults.standard.object(forKey: DEVIDENT) != nil {
            categoryLabel.text = "配当所得"
            categoryImageView.image = UIImage(named: "en_mark")
            UserDefaults.standard.removeObject(forKey: DEVIDENT)
        } else if UserDefaults.standard.object(forKey: ESTATE) != nil {
            categoryLabel.text = "不動産所得"
            categoryImageView.image = UIImage(named: "en_mark")
            UserDefaults.standard.removeObject(forKey: ESTATE)
        } else if UserDefaults.standard.object(forKey: PAYMENT) != nil {
            categoryLabel.text = "その他入金"
            categoryImageView.image = UIImage(named: "en_mark")
            UserDefaults.standard.removeObject(forKey: PAYMENT)
        } else if UserDefaults.standard.object(forKey: UN_CATEGORY2) != nil {
            categoryLabel.text = "未分類"
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
            UserDefaults.standard.removeObject(forKey: UN_CATEGORY2)
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
        navigationItem.title = "入金の修正"
        
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
