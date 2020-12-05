//
//  UserTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/22.
//

import UIKit
import RealmSwift

class UserTableViewController: UITableViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var eyeButton: UIButton!
    
    private var password = ""
    private var secure = "**********"

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        tableView.tableFooterView = UIView()
        navigationItem.title = "ユーザー情報"
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        let realm = try! Realm()
        let rUser = realm.objects(RUser.self)
        
        rUser.forEach { (u) in
            emailLabel.text = u.manageId
            passwordLabel.text = secure
            password = u.password
        }
    }
   
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func eyeButtonPressed(_ sender: Any) {
        if passwordLabel.text == secure {
            passwordLabel.text = password
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordLabel.text = secure
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
}
