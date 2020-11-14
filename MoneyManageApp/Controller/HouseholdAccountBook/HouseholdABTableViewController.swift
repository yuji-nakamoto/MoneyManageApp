//
//  HouseholdABTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/08.
//

import UIKit
import GoogleMobileAds
import RealmSwift
import EmptyDataSet_Swift

class HouseholdABTableViewController: UIViewController {
    
    // MARK: - Propeties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var spendingArray = [Spending]()
    private var incomeArray = [Income]()
    private var monthCount = 0
    private var sendMonth = ""
    private var sendYear = ""
    private var updateTimestamp = ""

    private var timestamp: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年M月"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupBanner()
        viewHeightChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        setupTopLabel(sendMonth, sendYear, updateTimestamp)
        collectionView.reloadData()
        
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            fetchIncome(sendMonth, sendYear)
        } else {
            fetchSpending(sendMonth, sendYear)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func nextMonthButtonPressd(_ sender: Any) {
        
        monthCount += 1
        
        let nextMonth = calendar.date(byAdding: .month, value: monthCount, to: firstday!)

        var month: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: nextMonth!)
        }
        var year: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: nextMonth!)
        }
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月"
            return dateFormatter.string(from: nextMonth!)
        }
        
        sendMonth = month
        sendYear = year
        updateTimestamp = timestamp
        setupTopLabel(month, year, timestamp)
        
        fetchSpending(month, year)
        fetchIncome(month, year)
        collectionView.reloadData()
    }
    
    @IBAction func lastMonthButtonPressed(_ sender: Any) {
        
        monthCount -= 1
        
        let lastMonth = calendar.date(byAdding: .month, value: monthCount, to: firstday!)
        var month: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: lastMonth!)
        }
        var year: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: lastMonth!)
        }
        var timestamp: String {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年M月"
            return dateFormatter.string(from: lastMonth!)
        }
        
        sendMonth = month
        sendYear = year
        updateTimestamp = timestamp
        
        setupTopLabel(month, year, timestamp)
        fetchSpending(month, year)
        fetchIncome(month, year)
        collectionView.reloadData()
    }
    
    // MARK: - Fetch
    
    private func fetchSpending(_ month: String, _ year: String) {
        
        let realm = try! Realm()
        
        spendingArray.removeAll()
        let spending = realm.objects(Spending.self).filter("month == '\(month)'").filter("year == '\(year)'")
        spendingArray.append(contentsOf: spending)
        spendingArray = spendingArray.sorted(by: { (a, b) -> Bool in
            return a.price > b.price
        })
        tableView.reloadData()
    }
    
    private func fetchIncome(_ month: String, _ year: String) {
        
        let realm = try! Realm()
       
        incomeArray.removeAll()
        let income = realm.objects(Income.self).filter("month == '\(month)'").filter("year == '\(year)'")
        incomeArray.append(contentsOf: income)
        incomeArray = incomeArray.sorted(by: { (a, b) -> Bool in
            return a.price > b.price
        })
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    private func setup() {
        
        sendMonth = month
        sendYear = year
        updateTimestamp = timestamp
        tableView.tableFooterView = UIView()
        collectionView.addBorder(1, color: .systemGray5, alpha: 1)
    }
    
    private func setupTopLabel(_ month: String, _ year: String, _ timestamp: String) {
        
        let realm = try! Realm()
        let spenResults = realm.objects(Spending.self).filter("month == '\(month)'").filter("year == '\(year)'")
        let incomeResults = realm.objects(Income.self).filter("month == '\(month)'").filter("year == '\(year)'")
        
        let totalSpending = spenResults.reduce(0) { (result, spending) -> Int in
            return result + spending.price
        }
        let totalIncome = incomeResults.reduce(0) { (result, income) -> Int in
            return result + income.price
        }
        let balanceNumeric = totalIncome - totalSpending
        let result1 = String.localizedStringWithFormat("%d", totalIncome)
        let result2 = String.localizedStringWithFormat("%d", totalSpending)
        let result3 = String.localizedStringWithFormat("%d", balanceNumeric)
        
        incomeLabel.text = "¥" + String(result1)
        spendingLabel.text = "¥-" + String(result2)
        balanceLabel.text = "¥" + String(result3)
        dateLabel.text = timestamp
    }
    
    private func viewHeightChange() {
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            viewHeightConstraint.constant = 95
            topConstraint.constant = 25
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditSpendingVC" {
            let editSpendingVC = segue.destination as! EditSpendingViewController
            let spending = sender as! Spending
            editSpendingVC.spending = spending
        }
        
        if segue.identifier == "EditIncomeVC" {
            let editIncomeVC = segue.destination as! EditIncomeViewController
            let income = sender as! Income
            editIncomeVC.income = income
        }
    }
}

// MARK: - Collection view

extension HouseholdABTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HouseholdABCollectionViewCell
        
        cell.householdVC = self
        cell.configureCharts(month: sendMonth, year: sendYear)
        return cell
    }
}

// MARK: - Table view

extension HouseholdABTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            return incomeArray.count
        }
        return spendingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HouseholdABTableViewCell
 
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            cell.configureIncomeCell(incomeArray[indexPath.row])
            return cell
        }
        cell.configureSpendingCell(spendingArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            performSegue(withIdentifier: "EditIncomeVC", sender: incomeArray[indexPath.row])
        } else {
            performSegue(withIdentifier: "EditSpendingVC", sender: spendingArray[indexPath.row])
        }
    }
}

extension HouseholdABTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "\(sendYear)年\(sendMonth)月の家計簿は作成していません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2 as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "入力タブから作成できます", attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 50
    }
}
