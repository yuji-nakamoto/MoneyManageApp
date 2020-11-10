//
//  EditIncomeViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import PKHUD
import FSCalendar
import RealmSwift

class EditIncomeViewController: UIViewController, UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
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
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    lazy var buttons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, clearButton, multiplyButton, minusButton, plusButton, devideButton]
    private var firstNumeric = false
    private var lastNumeric = false
    private let realm = try? Realm()
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
        categoryLabel.text = income.category
        dateLabel.text = income.timestamp
        textField.text = income.memo
        date2Label.text = income.date
        yearLabel.text = income.year
        monthLabel.text = income.month
        
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
        
        let alert = UIAlertController(title: income.category, message: "データを削除しますか？", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            try! realm!.write {
                realm!.delete(income)
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
    
    private func updateIncome() {
        
        try! realm!.write {
            income.price = Int(numberLabel.text!) ?? 0
            income.category = categoryLabel.text ?? ""
            income.memo = textField.text ?? ""
            income.timestamp = dateLabel.text ?? ""
            income.date = date2Label.text ?? ""
            income.year = yearLabel.text ?? ""
            income.month = monthLabel.text ?? ""
            navigationController?.popViewController(animated: true)
        }
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
        
        let dateFormatter = DateFormatter()
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
        dateLabel.text = timestamp
        date2Label.text = date2
        yearLabel.text = year
        monthLabel.text = month
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
    
    private func nowDate() {
        
        let now = Date()
        var timestamp: String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: now)
        }
        dateLabel.text = timestamp
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
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor(named: O_BLACK) as Any]
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
