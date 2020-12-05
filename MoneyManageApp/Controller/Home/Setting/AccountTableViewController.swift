//
//  AccountTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/21.
//

import UIKit
import PKHUD

class AccountTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        navigationItem.title = "アカウント"
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "UserVC", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "ChangePasswordVC", sender: nil)
        }
    }
}
