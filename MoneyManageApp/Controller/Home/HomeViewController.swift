//
//  HomeViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/05.
//

import UIKit
import GoogleMobileAds
import RealmSwift
import AVFoundation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var autofillView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var player = AVAudioPlayer()
    private let soundFile = Bundle.main.path(forResource: "pa1", ofType: "mp3")
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var autoArray1 = [Auto]()
    private var autoArray2 = [Auto]()
    private var autoArray3 = [Auto]()
    private var autoArray4 = [Auto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        //        let realmURLs = [
        //            realmURL,
        //            realmURL.appendingPathExtension("lock"),
        //            realmURL.appendingPathExtension("note"),
        //            realmURL.appendingPathExtension("management")
        //        ]
        //        for URL in realmURLs {
        //            do {
        //                try FileManager.default.removeItem(at: URL)
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //                    self.navigationController?.popViewController(animated: true)
        //                }
        //            } catch {
        //                print(error.localizedDescription)
        //            }
        //        }
        
        setup()
        showHintView()
        setupBanner()
        removeUserDefaults()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if autofillView.isHidden == false {
            autofillView.isHidden = true
        }
        setupSound()
        isAutofill()
        tableView.reloadData()
    }
    
    @IBAction func closeButtonPressd(_ sender: Any) {
        UIView.animate(withDuration: 0.5) { [self] in
            self.autofillView.isHidden = !self.autofillView.isHidden
        }
    }
    
    @IBAction func closeButton2Pressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.hintView.alpha = 0
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: END_TUTORIAL2)
        }
    }
    
    private func isAutofill() {
        
        let realm = try! Realm()
        // 自動入力作成時 & 入出金反映時
        let auto1 = realm.objects(Auto.self).filter("isInput == false").filter("onRegister == false")
        // 自動入力反映後
        let auto2 = realm.objects(Auto.self).filter("isInput == true").filter("onRegister == false")
        // 入出金一覧から自動入力登録時
        // 入力作成時の自動入力登録時
        let auto3 = realm.objects(Auto.self).filter("isInput == true").filter("onRegister == true")
        
        autoArray1.removeAll()
        autoArray2.removeAll()
        autoArray3.removeAll()
        autoArray4.removeAll()
        autoArray1.append(contentsOf: auto1)
        autoArray2.append(contentsOf: auto2)
        autoArray3.append(contentsOf: auto3)
        
        autoArray1.forEach { (auto) in
            if yyyy_mm_dd >= auto.date {
                autoArray4.append(auto)
                writeData(auto)
            }
        }
        
        autoArray2.forEach { (auto) in
            if yyyy_mm_dd >= auto.nextMonth {
                try! realm.write {
                    auto.isInput = false
                }
                tableView.reloadData()
            }
        }
        
        autoArray3.forEach { (auto) in
            prepareUpdate(auto)
        }
    }
    
    private func writeData(_ auto: Auto) {
        
        let realm = try! Realm()
        var day = auto.day
        let calendar = Calendar.current
        var dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
        let nextDateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: 1))
        let spending = Spending()
        let income = Income()
        
        if auto.payment == "支出" {
            
            if auto.isRegister == true {
                spendingData(spending, auto)
                spending.isAutofill = true
                try! realm.write() {
                    realm.add(spending)
                }
                
            } else {
                spendingData(spending, auto)
                try! realm.write() {
                    realm.add(spending)
                }
            }
            
            try! realm.write {
                if auto.autofillDay == "月末" {
                    
                    day = Int(lastDay2String)!
                    dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                } else {
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                }
                auto.month = Int(month)! + 1
                auto.day = day
                auto.isInput = true
            }
            
            categoryLabel.text = spending.category
            if spending.memo == "" {
                memoLabel.text = spending.category
            } else {
                memoLabel.text = spending.memo
            }
            let result = String.localizedStringWithFormat("%d", spending.price)
            priceLabel.text = "¥" + result
            totalLabel.text = "合計\(autoArray4.count)件の自動入力を行いました"
            setCategorySpendingImage(spending)
            showAutofillView()
            
        } else {
            
            if auto.isRegister == true {
                incomeData(income, auto)
                income.isAutofill = true
                try! realm.write {
                    realm.add(income)
                }
            } else {
                incomeData(income, auto)
                try! realm.write {
                    realm.add(income)
                }
            }
            
            try! realm.write {
                if auto.autofillDay == "月末" {
                    
                    day = Int(lastDay2String)!
                    dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                } else {
                    formatterFunc1(auto, dateComp!, nextDateComp!)
                }
                auto.month = Int(month)! + 1
                auto.day = day
                auto.isInput = true
            }
            
            categoryLabel.text = income.category
            if income.memo == "" {
                memoLabel.text = income.category
            } else {
                memoLabel.text = income.memo
            }
            let result = String.localizedStringWithFormat("%d", income.price)
            priceLabel.text = "¥" + result
            totalLabel.text = "合計\(autoArray4.count)件の自動入力を行いました"
            setCategoryIncomeImage(income)
            showAutofillView()
        }
        tableView.reloadData()
    }
    
    private func prepareUpdate(_ auto: Auto) {
        
        var day = auto.day
        let calendar = Calendar.current
        var dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month + 1, day: day))
        let nextDateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: 1))
        
        if auto.autofillDay == "月末" {
            
            day = Int(lastDay2String)!
            dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
            formatterFunc2(auto, dateComp!, nextDateComp!, day)
        } else {
            formatterFunc2(auto, dateComp!, nextDateComp!, day)
        }
    }
    
    private func spendingData(_ spending: Spending, _ auto: Auto) {
        
        spending.price = auto.price
        spending.category = auto.category
        spending.memo = auto.memo
        spending.timestamp = auto.timestamp
        spending.date = auto.date
        spending.year = year
        spending.month = month
        spending.day = String(auto.day)
    }
    
    private func incomeData(_ income: Income, _ auto: Auto) {
        
        income.price = auto.price
        income.category = auto.category
        income.memo = auto.memo
        income.timestamp = auto.timestamp
        income.date = auto.date
        income.year = year
        income.month = month
        income.day = String(auto.day)
    }
    private func formatterFunc1(_ auto: Auto, _ date: Date, _ nextDate: Date) {
        
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: date)
        }
        var date: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        var nextMonth: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: nextDate)
        }
        auto.timestamp = timestamp
        auto.date = date
        auto.nextMonth = nextMonth
    }
    
    private func formatterFunc2(_ auto: Auto, _ date: Date, _ nextDate: Date, _ day: Int) {
        
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: date)
        }
        var date: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        var nextMonth: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: nextDate)
        }
        updateData(auto, timestamp, date, nextMonth, day)
    }
    
    private func updateData(_ auto: Auto, _ timestamp: String, _ date: String, _ nextMonth: String, _ day: Int) {
        
        let realm = try! Realm()
        
        try! realm.write {
            auto.timestamp = timestamp
            auto.date = date
            auto.month = auto.month + 1
            auto.day = day
            auto.nextMonth = nextMonth
            auto.onRegister = false
        }
        tableView.reloadData()
    }
    
    private func setup() {
        navigationItem.title = "ホーム"
        tableView.tableFooterView = UIView()
        hintView.alpha = 0
        hintView.layer.cornerRadius = 10
        closeButton.layer.cornerRadius = 30 / 2
        descriptionLabel.text = "以上でチュートリアルは終了です!\n操作が分からなくなった場合や、他のことも知りたい場合は、ホーム画面右上の歯車マークから'使い方'をタップで確認できます。\n\nまずは左上にある資産の登録を行いましょう！"
    }
    
    private func showAutofillView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.5) { [self] in
                if autoArray1.count != 1 || autoArray1.count != 3 || autoArray1.count != 5 || autoArray1.count != 7 || autoArray1.count != 9 {
                    
                    autofillView.isHidden = false
                } else {
                    self.autofillView.isHidden = !self.autofillView.isHidden
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    player.play()
                    player.numberOfLoops = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        UIView.animate(withDuration: 0.5) {
                            autofillView.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    private func showHintView() {
        
        if UserDefaults.standard.object(forKey: END_TUTORIAL2) == nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                
                visualEffectView.frame = self.view.frame
                view.addSubview(self.visualEffectView)
                visualEffectView.alpha = 0
                view.addSubview(hintView)
            
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    visualEffectView.alpha = 1
                    hintView.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    private func removeUserDefaults() {
        
        UserDefaults.standard.removeObject(forKey: PLUS)
        UserDefaults.standard.removeObject(forKey: MINUS)
        UserDefaults.standard.removeObject(forKey: MULTIPLY)
        UserDefaults.standard.removeObject(forKey: DEVIDE)
    }
    
    func setupSound() {
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFile!))
            player.prepareToPlay()
        } catch  {
            print("Error sound", error.localizedDescription)
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setCategorySpendingImage(_ spending: Spending) {
        
        if spending.category == "未分類" {
            categoryImageView.image = UIImage(systemName: "questionmark.circle")
            categoryImageView.tintColor = .systemGray
        } else if spending.category == "食費" {
            categoryImageView.image = UIImage(named: "food")
        } else if spending.category == "日用品" {
            categoryImageView.image = UIImage(named: "brush")
        } else if spending.category == "趣味" {
            categoryImageView.image = UIImage(named: "hobby")
        } else if spending.category == "交際費" {
            categoryImageView.image = UIImage(named: "dating")
        } else if spending.category == "交通費" {
            categoryImageView.image = UIImage(named: "traffic")
        } else if spending.category == "衣服・美容" {
            categoryImageView.image = UIImage(named: "clothe")
        } else if spending.category == "健康・医療" {
            categoryImageView.image = UIImage(named: "health")
        } else if spending.category == "自動車" {
            categoryImageView.image = UIImage(named: "car")
        } else if spending.category == "教養・教育" {
            categoryImageView.image = UIImage(named: "education")
        } else if spending.category == "特別な支出" {
            categoryImageView.image = UIImage(named: "special")
        } else if spending.category == "現金・カード" {
            categoryImageView.image = UIImage(named: "card")
        } else if spending.category == "水道・光熱費" {
            categoryImageView.image = UIImage(named: "utility")
        } else if spending.category == "通信費" {
            categoryImageView.image = UIImage(named: "communication")
        } else if spending.category == "住宅" {
            categoryImageView.image = UIImage(named: "house")
        } else if spending.category == "税・社会保険" {
            categoryImageView.image = UIImage(named: "tax")
        } else if spending.category == "保険" {
            categoryImageView.image = UIImage(named: "insrance")
        } else if spending.category == "その他" {
            categoryImageView.image = UIImage(named: "etcetra")
        }
    }
    
    private func setCategoryIncomeImage(_ income: Income) {
        
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
}

extension HomeViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TotalMoneyTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! BalanceTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3") as! BarChartTableViewCell
        
        if indexPath.row == 0 {
            cell1.fetchTotalMoney()
            return cell1
        } else if indexPath.row == 1 {
            cell2.homeVC = self
            cell2.fetchChart()
            return cell2
        }
        cell3.configureBarChartCell()
        return cell3
    }
}
