//
//  Notice5TableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/12/04.
//

import UIKit
import RealmSwift

class Notice5TableViewController: UITableViewController {
    
    private var notice = FNotice()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotice()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchNotice() {
        
        let realm = try! Realm()
        let notice = realm.objects(Notice.self)
        
        FNotice.fetchNotice5 { (fn) in
            self.notice = fn
            self.navigationItem.title = self.notice.title
            self.tableView.reloadData()
            
            notice.forEach { (n) in
                try! realm.write() {
                    n.noticeId5 = self.notice.uid
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeTableViewCell
        
        cell.notice(notice)
        return cell
    }
}
