//
//  EditAutoItemViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/10.
//

import UIKit
import PKHUD
import RealmSwift

class EditAutoItemViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var caluclatorView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberLabel2: UILabel!
    @IBOutlet weak var textField: UITextField!
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
    @IBOutlet weak var pickerKeyboardView: PickerKeyboard1!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var numberLbl2TopConst: NSLayoutConstraint!
    @IBOutlet weak var numberLbl2BottomConst: NSLayoutConstraint!
    @IBOutlet weak var enMarkLabel: UILabel!
    @IBOutlet weak var categoryImageTopConst: NSLayoutConstraint!
    @IBOutlet weak var categoryImageBottomConst: NSLayoutConstraint!
    @IBOutlet weak var calenderImageTopConst: NSLayoutConstraint!
    @IBOutlet weak var calenderImageBottomConst: NSLayoutConstraint!
    
    lazy var buttons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, clearButton, multiplyButton, minusButton, plusButton, devideButton]
    private var firstNumeric = false
    private var lastNumeric = false
    private var inputNumber = 0
    private var autoArray = [Auto]()
    private var month = 0
    var id = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setSwipeBack()
        fetchAuto()
    }
    
    // MARK: - Fetch
    
    private func fetchAuto() {
        
        let realm = try! Realm()
        let auto = realm.objects(Auto.self).filter("id == '\(id)'")
        
        autoArray.removeAll()
        autoArray.append(contentsOf: auto)
        autoArray = autoArray.sorted(by: { (a, b) -> Bool in
            return a.payment > b.payment
        })
        
        autoArray.forEach { (auto) in
            numberLabel.text = String(auto.price)
            
            let number = Int(numberLabel.text!)
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            let result: String = formatter.string(from: NSNumber.init(integerLiteral: number!))!
            numberLabel2.text = result
            dateLabel.text = auto.autofillDay
            textField.text = auto.memo
            month = auto.month
            conversionDay()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let realm = try! Realm()

        autoArray.forEach { (auto) in
            let alert = UIAlertController(title: auto.category, message: "自動入力を削除しますか？", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                try! realm.write {
                    realm.delete(auto)
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
        updateAutoItem()
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
    
    private func updateAutoItem() {
        
        let realm = try! Realm()
        let calendar = Calendar.current
        
        autoArray.forEach { (auto) in
            
            if auto.isInput == true && auto.onRegister == true {
                
                var dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: auto.day))
                let dateComp2 = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: inputNumber))
                
                try! realm.write {
                    
                    if inputNumber == 29 {
                        
                        inputNumber = Int(lastDayString)!
                        dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: inputNumber))
                        formatterFunc(auto: auto, date: dateComp!)
                        
                    } else if inputNumber >= 1 || inputNumber < 29 {
                        formatterFunc(auto: auto, date: dateComp2!)
                    }
                    setAutoData(auto)
                    navigationController?.popViewController(animated: true)
                }
            } else if auto.isInput == true && auto.onRegister == false {
                
                var dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: auto.day))
                let dateComp2 = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: inputNumber))
                
                try! realm.write {
                    
                    if inputNumber == 29 {
                        
                        inputNumber = Int(lastDay2String)!
                        dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: inputNumber))
                        formatterFunc(auto: auto, date: dateComp!)
                        
                    } else if inputNumber >= 1 || inputNumber < 29 {
                        formatterFunc(auto: auto, date: dateComp2!)
                    }
                    setAutoData(auto)
                    navigationController?.popViewController(animated: true)
                }
            } else if auto.isInput == false && auto.onRegister == false {
                
                var dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: auto.day))
                let dateComp2 = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: inputNumber))
                
                try! realm.write {
                    
                    if inputNumber == 29 {
                        
                        inputNumber = Int(lastDayString)!
                        dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month, day: inputNumber))
                        formatterFunc(auto: auto, date: dateComp!)
                        
                    } else if inputNumber >= 1 || inputNumber < 29 {
                        formatterFunc(auto: auto, date: dateComp2!)
                    }
                    setAutoData(auto)
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func formatterFunc(auto: Auto, date: Date) {
        
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
        auto.day = inputNumber
    }
    
    private func setAutoData(_ auto: Auto) {
        auto.price = Int(numberLabel.text!) ?? 0
        auto.memo = textField.text ?? ""
        auto.autofillDay = dateLabel.text ?? ""
        auto.month = self.month
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
        
        navigationItem.title = "自動入力の編集"
        pickerKeyboardView.delegate = self
        textField.delegate = self
        numberLabel.isHidden = true
        deleteButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        buttons.forEach({ $0?.layer.borderWidth = 0.3; $0?.layer.borderColor = UIColor.systemGray.cgColor })
        textField.addTarget(self, action: #selector(textFieldTap), for: .editingDidBegin)
        
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
        caluclatorView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    private func conversionDay() {
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

extension EditAutoItemViewController: PickerKeyboard1Delegate {
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
            conversionDay()
        }
    }
}
