//
//  IncomeCategoryTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import GoogleMobileAds

class IncomeCategoryTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let categoryTitles = ["給与", "一時所得", "事業・副業", "年金", "配当所得", "不動産所得", "その他入金", "未分類"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        setupBanner()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "収入"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1880671698"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension IncomeCategoryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IncomeCategoryTableViewCell
        
        cell.incomeLabel.text = categoryTitles[indexPath.row]
        if indexPath.row == 0 {
            cell.categoryImageView.image = UIImage(named: "en_mark")
        } else if indexPath.row == 1 {
            cell.categoryImageView.image = UIImage(named: "en_mark")
        } else if indexPath.row == 2 {
            cell.categoryImageView.image = UIImage(named: "en_mark")
        } else if indexPath.row == 3 {
            cell.categoryImageView.image = UIImage(named: "en_mark")
        } else if indexPath.row == 4 {
            cell.categoryImageView.image = UIImage(named: "en_mark")
        } else if indexPath.row == 5 {
            cell.categoryImageView.image = UIImage(named: "en_mark")
        } else if indexPath.row == 6 {
            cell.categoryImageView.image = UIImage(named: "en_mark")
        } else if indexPath.row == 7 {
            cell.categoryImageView.image = UIImage(systemName: "questionmark.circle")
            cell.categoryImageView.tintColor = .systemGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: SALARY)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 1 {
            UserDefaults.standard.set(true, forKey: TEMPORARY)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 2 {
            UserDefaults.standard.set(true, forKey: BUSINESS)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 3 {
            UserDefaults.standard.set(true, forKey: PENSION)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 4 {
            UserDefaults.standard.set(true, forKey: DEVIDENT)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 5 {
            UserDefaults.standard.set(true, forKey: ESTATE)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 6 {
            UserDefaults.standard.set(true, forKey: PAYMENT)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 7 {
            UserDefaults.standard.set(true, forKey: UN_CATEGORY2)
            navigationController?.popViewController(animated: true)
        }
    }
}
