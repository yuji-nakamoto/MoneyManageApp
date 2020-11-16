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
    
    private var categoryArray = [String]()
    private var priceArray = [Int]()
    private var monthCount = 0
    private var sendMonth = ""
    private var sendYear = ""
    private var updateTimestamp = ""
    private var category = ""

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
        
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            fetchIncome(month, year)
        } else {
            fetchSpending(month, year)
        }
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
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            fetchIncome(month, year)
        } else {
            fetchSpending(month, year)
        }
        collectionView.reloadData()
    }
    
    // MARK: - Fetch
    
    private func fetchSpending(_ month: String, _ year: String) {
        
        let realm = try! Realm()
        categoryArray.removeAll()
        priceArray.removeAll()
        
        let food = realm.objects(MonthlyFood.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let brush = realm.objects(MonthlyBrush.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let hobby = realm.objects(MonthlyHobby.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let dating = realm.objects(MonthlyDating.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let traffic = realm.objects(MonthlyTraffic.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let clothe = realm.objects(MonthlyClothe.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let health = realm.objects(MonthlyHealth.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let car = realm.objects(MonthlyCar.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let education = realm.objects(MonthlyEducation.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let special = realm.objects(MonthlySpecial.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let card = realm.objects(MonthlyCard.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let utility = realm.objects(MonthlyUtility.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let communication = realm.objects(MonthlyCommunication.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let house = realm.objects(MonthlyHouse.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let tax = realm.objects(MonthlyTax.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let insrance = realm.objects(MonthlyInsrance.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let etcetora = realm.objects(MonthlyEtcetora.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let unCategory = realm.objects(MonthlyUnCategory.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        food.forEach { (food) in
            categoryArray.append(food.category)
            priceArray.append(food.totalPrice)
        }
        brush.forEach { (brush) in
            categoryArray.append(brush.category)
            priceArray.append(brush.totalPrice)
        }
        hobby.forEach { (hobby) in
            categoryArray.append(hobby.category)
            priceArray.append(hobby.totalPrice)
        }
        dating.forEach { (dating) in
            categoryArray.append(dating.category)
            priceArray.append(dating.totalPrice)
        }
        traffic.forEach { (traffic) in
            categoryArray.append(traffic.category)
            priceArray.append(traffic.totalPrice)
        }
        clothe.forEach { (clothe) in
            categoryArray.append(clothe.category)
            priceArray.append(clothe.totalPrice)
        }
        health.forEach { (health) in
            categoryArray.append(health.category)
            priceArray.append(health.totalPrice)
        }
        car.forEach { (car) in
            categoryArray.append(car.category)
            priceArray.append(car.totalPrice)
        }
        education.forEach { (education) in
            categoryArray.append(education.category)
            priceArray.append(education.totalPrice)
        }
        special.forEach { (special) in
            categoryArray.append(special.category)
            priceArray.append(special.totalPrice)
        }
        card.forEach { (card) in
            categoryArray.append(card.category)
            priceArray.append(card.totalPrice)
        }
        utility.forEach { (utility) in
            categoryArray.append(utility.category)
            priceArray.append(utility.totalPrice)
        }
        communication.forEach { (communication) in
            categoryArray.append(communication.category)
            priceArray.append(communication.totalPrice)
        }
        house.forEach { (house) in
            categoryArray.append(house.category)
            priceArray.append(house.totalPrice)
        }
        tax.forEach { (tax) in
            categoryArray.append(tax.category)
            priceArray.append(tax.totalPrice)
        }
        insrance.forEach { (insrance) in
            categoryArray.append(insrance.category)
            priceArray.append(insrance.totalPrice)
        }
        etcetora.forEach { (etcetora) in
            categoryArray.append(etcetora.category)
            priceArray.append(etcetora.totalPrice)
        }
        unCategory.forEach { (unCategory) in
            categoryArray.append(unCategory.category)
            priceArray.append(unCategory.totalPrice)
        }
        tableView.reloadData()
    }
    
    private func fetchIncome(_ month: String, _ year: String) {
        
        let realm = try! Realm()
        categoryArray.removeAll()
        priceArray.removeAll()
        
        let salary = realm.objects(MonthlySalary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let temporary = realm.objects(MonthlyTemporary.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let business = realm.objects(MonthlyBusiness.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let pension = realm.objects(MonthlyPension.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let devident = realm.objects(MonthlyDevident.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let estate = realm.objects(MonthlyEstate.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let payment = realm.objects(MonthlyPayment.self).filter("year == '\(year)'").filter("month == '\(month)'")
        let unCategory2 = realm.objects(MonthlyUnCategory2.self).filter("year == '\(year)'").filter("month == '\(month)'")
        
        salary.forEach { (salary) in
            categoryArray.append(salary.category)
            priceArray.append(salary.totalPrice)
        }
        temporary.forEach { (temporary) in
            categoryArray.append(temporary.category)
            priceArray.append(temporary.totalPrice)
        }
        business.forEach { (business) in
            categoryArray.append(business.category)
            priceArray.append(business.totalPrice)
        }
        pension.forEach { (pension) in
            categoryArray.append(pension.category)
            priceArray.append(pension.totalPrice)
        }
        devident.forEach { (devident) in
            categoryArray.append(devident.category)
            priceArray.append(devident.totalPrice)
        }
        estate.forEach { (estate) in
            categoryArray.append(estate.category)
            priceArray.append(estate.totalPrice)
        }
        payment.forEach { (payment) in
            categoryArray.append(payment.category)
            priceArray.append(payment.totalPrice)
        }
        unCategory2.forEach { (unCategory2) in
            categoryArray.append(unCategory2.category)
            priceArray.append(unCategory2.totalPrice)
        }
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8398635124"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setup() {
        
        sendMonth = month
        sendYear = year
        updateTimestamp = timestamp
        tableView.tableFooterView = UIView()
        collectionView.addBorder(1, color: .systemGray5, alpha: 1)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
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
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            detailVC.category = category
            detailVC.year = sendYear
            detailVC.month = sendMonth
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
            return categoryArray.count
        }
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HouseholdABTableViewCell
 
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            cell.incomeCell(categoryArray[indexPath.row], priceArray[indexPath.row])
            return cell
        }
        cell.spendingCell(categoryArray[indexPath.row], priceArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if UserDefaults.standard.object(forKey: CHANGE) != nil {
            category = categoryArray[indexPath.row]
            performSegue(withIdentifier: "DetailVC", sender: nil)
        } else {
            category = categoryArray[indexPath.row]
            performSegue(withIdentifier: "DetailVC", sender: nil)
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
