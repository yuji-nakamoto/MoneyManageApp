//
//  OpinionTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import Firebase
import PKHUD

class OpinionTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var opinionLabel: UILabel!
    @IBOutlet weak var inputLabel2: UILabel!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if opinionLabel.text == "ご意見・ご要望・改善等" {
            HUD.flash(.labeledError(title: "", subtitle: "内容を入力してください"), delay: 1)
            generator.notificationOccurred(.error)
            return
        }
        saveOpinion()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func saveOpinion() {
        
        let dict = ["opinion": opinionLabel.text!,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_OPINION.addDocument(data: dict)
        UserDefaults.standard.removeObject(forKey: "opinion")
        HUD.flash(.labeledSuccess(title: "", subtitle: "送信しました"), delay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setup() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor(named: O_BLACK) as Any]
        navigationItem.title = "ご意見・ご要望・改善等"
        sendButton.layer.cornerRadius = 15
        
        if UserDefaults.standard.object(forKey: "opinion") != nil {
            let text = UserDefaults.standard.object(forKey: "opinion")
            if text as! String == "" {
                opinionLabel.text = "ご意見・ご要望・改善等"
                inputLabel2.isHidden = false
                return
            }
            opinionLabel.text = (text as! String)
            inputLabel2.isHidden = true
        } else {
            opinionLabel.text = "ご意見・ご要望・改善等"
            inputLabel2.isHidden = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
