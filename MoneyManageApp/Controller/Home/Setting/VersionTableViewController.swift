//
//  VersionTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/24.
//

import UIKit

class VersionTableViewController: UITableViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        logoImageView.layer.cornerRadius = 10
        navigationItem.title = "バージョン情報"
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
