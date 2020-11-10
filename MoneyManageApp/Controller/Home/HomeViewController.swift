//
//  HomeViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/05.
//

import UIKit
import GoogleMobileAds
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var autoArray1 = [Auto]()
    private var autoArray2 = [Auto]()
    private var autoArray3 = [Auto]()
    private var spending = Spending()
    private var income = Income()
    private let realm = try? Realm()
    
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
        
        navigationItem.title = "ホーム"
        setupBanner()
        removeUserDefaults()
        tableView.tableFooterView = UIView()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAutoInput()
        tableView.reloadData()
    }
    
    private func writeData(_ auto: Auto) {
        
        var day = auto.day
        let calendar = Calendar.current
        var dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
        var lastDay2: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: lastday2!)
        }
        
        if auto.payment == "支出" {
            spending.price = auto.price
            spending.category = auto.category
            spending.memo = auto.memo
            spending.timestamp = auto.timestamp
            spending.date = auto.date
            spending.year = year
            spending.month = month
            try! realm!.write {
                realm!.add(spending)
                
                if auto.input_auto_day == "月末" {
                    
                    day = Int(lastDay2)!
                    dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
                    var timestamp: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
                        return dateFormatter.string(from: dateComp!)
                    }
                    var date: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        return dateFormatter.string(from: dateComp!)
                    }
                    auto.timestamp = timestamp
                    auto.date = date
                    
                } else {
                    
                    var timestamp: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
                        return dateFormatter.string(from: dateComp!)
                    }
                    var date: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        return dateFormatter.string(from: dateComp!)
                    }
                    auto.timestamp = timestamp
                    auto.date = date
                }
                auto.month = Int(month)! + 1
                auto.day = day
                auto.isInput = true
            }
            
        } else {
            income.price = auto.price
            income.category = auto.category
            income.memo = auto.memo
            income.timestamp = auto.timestamp
            income.date = auto.date
            income.year = year
            income.month = month
            try! realm!.write {
                realm!.add(income)
                
                if auto.input_auto_day == "月末" {

                    day = Int(lastDay2)!
                    dateComp = calendar.date(from: DateComponents(year: Int(year), month: Int(month)! + 1, day: day))
                    var timestamp: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
                        return dateFormatter.string(from: dateComp!)
                    }
                    var date: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        return dateFormatter.string(from: dateComp!)
                    }
                    auto.timestamp = timestamp
                    auto.date = date
                    
                } else {
                    
                    var timestamp: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
                        return dateFormatter.string(from: dateComp!)
                    }
                    var date: String {
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        return dateFormatter.string(from: dateComp!)
                    }
                    auto.timestamp = timestamp
                    auto.date = date
                }
                auto.month = Int(month)! + 1
                auto.day = day
                auto.isInput = true
            }
        }
    }
    
    private func isAutoInput() {
        
        let realm = try! Realm()
        let auto1 = realm.objects(Auto.self).filter("isInput == false").filter("isRegister == false")
        let auto2 = realm.objects(Auto.self).filter("isInput == true").filter("isRegister == false")
        let auto3 = realm.objects(Auto.self).filter("isInput == true").filter("isRegister == true")
        
        autoArray1.removeAll()
        autoArray2.removeAll()
        autoArray3.removeAll()
        autoArray1.append(contentsOf: auto1)
        autoArray2.append(contentsOf: auto2)
        autoArray3.append(contentsOf: auto3)
        
        autoArray1.forEach { (auto) in
            if year_month_day >= auto.date {
                writeData(auto)
            }
        }
        
        autoArray2.forEach { (auto) in
            if year_month_day >= auto.date {
                try! realm.write {
                    auto.isInput = false
                }
            }
        }
        
        autoArray3.forEach { (auto) in
            updateData(auto)
        }
        tableView.reloadData()
    }
    
    private func updateData(_ auto: Auto) {
        
        let calendar = Calendar.current
        let dateComp = calendar.date(from: DateComponents(year: Int(year), month: auto.month + 1, day: auto.day))
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月d日 (EEEEE)"
            return dateFormatter.string(from: dateComp!)
        }
        var date: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: dateComp!)
        }
        
        try! realm!.write {
            auto.timestamp = timestamp
            auto.date = date
            auto.month = auto.month + 1
            auto.isInput = false
            auto.isRegister = false
        }
    }
    
    private func removeUserDefaults() {
        
        UserDefaults.standard.removeObject(forKey: PLUS)
        UserDefaults.standard.removeObject(forKey: MINUS)
        UserDefaults.standard.removeObject(forKey: MULTIPLY)
        UserDefaults.standard.removeObject(forKey: DEVIDE)
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension HomeViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TotalMoneyTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! BalanceTableViewCell
        
        if indexPath.row == 0 {
            cell1.fetchTotalMoney()
            return cell1
        }
        cell2.homeVC = self
        cell2.fetchChart()
        return cell2
    }
}
