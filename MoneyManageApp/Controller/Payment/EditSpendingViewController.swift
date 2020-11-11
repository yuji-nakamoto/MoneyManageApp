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
    var spending = Spending()
    
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
        
        numberLabel.text = String(spending.price)
        categoryLabel.text = spending.category
        dateLabel.text = spending.timestamp
        textField.text = spending.memo
        year_month_day2 = spending.date
        year2 = spending.year
        month2 = spending.month
        day2 = spending.month
        
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
    
    // MARK: - Actions
    
    @IBAction func deleteButtonPressd(_ sender: Any) {
        
        let realm = try! Realm()
        let alert = UIAlertController(title: spending.category, message: "データを削除しますか？", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            try! realm.write {
                realm.delete(spending)
                HUD.flash(.labeledSuccess(title: "", subtitle: "削除しました"), delay: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
        
        if textField.text == "" && categoryLabel.text == "未分類" && numberLabel.text == "0" {
            HUD.flash(.labeledError(title: "入力欄が空です", subtitle: ""), delay: 1)
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
            if numberLabel.text!.count > 12 {
                return
            }
            numberLabel.text?.append("0")
        }
    }
    
    @IBAction func oneButtonPressed(_ sender: Any) {
        oneButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            oneButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("1")
    }
    
    @IBAction func twoButtonPressed(_ sender: Any) {
        twoButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            twoButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("2")
    }
    
    @IBAction func threeButtonPressed(_ sender: Any) {
        threeButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            threeButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("3")
    }
    
    @IBAction func fourButtonPressed(_ sender: Any) {
        fourButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            fourButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("4")
    }
    
    @IBAction func fiveButtonPressed(_ sender: Any) {
        fiveButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            fiveButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("5")
    }
    
    @IBAction func sixButtonPressed(_ sender: Any) {
        sixButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            sixButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("6")
    }
    
    @IBAction func sevenButtonPressed(_ sender: Any) {
        sevenButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            sevenButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("7")
    }
    
    @IBAction func eightButtonPressed(_ sender: Any) {
        eightButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            eightButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericAndValidate()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("8")
    }
    
    @IBAction func nineButtonPressed(_ sender: Any) {
        nineButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            nineButton.backgroundColor = UIColor(named: O_BLACK)
        }
        isNumericTrue()
        if numberLabel.text!.count > 12 { return }
        numberLabel.text?.append("9")
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        clearButton.backgroundColor = .systemGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            clearButton.backgroundColor = UIColor(named: O_BLACK)
        }
        numberLabel.text = "0"
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
            numberLabel.text = String(totalNumeric)
            if numberLabel.text!.count > 13 {
                numberLabel.text = "9999999999999"
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
            numberLabel.text = String(totalNumeric)
        }
        
        if UserDefaults.standard.object(forKey: MULTIPLY) != nil {
            let numeric = UserDefaults.standard.object(forKey: MULTIPLY)
            let lastNumeric = Int(numberLabel.text!)
            let totalNumeric = numeric as! Int * lastNumeric!
            numberLabel.text = String(totalNumeric)
            if numberLabel.text!.count > 13 {
                numberLabel.text = "9999999999999"
            }
        }
        
        if UserDefaults.standard.object(forKey: DEVIDE) != nil {
            let numeric = UserDefaults.standard.object(forKey: DEVIDE)
            let lastNumeric = Int(numberLabel.text!)
            guard lastNumeric != 0 else { return }
            let totalNumeric = numeric as! Int / lastNumeric!
            if totalNumeric == 0 { firstNumeric = false }
            numberLabel.text = String(totalNumeric)
        }
        removeUserDefaults()
        lastNumeric = false
    }
    
    // MARK: - Helpers
    
    private func updateSpending() {
        
        let realm = try! Realm()
        
        if autofillSwitch.isOn {
            let auto = Auto()
            let id = UUID().uuidString
            conversionDay(auto)
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
                lastNumeric = true
            }
        }
        
        if !firstNumeric {
            numberLabel.text = ""
        }
        firstNumeric = true
    }
    
    private func setup() {
        
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
    
    private func conversionDay(_ auto: Auto) {
        
        if day2 == "1" {
            auto.input_auto_day = "月初"
        } else if day2 == "2" {
            auto.input_auto_day = "2日"
        } else if day2 == "3" {
            auto.input_auto_day = "3日"
        } else if day2 == "4" {
            auto.input_auto_day = "4日"
        } else if day2 == "5" {
            auto.input_auto_day = "5日"
        } else if day2 == "6" {
            auto.input_auto_day = "6日"
        } else if day2 == "7" {
            auto.input_auto_day = "7日"
        } else if day2 == "8" {
            auto.input_auto_day = "8日"
        } else if day2 == "9" {
            auto.input_auto_day = "9日"
        } else if day2 == "10" {
            auto.input_auto_day = "10日"
        } else if day2 == "11" {
            auto.input_auto_day = "11日"
        } else if day2 == "12" {
            auto.input_auto_day = "12日"
        } else if day2 == "13" {
            auto.input_auto_day = "13日"
        } else if day2 == "14" {
            auto.input_auto_day = "14日"
        } else if day2 == "15" {
            auto.input_auto_day = "15日"
        } else if day2 == "16" {
            auto.input_auto_day = "16日"
        } else if day2 == "17" {
            auto.input_auto_day = "17日"
        } else if day2 == "18" {
            auto.input_auto_day = "18日"
        } else if day2 == "19" {
            auto.input_auto_day = "19日"
        } else if day2 == "20" {
            auto.input_auto_day = "20日"
        } else if day2 == "21" {
            auto.input_auto_day = "21日"
        } else if day2 == "22" {
            auto.input_auto_day = "22日"
        } else if day2 == "23" {
            auto.input_auto_day = "23日"
        } else if day2 == "24" {
            auto.input_auto_day = "24日"
        } else if day2 == "25" {
            auto.input_auto_day = "25日"
        } else if day2 == "26" {
            auto.input_auto_day = "26日"
        } else if day2 == "27" {
            auto.input_auto_day = "27日"
        } else if day2 == "28" {
            auto.input_auto_day = "28日"
        } else if day2 == "29" {
            auto.input_auto_day = "月末"
        } else if day2 == "30" {
            auto.input_auto_day = "月末"
        } else if day2 == "31" {
            auto.input_auto_day = "月末"
        }
    }
}
