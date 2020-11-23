//
//  AccountTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/21.
//

import UIKit
import PKHUD

class AccountTableViewController: UITableViewController {
    
    private var user = User()
    private var userId = ""
    private var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setSwipeBack()
        navigationItem.title = "アカウント"
    }
    
    private func fetchUser() {
        User.fetchUser { (user) in
            self.user = user
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UserVC" {
            let userVC = segue.destination as! UserTableViewController
            userVC.userId = userId
            userVC.email = email
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if user.isLogin == false {
            HUD.flash(.labeledError(title: "", subtitle: "進むためにはログインが必要です"), delay: 1)
            generator.notificationOccurred(.error)
        } else if user.isLogin == true && indexPath.row == 0 {
            userId = user.uid
            email = user.email
            performSegue(withIdentifier: "UserVC", sender: nil)
        } else if user.isLogin == true && indexPath.row == 1 {
            performSegue(withIdentifier: "ChangeEmailVC", sender: nil)
        } else if user.isLogin == true && indexPath.row == 2 {
            performSegue(withIdentifier: "ChangePasswordVC", sender: nil)
        } else if user.isLogin == true && indexPath.row == 3 {
            performSegue(withIdentifier: "ForgetPasswordVC", sender: nil)
        }
    }
}
