//
//  ResetTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import PKHUD
import RealmSwift

class ResetTableViewController: UITableViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetSwitch: UISwitch!
    private let realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.layer.cornerRadius = 10
        if resetSwitch.isOn {
            resetButton.isEnabled = true
        } else {
            resetButton.isEnabled = false
        }
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor(named: O_BLACK) as Any]
        navigationItem.title = "データリセット"
    }
    
    @IBAction func backButtonPressd(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onResetSwitch(_ sender: UISwitch) {
        if sender.isOn {
            resetButton.isEnabled = true
        } else {
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "データをリセットしますか？", preferredStyle: .actionSheet)
        let reset = UIAlertAction(title: "データをリセットする", style: UIAlertAction.Style.default) { [self] (alert) in
            
            try! realm!.write {
                realm!.deleteAll()
                HUD.flash(.labeledSuccess(title: "", subtitle: "データをリセットしました"), delay: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let screenSize = UIScreen.main.bounds
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        alert.addAction(reset)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
}