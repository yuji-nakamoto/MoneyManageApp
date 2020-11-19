//
//  SettingTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var animeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAnimeSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: ON_ANIME)
        } else {
            UserDefaults.standard.removeObject(forKey: ON_ANIME)
        }
    }
    
    private func setup() {
        
        if UserDefaults.standard.object(forKey: ON_ANIME) != nil {
            animeSwitch.isOn = true
        } else {
            animeSwitch.isOn = false
        }
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor(named: O_BLACK) as Any]
        navigationItem.title = "設定"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
