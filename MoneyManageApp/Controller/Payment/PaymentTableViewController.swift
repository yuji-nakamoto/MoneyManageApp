//
//  PaymentTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import EmptyDataSet_Swift
import RealmSwift
import GoogleMobileAds

class PaymentTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButtonWidth: NSLayoutConstraint!
    
    private var incomeArray = [Income]()
    private var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setSearchBar()
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.removeObject(forKey: INCOME_ID)
        fetchIncome()
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let sortListVC = storyboard.instantiateViewController(withIdentifier: "SortListVC")
        sortListVC.presentationController?.delegate = self
        self.present(sortListVC, animated: true, completion: nil)
    }
    
    private func fetchIncome() {
        
        let realm = try! Realm()
        let income = realm.objects(Income.self)
        incomeArray.removeAll()
        incomeArray.append(contentsOf: income)
        
        if UserDefaults.standard.object(forKey: DATE_ASCE) != nil {
            incomeArray = incomeArray.sorted(by: { (a, b) -> Bool in
                return a.date < b.date
            })
        } else if UserDefaults.standard.object(forKey: PRICE_DESC) != nil {
            incomeArray = incomeArray.sorted(by: { (a, b) -> Bool in
                return a.price > b.price
            })
        } else if UserDefaults.standard.object(forKey: PRICE_ASCE) != nil {
            incomeArray = incomeArray.sorted(by: { (a, b) -> Bool in
                return a.price < b.price
            })
        } else if UserDefaults.standard.object(forKey: CATEGORY_DESC) != nil {
            incomeArray = incomeArray.sorted(by: { (a, b) -> Bool in
                return a.category > b.category
            })
        } else {
            incomeArray = incomeArray.sorted(by: { (a, b) -> Bool in
                return a.date > b.date
            })
        }
        tableView.reloadData()
    }
    
    private func doSearch() {
        
        let realm = try! Realm()
        let spending = realm.objects(Income.self).filter("memo CONTAINS '\(searchBar.text ?? "")'")
        
        incomeArray.removeAll()
        incomeArray.append(contentsOf: spending)
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
    
    private func setup() {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        sortButton.layer.cornerRadius = 35 / 2
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

extension PaymentTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentTableViewCell
        
        cell.configureIncomeCell(incomeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        id = incomeArray[indexPath.row].id
        
        UserDefaults.standard.set(id, forKey: INCOME_ID)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let editIncomeVC = storyboard.instantiateViewController(withIdentifier: "EditIncomeVC")
        editIncomeVC.presentationController?.delegate = self
        self.present(editIncomeVC, animated: true, completion: nil)
    }
}

extension PaymentTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "入金はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2 as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "入力タブから入金（収入）を作成できます", attributes: attributes)
    }
}

extension PaymentTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        incomeArray.removeAll()
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
        fetchIncome()
    }
}

extension PaymentTableViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    fetchIncome()
  }
}
