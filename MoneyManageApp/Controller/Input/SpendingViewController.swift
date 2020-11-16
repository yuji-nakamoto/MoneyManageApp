//
//  SpendingViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/06.
//

import UIKit
import PKHUD
import FSCalendar
import RealmSwift
import CalculateCalendarLogic
import GoogleMobileAds

class SpendingViewController: UIViewController, UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
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
        firstNumeric = false
        lastNumeric = false
        autofillSwitch.isOn = false
        removeUserDefaults()
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
    
    //MARK: - Create spending
    
    private func createSpending() {
        
        let realm = try! Realm()
        let id = UUID().uuidString
        let spending = Spending()
        let food = Food()
        let brush = Brush()
        let hobby = Hobby()
        let dating = Dating()
        let traffic = Traffic()
        let clothe = Clothe()
        let health = Health()
        let car = Car()
        let education = Education()
        let special = Special()
        let card = Card()
        let utility = Utility()
        let communication = Communicaton()
        let house = House()
        let tax = Tax()
        let insrance = Insrance()
        let etcetora = Etcetora()
        let unCategory = UnCategory()
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
            auto.payment = "支出"
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
            
            spendingData(spending, id)
            spending.isAutofill = true
           
            try! realm.write {
                realm.add(spending)
            }
        } else {
            spendingData(spending, id)
            try! realm.write {
                realm.add(spending)
            }
        }
        
        if spending.category == "食費" {
            foodData(food, id)
            mFoodCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(food)
            }
        } else if spending.category == "日用品" {
            brushData(brush, id)
            mBrushCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(brush)
            }
        } else if spending.category == "趣味" {
            hobbyData(hobby, id)
            mHobbyCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(hobby)
            }
        } else if spending.category == "交際費" {
            datingData(dating, id)
            mDatingCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(dating)
            }
        } else if spending.category == "交通費" {
            trafficData(traffic, id)
            mTrafficCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(traffic)
            }
        } else if spending.category == "衣服・美容" {
            clotheData(clothe, id)
            mClotheCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(clothe)
            }
        } else if spending.category == "健康・医療" {
            healthData(health, id)
            mHealthCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(health)
            }
        } else if spending.category == "自動車" {
            carData(car, id)
            mCarCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(car)
            }
        } else if spending.category == "教養・教育" {
            educationData(education, id)
            mEducationCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(education)
            }
        } else if spending.category == "特別な支出" {
            specialData(special, id)
            mSpecialCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(special)
            }
        } else if spending.category == "現金・カード" {
            cardData(card, id)
            mCardCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(card)
            }
        } else if spending.category == "水道・光熱費" {
            utilityData(utility, id)
            mUtilityCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(utility)
            }
        } else if spending.category == "通信費" {
            communicationData(communication, id)
            mCommunicationCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(communication)
            }
        } else if spending.category == "住宅" {
            houseData(house, id)
            mHouseCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(house)
            }
        } else if spending.category == "税・社会保険" {
            taxData(tax, id)
            mTaxCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(tax)
            }
        } else if spending.category == "保険" {
            insranceData(insrance, id)
            mInsranceCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(insrance)
            }
        } else if spending.category == "その他" {
            etcetraData(etcetora, id)
            mEtcetoraCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(etcetora)
            }
        } else if spending.category == "未分類" {
            unCategoryData(unCategory, id)
            mUnCategoryCreate(yearMonthTotal, firstDayString, lastDayString)
            try! realm.write {
                realm.add(unCategory)
            }
        }
    }
    
    private func spendingData(_ spending: Spending, _ id: String) {
        
        spending.price = Int(numberLabel.text!) ?? 0
        spending.category = categoryLabel.text ?? ""
        spending.memo = textField.text ?? ""
        spending.timestamp = dateLabel.text ?? ""
        spending.date = yyyy_mm_dd2
        spending.year = year2
        spending.month = month2
        spending.day = day2
        spending.id = id
    }
    
    private func foodData(_ food: Food, _ id: String) {
        
        food.price = Int(numberLabel.text!) ?? 0
        food.category = categoryLabel.text ?? ""
        food.memo = textField.text ?? ""
        food.timestamp = dateLabel.text ?? ""
        food.year = year2
        food.month = month2
        food.day = day2
        food.id = id
    }
    
    private func brushData(_ brush: Brush, _ id: String) {
        
        brush.price = Int(numberLabel.text!) ?? 0
        brush.category = categoryLabel.text ?? ""
        brush.memo = textField.text ?? ""
        brush.timestamp = dateLabel.text ?? ""
        brush.year = year2
        brush.month = month2
        brush.day = day2
        brush.id = id
    }
    
    private func hobbyData(_ hobby: Hobby, _ id: String) {
        
        hobby.price = Int(numberLabel.text!) ?? 0
        hobby.category = categoryLabel.text ?? ""
        hobby.memo = textField.text ?? ""
        hobby.timestamp = dateLabel.text ?? ""
        hobby.year = year2
        hobby.month = month2
        hobby.day = day2
        hobby.id = id
    }
    
    private func datingData(_ dating: Dating, _ id: String) {
        
        dating.price = Int(numberLabel.text!) ?? 0
        dating.category = categoryLabel.text ?? ""
        dating.memo = textField.text ?? ""
        dating.timestamp = dateLabel.text ?? ""
        dating.year = year2
        dating.month = month2
        dating.day = day2
        dating.id = id
    }
    
    private func trafficData(_ traffic: Traffic, _ id: String) {
        
        traffic.price = Int(numberLabel.text!) ?? 0
        traffic.category = categoryLabel.text ?? ""
        traffic.memo = textField.text ?? ""
        traffic.timestamp = dateLabel.text ?? ""
        traffic.year = year2
        traffic.month = month2
        traffic.day = day2
        traffic.id = id
    }
    
    private func clotheData(_ clothe: Clothe, _ id: String) {
        
        clothe.price = Int(numberLabel.text!) ?? 0
        clothe.category = categoryLabel.text ?? ""
        clothe.memo = textField.text ?? ""
        clothe.timestamp = dateLabel.text ?? ""
        clothe.year = year2
        clothe.month = month2
        clothe.day = day2
        clothe.id = id
    }
    
    private func healthData(_ health: Health, _ id: String) {
        
        health.price = Int(numberLabel.text!) ?? 0
        health.category = categoryLabel.text ?? ""
        health.memo = textField.text ?? ""
        health.timestamp = dateLabel.text ?? ""
        health.year = year2
        health.month = month2
        health.day = day2
        health.id = id
    }
    
    private func carData(_ car: Car, _ id: String) {
        
        car.price = Int(numberLabel.text!) ?? 0
        car.category = categoryLabel.text ?? ""
        car.memo = textField.text ?? ""
        car.timestamp = dateLabel.text ?? ""
        car.year = year2
        car.month = month2
        car.day = day2
        car.id = id
    }
    
    private func educationData(_ education: Education, _ id: String) {
        
        education.price = Int(numberLabel.text!) ?? 0
        education.category = categoryLabel.text ?? ""
        education.memo = textField.text ?? ""
        education.timestamp = dateLabel.text ?? ""
        education.year = year2
        education.month = month2
        education.day = day2
        education.id = id
    }
    
    private func specialData(_ special: Special, _ id: String) {
        
        special.price = Int(numberLabel.text!) ?? 0
        special.category = categoryLabel.text ?? ""
        special.memo = textField.text ?? ""
        special.timestamp = dateLabel.text ?? ""
        special.year = year2
        special.month = month2
        special.day = day2
        special.id = id
    }
    
    private func cardData(_ card: Card, _ id: String) {
        
        card.price = Int(numberLabel.text!) ?? 0
        card.category = categoryLabel.text ?? ""
        card.memo = textField.text ?? ""
        card.timestamp = dateLabel.text ?? ""
        card.year = year2
        card.month = month2
        card.day = day2
        card.id = id
    }
    
    private func utilityData(_ utility: Utility, _ id: String) {
        
        utility.price = Int(numberLabel.text!) ?? 0
        utility.category = categoryLabel.text ?? ""
        utility.memo = textField.text ?? ""
        utility.timestamp = dateLabel.text ?? ""
        utility.year = year2
        utility.month = month2
        utility.day = day2
        utility.id = id
    }
    
    private func communicationData(_ communication: Communicaton, _ id: String) {
        
        communication.price = Int(numberLabel.text!) ?? 0
        communication.category = categoryLabel.text ?? ""
        communication.memo = textField.text ?? ""
        communication.timestamp = dateLabel.text ?? ""
        communication.year = year2
        communication.month = month2
        communication.day = day2
        communication.id = id
    }
    
    private func houseData(_ house: House, _ id: String) {
        
        house.price = Int(numberLabel.text!) ?? 0
        house.category = categoryLabel.text ?? ""
        house.memo = textField.text ?? ""
        house.timestamp = dateLabel.text ?? ""
        house.year = year2
        house.month = month2
        house.day = day2
        house.id = id
    }
    
    private func taxData(_ tax: Tax, _ id: String) {
        
        tax.price = Int(numberLabel.text!) ?? 0
        tax.category = categoryLabel.text ?? ""
        tax.memo = textField.text ?? ""
        tax.timestamp = dateLabel.text ?? ""
        tax.year = year2
        tax.month = month2
        tax.day = day2
        tax.id = id
    }
    
    private func insranceData(_ insrance: Insrance, _ id: String) {
        
        insrance.price = Int(numberLabel.text!) ?? 0
        insrance.category = categoryLabel.text ?? ""
        insrance.memo = textField.text ?? ""
        insrance.timestamp = dateLabel.text ?? ""
        insrance.year = year2
        insrance.month = month2
        insrance.day = day2
        insrance.id = id
    }
    
    private func etcetraData(_ etcetra: Etcetora, _ id: String) {
        
        etcetra.price = Int(numberLabel.text!) ?? 0
        etcetra.category = categoryLabel.text ?? ""
        etcetra.memo = textField.text ?? ""
        etcetra.timestamp = dateLabel.text ?? ""
        etcetra.year = year2
        etcetra.month = month2
        etcetra.day = day2
        etcetra.id = id
    }
    
    private func unCategoryData(_ unCategory: UnCategory, _ id: String) {
        
        unCategory.price = Int(numberLabel.text!) ?? 0
        unCategory.category = categoryLabel.text ?? ""
        unCategory.memo = textField.text ?? ""
        unCategory.timestamp = dateLabel.text ?? ""
        unCategory.year = year2
        unCategory.month = month2
        unCategory.day = day2
        unCategory.id = id
    }
    
    private func mFoodCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyFood = realm.objects(MonthlyFood.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyFood.count == 0 {
            let monthlyFood = MonthlyFood()
            monthlyFood.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyFood.category = "食費"
            monthlyFood.timestamp = yearMonthTotal
            monthlyFood.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyFood.date = yyyy_mm2
            monthlyFood.year = year2
            monthlyFood.month = month2
            try! realm.write {
                realm.add(monthlyFood)
            }
        } else {
            monthlyFood.forEach { (monthlyFood) in
                try! realm.write {
                    monthlyFood.totalPrice = monthlyFood.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mBrushCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyBrush = realm.objects(MonthlyBrush.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyBrush.count == 0 {
            let monthlyBrush = MonthlyBrush()
            monthlyBrush.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyBrush.category = "日用品"
            monthlyBrush.timestamp = yearMonthTotal
            monthlyBrush.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyBrush.date = yyyy_mm2
            monthlyBrush.year = year2
            monthlyBrush.month = month2
            try! realm.write {
                realm.add(monthlyBrush)
            }
        } else {
            monthlyBrush.forEach { (monthlyBrush) in
                try! realm.write {
                    monthlyBrush.totalPrice = monthlyBrush.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mHobbyCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyHobby = realm.objects(MonthlyHobby.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyHobby.count == 0 {
            let monthlyHobby = MonthlyHobby()
            monthlyHobby.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyHobby.category = "趣味"
            monthlyHobby.timestamp = yearMonthTotal
            monthlyHobby.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyHobby.date = yyyy_mm2
            monthlyHobby.year = year2
            monthlyHobby.month = month2
            try! realm.write {
                realm.add(monthlyHobby)
            }
        } else {
            monthlyHobby.forEach { (monthlyHobby) in
                try! realm.write {
                    monthlyHobby.totalPrice = monthlyHobby.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mDatingCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyDating = realm.objects(MonthlyDating.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyDating.count == 0 {
            let monthlyDating = MonthlyDating()
            monthlyDating.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyDating.category = "交際費"
            monthlyDating.timestamp = yearMonthTotal
            monthlyDating.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyDating.date = yyyy_mm2
            monthlyDating.year = year2
            monthlyDating.month = month2
            try! realm.write {
                realm.add(monthlyDating)
            }
        } else {
            monthlyDating.forEach { (monthlyDating) in
                try! realm.write {
                    monthlyDating.totalPrice = monthlyDating.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mTrafficCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyTraffic = realm.objects(MonthlyTraffic.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyTraffic.count == 0 {
            let monthlyTraffic = MonthlyTraffic()
            monthlyTraffic.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyTraffic.category = "交通費"
            monthlyTraffic.timestamp = yearMonthTotal
            monthlyTraffic.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyTraffic.date = yyyy_mm2
            monthlyTraffic.year = year2
            monthlyTraffic.month = month2
            try! realm.write {
                realm.add(monthlyTraffic)
            }
        } else {
            monthlyTraffic.forEach { (monthlyTraffic) in
                try! realm.write {
                    monthlyTraffic.totalPrice = monthlyTraffic.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mClotheCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyClothe = realm.objects(MonthlyClothe.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyClothe.count == 0 {
            let monthlyClothe = MonthlyClothe()
            monthlyClothe.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyClothe.category = "衣服・美容"
            monthlyClothe.timestamp = yearMonthTotal
            monthlyClothe.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyClothe.date = yyyy_mm2
            monthlyClothe.year = year2
            monthlyClothe.month = month2
            try! realm.write {
                realm.add(monthlyClothe)
            }
        } else {
            monthlyClothe.forEach { (monthlyClothe) in
                try! realm.write {
                    monthlyClothe.totalPrice = monthlyClothe.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mHealthCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyhealth = realm.objects(MonthlyHealth.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyhealth.count == 0 {
            let monthlyhealth = MonthlyHealth()
            monthlyhealth.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyhealth.category = "健康・医療"
            monthlyhealth.timestamp = yearMonthTotal
            monthlyhealth.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyhealth.date = yyyy_mm2
            monthlyhealth.year = year2
            monthlyhealth.month = month2
            try! realm.write {
                realm.add(monthlyhealth)
            }
        } else {
            monthlyhealth.forEach { (monthlyhealth) in
                try! realm.write {
                    monthlyhealth.totalPrice = monthlyhealth.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mCarCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyCar = realm.objects(MonthlyCar.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyCar.count == 0 {
            let monthlyCar = MonthlyCar()
            monthlyCar.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyCar.category = "自動車"
            monthlyCar.timestamp = yearMonthTotal
            monthlyCar.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyCar.date = yyyy_mm2
            monthlyCar.year = year2
            monthlyCar.month = month2
            try! realm.write {
                realm.add(monthlyCar)
            }
        } else {
            monthlyCar.forEach { (monthlyCar) in
                try! realm.write {
                    monthlyCar.totalPrice = monthlyCar.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mEducationCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyEducation = realm.objects(MonthlyEducation.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyEducation.count == 0 {
            let monthlyEducation = MonthlyEducation()
            monthlyEducation.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyEducation.category = "教養・教育"
            monthlyEducation.timestamp = yearMonthTotal
            monthlyEducation.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyEducation.date = yyyy_mm2
            monthlyEducation.year = year2
            monthlyEducation.month = month2
            try! realm.write {
                realm.add(monthlyEducation)
            }
        } else {
            monthlyEducation.forEach { (monthlyEducation) in
                try! realm.write {
                    monthlyEducation.totalPrice = monthlyEducation.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mSpecialCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlySpecial = realm.objects(MonthlySpecial.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlySpecial.count == 0 {
            let monthlySpecial = MonthlySpecial()
            monthlySpecial.totalPrice = Int(numberLabel.text!) ?? 0
            monthlySpecial.category = "特別な支出"
            monthlySpecial.timestamp = yearMonthTotal
            monthlySpecial.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlySpecial.date = yyyy_mm2
            monthlySpecial.year = year2
            monthlySpecial.month = month2
            try! realm.write {
                realm.add(monthlySpecial)
            }
        } else {
            monthlySpecial.forEach { (monthlySpecial) in
                try! realm.write {
                    monthlySpecial.totalPrice = monthlySpecial.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mCardCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyCard = realm.objects(MonthlyCard.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyCard.count == 0 {
            let monthlyCard = MonthlyCard()
            monthlyCard.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyCard.category = "現金・カード"
            monthlyCard.timestamp = yearMonthTotal
            monthlyCard.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyCard.date = yyyy_mm2
            monthlyCard.year = year2
            monthlyCard.month = month2
            try! realm.write {
                realm.add(monthlyCard)
            }
        } else {
            monthlyCard.forEach { (monthlyCard) in
                try! realm.write {
                    monthlyCard.totalPrice = monthlyCard.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mUtilityCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyUtility = realm.objects(MonthlyUtility.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyUtility.count == 0 {
            let monthlyUtility = MonthlyUtility()
            monthlyUtility.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyUtility.category = "水道・光熱費"
            monthlyUtility.timestamp = yearMonthTotal
            monthlyUtility.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyUtility.date = yyyy_mm2
            monthlyUtility.year = year2
            monthlyUtility.month = month2
            try! realm.write {
                realm.add(monthlyUtility)
            }
        } else {
            monthlyUtility.forEach { (monthlyUtility) in
                try! realm.write {
                    monthlyUtility.totalPrice = monthlyUtility.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mCommunicationCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyCommunication = realm.objects(MonthlyCommunication.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyCommunication.count == 0 {
            let monthlyCommunication = MonthlyCommunication()
            monthlyCommunication.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyCommunication.category = "通信費"
            monthlyCommunication.timestamp = yearMonthTotal
            monthlyCommunication.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyCommunication.date = yyyy_mm2
            monthlyCommunication.year = year2
            monthlyCommunication.month = month2
            try! realm.write {
                realm.add(monthlyCommunication)
            }
        } else {
            monthlyCommunication.forEach { (monthlyCommunication) in
                try! realm.write {
                    monthlyCommunication.totalPrice = monthlyCommunication.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mHouseCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyHouse = realm.objects(MonthlyHouse.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyHouse.count == 0 {
            let monthlyHouse = MonthlyHouse()
            monthlyHouse.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyHouse.category = "住宅"
            monthlyHouse.timestamp = yearMonthTotal
            monthlyHouse.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyHouse.date = yyyy_mm2
            monthlyHouse.year = year2
            monthlyHouse.month = month2
            try! realm.write {
                realm.add(monthlyHouse)
            }
        } else {
            monthlyHouse.forEach { (monthlyHouse) in
                try! realm.write {
                    monthlyHouse.totalPrice = monthlyHouse.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mTaxCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyTax = realm.objects(MonthlyTax.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyTax.count == 0 {
            let monthlyTax = MonthlyTax()
            monthlyTax.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyTax.category = "税・社会保険"
            monthlyTax.timestamp = yearMonthTotal
            monthlyTax.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyTax.date = yyyy_mm2
            monthlyTax.year = year2
            monthlyTax.month = month2
            try! realm.write {
                realm.add(monthlyTax)
            }
        } else {
            monthlyTax.forEach { (monthlyTax) in
                try! realm.write {
                    monthlyTax.totalPrice = monthlyTax.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mInsranceCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyInsrance = realm.objects(MonthlyInsrance.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyInsrance.count == 0 {
            let monthlyInsrance = MonthlyInsrance()
            monthlyInsrance.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyInsrance.category = "保険"
            monthlyInsrance.timestamp = yearMonthTotal
            monthlyInsrance.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyInsrance.date = yyyy_mm2
            monthlyInsrance.year = year2
            monthlyInsrance.month = month2
            try! realm.write {
                realm.add(monthlyInsrance)
            }
        } else {
            monthlyInsrance.forEach { (monthlyInsrance) in
                try! realm.write {
                    monthlyInsrance.totalPrice = monthlyInsrance.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mEtcetoraCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyEtcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyEtcetora.count == 0 {
            let monthlyEtcetora = MonthlyEtcetora()
            monthlyEtcetora.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyEtcetora.category = "その他"
            monthlyEtcetora.timestamp = yearMonthTotal
            monthlyEtcetora.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyEtcetora.date = yyyy_mm2
            monthlyEtcetora.year = year2
            monthlyEtcetora.month = month2
            try! realm.write {
                realm.add(monthlyEtcetora)
            }
        } else {
            monthlyEtcetora.forEach { (monthlyEtcetora) in
                try! realm.write {
                    monthlyEtcetora.totalPrice = monthlyEtcetora.totalPrice + Int(numberLabel.text!)!
                }
            }
        }
    }
    
    private func mUnCategoryCreate(_ yearMonthTotal: String, _ firstDayString: String, _ lastDayString: String) {
        
        let realm = try! Realm()
        let monthlyUnCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(year2)'").filter("month == '\(month2)'")
        
        if monthlyUnCategory.count == 0 {
            let monthlyUnCategory = MonthlyUnCategory()
            monthlyUnCategory.totalPrice = Int(numberLabel.text!) ?? 0
            monthlyUnCategory.category = "未分類"
            monthlyUnCategory.timestamp = yearMonthTotal
            monthlyUnCategory.monthly = "(\(firstDayString)~\(lastDayString))"
            monthlyUnCategory.date = yyyy_mm2
            monthlyUnCategory.year = year2
            monthlyUnCategory.month = month2
            try! realm.write {
                realm.add(monthlyUnCategory)
            }
        } else {
            monthlyUnCategory.forEach { (monthlyUnCategory) in
                try! realm.write {
                    monthlyUnCategory.totalPrice = monthlyUnCategory.totalPrice + Int(numberLabel.text!)!
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
        if numberLabel.text!.count > 10 { return }
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
