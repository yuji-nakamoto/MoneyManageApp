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
    var income = Income()
    
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
        } else if income.category == "給料" {
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
    
    // MARK: - Actions
    
    @IBAction func deleteButtonPressd(_ sender: Any) {
        
        let realm = try! Realm()
        let alert = UIAlertController(title: income.category, message: "データを削除しますか？", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            try! realm.write {
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
    
    // MARK: - Helpers
    
    private func updateIncome() {
        
        let realm = try! Realm()

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
    
    private func setCategory() {
        
        if UserDefaults.standard.object(forKey: SALARY) != nil {
            categoryLabel.text = "給料"
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
