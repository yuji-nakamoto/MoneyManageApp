//
//  UserTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/22.
//

import UIKit

class UserTableViewController: UITableViewController {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var userId = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        tableView.tableFooterView = UIView()
        navigationItem.title = "ユーザー情報"
        userIdLabel.text = userId
        emailLabel.text = email
    }
   
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
