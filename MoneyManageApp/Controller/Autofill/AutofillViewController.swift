//
//  AutofillViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/10.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class AutofillViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var autoArray = [Auto]()
    private var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        navigationItem.title = "自動入力"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAuto()
    }
    
    private func fetchAuto() {
        
        let realm = try! Realm()
        
        autoArray.removeAll()
        let auto = realm.objects(Auto.self)
        autoArray.append(contentsOf: auto)
        autoArray = autoArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        tableView.reloadData()
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditAutoItemVC" {
            let editAutoItemVC = segue.destination as! EditAutoItemViewController
            editAutoItemVC.id = id
        }
    }
}

extension AutofillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + 1 + autoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! IncomeCategoryTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! AutofillListTableViewCell
        
        if indexPath.row == 0 {
            return cell1
        } else if indexPath.row == 1 {
            return cell2!
        }
        
        cell3.configureAutoCell(autoArray[indexPath.row - 2])
        return cell3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row >= 2 {
            let auto = autoArray[indexPath.row - 2]
            id = auto.id
            performSegue(withIdentifier: "EditAutoItemVC", sender: nil)
        }
    }
}
