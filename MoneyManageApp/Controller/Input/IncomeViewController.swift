//
//  IncomeViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import PKHUD
import FSCalendar
import RealmSwift
import CalculateCalendarLogic
import GoogleMobileAds

class IncomeViewController: UIViewController, UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var autofillSwitch: UISwitch!
    @IBOutlet weak var numberLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var numberLblBottomConstraint: NSLayoutConstraint!
    
    private let calendar = Calendar.current
    
    lazy var buttons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, clearButton, multiplyButton, minusButton, plusButton, devideButton]
    private var firstNumeric = false
    private var lastNumeric = false
    private var inputNumber = 0
    private var yyyy_mm_dd2 = ""
    private var yyyy_mm2 = ""
    private var year2 = ""
    private var month2 = ""
    private var day2 = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        caluclatorView.isHidden = false
        setCategory()
    }
    
    // MARK: - Actions
    
    @IBAction func completionButtonPressed(_ sender: Any) {
        
        numberLabel.text = "0"
        numberLabel2.text = "0"
        categoryLabel.text = "未分類"
        textField.text = ""
        removeUserDefaults()
        firstNumeric = false
        lastNumeric = false
        autofillSwitch.isOn = false
        textField.resignFirstResponder()
        categoryImageView.image = UIImage(systemName: "questionmark.circle")
        
        UIView.animate(withDuration: 0.3) { [self] in
            backView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                backView.isHidden = true
            }
        }
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
        createIncome()
        UIView.animate(withDuration: 0.3) { [self] in
            backView.isHidden = false
            backView.alpha = 1
        }
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
    
    // MARK: - Create income
    
    private func createIncome() {
        
        let realm = try! Realm()
        let id = UUID().uuidString
        let income = Income()
        let salary = Salary()
        let temporary = Temporary()
        let business = Business()
        let pension = Pension()
        let devident = Devident()
        let estate = Estate()
        let payment = Payment()
        let unCategory2 = UnCategory2()
        let nextDateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: 1))
        let firstDateComp = calendar.date(from: DateComponents(year: Int(year2), month: Int(month2)!, day: 1))
        
        let add = DateComponents(month: Int(month2)! + 2, day: -1)
        let lastday = calendar.date(byAdding: add, to: firstday!)
        
        var nextMonth: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: nextDateComp!)
        }
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
        
        if autofillSwitch.isOn {
            let auto = Auto()
            conversionDay(auto, day2)
            auto.id = id
            auto.price = Int(numberLabel.text!) ?? 0
            auto.category = categoryLabel.text ?? ""
            auto.memo = textField.text ?? ""
            auto.payment = "収入"
            auto.timestamp = timestamp
            auto.date = yyyy_mm_dd2
            auto.nextMonth = nextMonth
            auto.isInput = true
            auto.onRegister = true
            auto.isRegister = true
            auto.month = Int(month2)!
            auto.day = Int(day2)!
            
            try! realm.write {
                realm.add(auto)
            }
            
            incomeData(income, id)
            income.isAutofill = true
            try! realm.write {
                realm.add(income)
            }
        } else {
            incomeData(income, id)
            try! realm.write {
                realm.add(income)
            }
        }
        
        if income.category == "給与" {
            salaryData(salary, id)
            mSalaryCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(salary)
            }
        } else if income.category == "一時所得" {
            temporaryData(temporary, id)
            mTemporaryCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(temporary)
            }
        } else if income.category == "事業・副業" {
            businessData(business, id)
            mBusinessCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(business)
            }
        } else if income.category == "年金" {
            pensionData(pension, id)
            mPensionCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(pension)
            }
        } else if income.category == "配当所得" {
            devidentData(devident, id)
            mDevidentCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(devident)
            }
        } else if income.category == "不動産所得" {
            estateData(estate, id)
            mEstateCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(estate)
            }
        } else if income.category == "その他入金" {
            paymentData(payment, id)
            mPaymentCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(payment)
            }
        } else if income.category == "未分類" {
            unCategory2Data(unCategory2, id)
            mUnCategory2Create(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(unCategory2)
            }
        }
    }
    
    private func incomeData(_ income: Income, _ id: String) {
        
        income.price = Int(numberLabel.text!) ?? 0
        income.category = categoryLabel.text ?? ""
        income.memo = textField.text ?? ""
        income.timestamp = dateLabel.text ?? ""
        income.date = yyyy_mm_dd2
        income.year = year2
        income.month = month2
        income.day = day2
        income.id = id
    }
    
    private func salaryData(_ salary: Salary, _ id: String) {
        
        salary.price = Int(numberLabel.text!) ?? 0
        salary.category = categoryLabel.text ?? ""
        salary.memo = textField.text ?? ""
        salary.timestamp = dateLabel.text ?? ""
        salary.year = year2
        salary.month = month2
        salary.day = day2
        salary.id = id
    }
    
    private func temporaryData(_ temporary: Temporary, _ id: String) {
        
        temporary.price = Int(numberLabel.text!) ?? 0
        temporary.category = categoryLabel.text ?? ""
        temporary.memo = textField.text ?? ""
        temporary.timestamp = dateLabel.text ?? ""
        temporary.year = year2
        temporary.month = month2
        temporary.day = day2
        temporary.id = id
    }
    
    private func businessData(_ business: Business, _ id: String) {
        
        business.price = Int(numberLabel.text!) ?? 0
        business.category = categoryLabel.text ?? ""
        business.memo = textField.text ?? ""
        business.timestamp = dateLabel.text ?? ""
        business.year = year2
        business.month = month2
        business.day = day2
        business.id = id
    }
    
    private func pensionData(_ pension: Pension, _ id: String) {
        
        pension.price = Int(numberLabel.text!) ?? 0
        pension.category = categoryLabel.text ?? ""
        pension.memo = textField.text ?? ""
        pension.timestamp = dateLabel.text ?? ""
        pension.year = year2
        pension.month = month2
        pension.day = day2
        pension.id = id
    }
    
    private func devidentData(_ devident: Devident, _ id: String) {
        
        devident.price = Int(numberLabel.text!) ?? 0
        devident.category = categoryLabel.text ?? ""
        devident.memo = textField.text ?? ""
        devident.timestamp = dateLabel.text ?? ""
        devident.year = year2
        devident.month = month2
        devident.day = day2
        devident.id = id
    }
    
    private func estateData(_ estate: Estate, _ id: String) {
        
        estate.price = Int(numberLabel.text!) ?? 0
        estate.category = categoryLabel.text ?? ""
        estate.memo = textField.text ?? ""
        estate.timestamp = dateLabel.text ?? ""
        estate.year = year2
        estate.month = month2
        estate.day = day2
        estate.id = id
    }
    
    private func paymentData(_ payment: Payment, _ id: String) {
        
        payment.price = Int(numberLabel.text!) ?? 0
        payment.category = categoryLabel.text ?? ""
        payment.memo = textField.text ?? ""
        payment.timestamp = dateLabel.text ?? ""
        payment.year = year2
        payment.month = month2
        payment.day = day2
        payment.id = id
    }
    
    private func unCategory2Data(_ unCategory2: UnCategory2, _ id: String) {
        
        unCategory2.price = Int(numberLabel.text!) ?? 0
        unCategory2.category = categoryLabel.text ?? ""
        unCategory2.memo = textField.text ?? ""
        unCategory2.timestamp = dateLabel.text ?? ""
        unCategory2.year = year2
        unCategory2.month = month2
        unCategory2.day = day2
        unCategory2.id = id
    }
    
    private func mSalaryCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlySalary = realm.objects(MonthlySalary.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlySalary.count == 0 {
            let monthlySalary = MonthlySalary()
            monthlySalary.totalPrice = Int(numberLabel.text!) ?? 0
            monthlySalary.category = "給与"
            monthlySalary.timestamp = yearMonthTotal
            monthlySalary.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlySalary.date = yyyy_mm2
            monthlySalary.year = year2
            monthlySalary.month = month2
            try! realm.write {
                realm.add(monthlySalary)
            }
        } else {
            monthlySalary.forEach { (monthlySalary) in
                try! realm.write {
                    monthlySalary.totalPrice = monthlySalary.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mTemporaryCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyTemporary = realm.objects(MonthlyTemporary.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyTemporary.count == 0 {
            let monthlyTemporary = MonthlyTemporary()
            monthlyTemporary.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyTemporary.category = "一時所得"
            monthlyTemporary.timestamp = yearMonthTotal
            monthlyTemporary.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyTemporary.date = yyyy_mm2
            monthlyTemporary.year = year2
            monthlyTemporary.month = month2
            try! realm.write {
                realm.add(monthlyTemporary)
            }
        } else {
            monthlyTemporary.forEach { (monthlyTemporary) in
                try! realm.write {
                    monthlyTemporary.totalPrice = monthlyTemporary.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mBusinessCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyBusiness = realm.objects(MonthlyBusiness.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyBusiness.count == 0 {
            let monthlyBusiness = MonthlyBusiness()
            monthlyBusiness.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyBusiness.category = "事業・副業"
            monthlyBusiness.timestamp = yearMonthTotal
            monthlyBusiness.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyBusiness.date = yyyy_mm2
            monthlyBusiness.year = year2
            monthlyBusiness.month = month2
            try! realm.write {
                realm.add(monthlyBusiness)
            }
        } else {
            monthlyBusiness.forEach { monthlyBusiness in
                try! realm.write {
                    monthlyBusiness.totalPrice = monthlyBusiness.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mPensionCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyPension = realm.objects(MonthlyPension.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyPension.count == 0 {
            let monthlyPension = MonthlyPension()
            monthlyPension.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyPension.category = "年金"
            monthlyPension.timestamp = yearMonthTotal
            monthlyPension.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyPension.date = yyyy_mm2
            monthlyPension.year = year2
            monthlyPension.month = month2
            try! realm.write {
                realm.add(monthlyPension)
            }
        } else {
            monthlyPension.forEach { (monthlyPension) in
                try! realm.write {
                    monthlyPension.totalPrice = monthlyPension.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mDevidentCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyDevident = realm.objects(MonthlyDevident.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyDevident.count == 0 {
            let monthlyDevident = MonthlyDevident()
            monthlyDevident.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyDevident.category = "配当所得"
            monthlyDevident.timestamp = yearMonthTotal
            monthlyDevident.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyDevident.date = yyyy_mm2
            monthlyDevident.year = year2
            monthlyDevident.month = month2
            try! realm.write {
                realm.add(monthlyDevident)
            }
        } else {
            monthlyDevident.forEach { (monthlyDevident) in
                try! realm.write {
                    monthlyDevident.totalPrice = monthlyDevident.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mEstateCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyEstate = realm.objects(MonthlyEstate.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyEstate.count == 0 {
            let monthlyEstate = MonthlyEstate()
            monthlyEstate.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyEstate.category = "不動産所得"
            monthlyEstate.timestamp = yearMonthTotal
            monthlyEstate.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyEstate.date = yyyy_mm2
            monthlyEstate.year = year2
            monthlyEstate.month = month2
            try! realm.write {
                realm.add(monthlyEstate)
            }
        } else {
            monthlyEstate.forEach { (monthlyEstate) in
                try! realm.write {
                    monthlyEstate.totalPrice = monthlyEstate.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mPaymentCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyPayment = realm.objects(MonthlyPayment.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyPayment.count == 0 {
            let monthlyPayment = MonthlyPayment()
            monthlyPayment.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyPayment.category = "その他入金"
            monthlyPayment.timestamp = yearMonthTotal
            monthlyPayment.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyPayment.date = yyyy_mm2
            monthlyPayment.year = year2
            monthlyPayment.month = month2
            try! realm.write {
                realm.add(monthlyPayment)
            }
        } else {
            monthlyPayment.forEach { (monthlyPayment) in
                try! realm.write {
                    monthlyPayment.totalPrice = monthlyPayment.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mUnCategory2Create(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyUnCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyUnCategory2.count == 0 {
            let monthlyUnCategory2 = MonthlyUnCategory2()
            monthlyUnCategory2.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyUnCategory2.category = "未分類"
            monthlyUnCategory2.timestamp = yearMonthTotal
            monthlyUnCategory2.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyUnCategory2.date = yyyy_mm2
            monthlyUnCategory2.year = year2
            monthlyUnCategory2.month = month2
            try! realm.write {
                realm.add(monthlyUnCategory2)
            }
        } else {
            monthlyUnCategory2.forEach { (monthlyUnCategory2) in
                try! realm.write {
                    monthlyUnCategory2.totalPrice = monthlyUnCategory2.totalPrice + Int(numberLabel.text!)!
                }
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
        
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: date)
        }
        var yyyy_mm_dd: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        var yyyy_mm: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM"
            return dateFormatter.string(from: date)
        }
        var year: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        }
        var month: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: date)
        }
        var day: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
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
    
    private func nowDate() {
        
        dateLabel.text = timestamp
        yyyy_mm_dd2 = yyyy_mm_dd
        yyyy_mm2 = yyyy_mm
        year2 = year
        month2 = month
        day2 = day
    }
    
    private func setup() {
        
        nowDate()
        numberLabel.isHidden = true
        textField.delegate = self
        backView.isHidden = true
        backView.alpha = 0
        completionButton.layer.cornerRadius = 3
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
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            numberLblTopConstraint.constant = 10
            numberLblBottomConstraint.constant = 10
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
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1880671698"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
