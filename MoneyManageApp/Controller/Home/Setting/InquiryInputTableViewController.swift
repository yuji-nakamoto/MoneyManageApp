//
//  InquiryInputTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import PKHUD

class InquryInputViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveTextView()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func saveTextView() {
        
        if textView.text.count > 500 {
            HUD.flash(.labeledError(title: "", subtitle: "文字数制限です"), delay: 1)
            generator.notificationOccurred(.error)
        } else {
            UserDefaults.standard.set(textView.text, forKey: "inquiry")
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor(named: O_BLACK) as Any]
        navigationItem.title = "お問い合わせ内容"
        saveButton.layer.cornerRadius = 15
        backView.backgroundColor = .clear
        backView.layer .cornerRadius = 5
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.systemGray.cgColor
        tableView.separatorStyle = .none
        textView.delegate = self
        
        if UserDefaults.standard.object(forKey: "inquiry") != nil {
            let text = UserDefaults.standard.object(forKey: "inquiry")
            textView.text = (text as! String)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let reportNum = 500 - textView.text.count
        if reportNum < 0 {
            countLabel.text = "文字数制限です"
        } else {
            countLabel.text = String(reportNum)
        }
    }
}
