//
//  WithdrawalViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import EmptyDataSet_Swift
import RealmSwift
import GoogleMobileAds

class WithdrawalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButtonWidth: NSLayoutConstraint!
    
    private var spendingArray = [Spending]()
    private var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setSearchBar()
        setupBanner()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        sortButton.layer.cornerRadius = 35 / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSpending()
    }

    private func fetchSpending() {
        
        let realm = try! Realm()
        let spending = realm.objects(Spending.self)
        spendingArray.removeAll()
        spendingArray.append(contentsOf: spending)
        
        if UserDefaults.standard.object(forKey: DATE_ASCE) != nil {
            spendingArray = spendingArray.sorted(by: { (a, b) -> Bool in
                return a.date < b.date
            })
        } else if UserDefaults.standard.object(forKey: PRICE_DESC) != nil {
            spendingArray = spendingArray.sorted(by: { (a, b) -> Bool in
                return a.price > b.price
            })
        } else if UserDefaults.standard.object(forKey: PRICE_ASCE) != nil {
            spendingArray = spendingArray.sorted(by: { (a, b) -> Bool in
                return a.price < b.price
            })
        } else if UserDefaults.standard.object(forKey: CATEGORY_DESC) != nil {
            spendingArray = spendingArray.sorted(by: { (a, b) -> Bool in
                return a.category > b.category
            })
        } else {
            spendingArray = spendingArray.sorted(by: { (a, b) -> Bool in
                return a.date > b.date
            })
        }
        tableView.reloadData()
    }
    
    private func doSearch() {
        
        let realm = try! Realm()
        let spending = realm.objects(Spending.self).filter("memo CONTAINS '\(searchBar.text ?? "")'")

        spendingArray.removeAll()
        spendingArray.append(contentsOf: spending)
        tableView.reloadData()
    }
    
    private func setSearchBar() {
        
        searchBar.delegate = self
        searchBar.placeholder = "内容を検索"
        searchBar.searchTextField.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/5819916703"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditSpendingVC" {
            let editSpendingVC = segue.destination as! EditSpendingViewController
            editSpendingVC.id = id
        }
    }
    
    private func setup() {
        
        switch (UIScreen.main.nativeBounds.height) {
        case 2048:
            changeLayout()
            break
        case 2160:
            changeLayout()
            break
        case 2360:
            changeLayout()
            break
        case 2388:
            changeLayout()
            break
        case 2732:
            changeLayout()
            break
        default:
            break
        }
    }
    
    private func changeLayout() {
        sortButtonWidth.constant = 250
    }
}

extension WithdrawalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentTableViewCell
        
        cell.configureWithdrawalCell(spendingArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        id = spendingArray[indexPath.row].id
        performSegue(withIdentifier: "EditSpendingVC", sender: nil)
    }
}

extension WithdrawalViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "出金はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2 as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "入力タブから出金（支出）を作成できます", attributes: attributes)
    }
}

extension WithdrawalViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        spendingArray.removeAll()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        fetchSpending()
    }
}
