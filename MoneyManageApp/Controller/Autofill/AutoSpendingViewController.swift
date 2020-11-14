//
//  AutoSpendingViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import PKHUD
import GoogleMobileAds
import RealmSwift

class AutoSpendingViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var pickerKeyboardView: PickerKeyboard1!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var completionButton: UIButton!

    lazy var buttons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, clearButton, multiplyButton, minusButton, plusButton, devideButton]
    private var firstNumeric = false
    private var lastNumeric = false
    private var inputNumber = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCategory()
    }
    
    // MARK: - Actions

    @IBAction func completionButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3) { [self] in
            backView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                backView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerButtonPressed(_ sender: Any) {
        
        textField.resignFirstResponder()
        caluclatorView.isHidden = true
    }
    
    @IBAction func calculatorButtonPressed(_ sender: Any) {
        
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.25) {
            self.caluclatorView.isHidden = !self.caluclatorView.isHidden
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if numberLabel.text == "0" {
            HUD.flash(.labeledError(title: "", subtitle: "価格を入力してください"), delay: 1)
            return
        }
        
        if dateLabel.text == "自動入力が行われる日を入力" {
            HUD.flash(.labeledError(title: "", subtitle: "入力日が空欄です"), delay: 1)
            return
        }
        
        textField.resignFirstResponder()
        createSpending()
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
    
    // MARK: - Helpers
    
    private func createSpending() {
        
        let realm = try! Realm()
        let auto = Auto()
        let id = UUID().uuidString
        let calendar = Calendar.current
        var dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month), day: inputNumber))
        
        if inputNumber == 29 {
            inputNumber = Int(lastDayString)!
            dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month), day: inputNumber))
            formatterFunc(auto, dateComp!)
        } else {
            formatterFunc(auto, dateComp!)
        }

        auto.price = Int(numberLabel.text!) ?? 0
        auto.category = categoryLabel.text ?? ""
        auto.memo = textField.text ?? ""
        auto.payment = "支出"
        auto.autofillDay = dateLabel.text ?? ""
        auto.isInput = false
        auto.month = Int(month)!
        auto.day = inputNumber
        auto.isRegister = true
        auto.id = id
        
        try! realm.write {
            realm.add(auto)
        }
    }
    
    private func formatterFunc(_ auto: Auto, _ date: Date) {
        
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: date)
        }
        var year_month_day: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        auto.date = year_month_day
        auto.timestamp = timestamp
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
        
        pickerKeyboardView.delegate = self
        textField.delegate = self
        backView.isHidden = true
        backView.alpha = 0
        completionButton.layer.cornerRadius = 3
        numberLabel.isHidden = true
        categoryLabel.text = "未分類"
        dateLabel.text = "自動入力が行われる日を入力"
        dateLabel.textColor = .systemGray3
        saveButton.layer.cornerRadius = 10
        buttons.forEach({ $0?.layer.borderWidth = 0.2; $0?.layer.borderColor = UIColor.systemGray.cgColor })
        textField.addTarget(self, action: #selector(textFieldTap), for: .editingDidBegin)
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func removeUserDefaults() {
        
        UserDefaults.standard.removeObject(forKey: PLUS)
        UserDefaults.standard.removeObject(forKey: MINUS)
        UserDefaults.standard.removeObject(forKey: MULTIPLY)
        UserDefaults.standard.removeObject(forKey: DEVIDE)
    }
    
    @objc func textFieldTap() {
        caluclatorView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
}

extension AutoSpendingViewController: PickerKeyboard1Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard1) -> Array<String> {
        return dataArray1
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard1, selectData: String) {
        if selectData == "未設定" {
            dateLabel.text = "自動入力が行われる日を入力"
            dateLabel.textColor = .systemGray3
        } else {
            dateLabel.text = selectData
            dateLabel.textColor = UIColor(named: O_BLACK)
            if dateLabel.text == "月初" {
                inputNumber = 1
            } else if dateLabel.text == "2日" {
                inputNumber = 2
            } else if dateLabel.text == "3日" {
                inputNumber = 3
            } else if dateLabel.text == "4日" {
                inputNumber = 4
            } else if dateLabel.text == "5日" {
                inputNumber = 5
            } else if dateLabel.text == "6日" {
                inputNumber = 6
            } else if dateLabel.text == "7日" {
                inputNumber = 7
            } else if dateLabel.text == "8日" {
                inputNumber = 8
            } else if dateLabel.text == "9日" {
                inputNumber = 9
            } else if dateLabel.text == "10日" {
                inputNumber = 10
            } else if dateLabel.text == "11日" {
                inputNumber = 11
            } else if dateLabel.text == "12日" {
                inputNumber = 12
            } else if dateLabel.text == "13日" {
                inputNumber = 13
            } else if dateLabel.text == "14日" {
                inputNumber = 14
            } else if dateLabel.text == "15日" {
                inputNumber = 15
            } else if dateLabel.text == "16日" {
                inputNumber = 16
            } else if dateLabel.text == "17日" {
                inputNumber = 17
            } else if dateLabel.text == "18日" {
                inputNumber = 18
            } else if dateLabel.text == "19日" {
                inputNumber = 19
            } else if dateLabel.text == "20日" {
                inputNumber = 20
            } else if dateLabel.text == "21日" {
                inputNumber = 21
            } else if dateLabel.text == "22日" {
                inputNumber = 22
            } else if dateLabel.text == "23日" {
                inputNumber = 23
            } else if dateLabel.text == "24日" {
                inputNumber = 24
            } else if dateLabel.text == "25日" {
                inputNumber = 25
            } else if dateLabel.text == "26日" {
                inputNumber = 26
            } else if dateLabel.text == "27日" {
                inputNumber = 27
            } else if dateLabel.text == "28日" {
                inputNumber = 28
            } else if dateLabel.text == "月末" {
                inputNumber = 29
            }
        }
    }
}
