//
//  InquiryTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import PKHUD
import Firebase

class InquiryTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var inquiryLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLIneHeight: NSLayoutConstraint!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if inquiryLabel.text == "お問い合わせ内容" {
            HUD.flash(.labeledError(title: "", subtitle: "内容を入力してください"), delay: 1)
            return
        }
        
        if emailTextField.text == "" {
            HUD.flash(.labeledError(title: "", subtitle: "メールアドレスを入力してください"), delay: 1)
            return
        }
        saveInquiry()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helpers
    
    private func saveInquiry() {
        
        let dict = ["email": emailTextField.text!,
                    "inquiry": inquiryLabel.text!,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_INQUIRY.addDocument(data: dict)
        UserDefaults.standard.removeObject(forKey: "inquiry")
        HUD.flash(.labeledSuccess(title: "", subtitle: "送信しました"), delay: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setup() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor(named: O_BLACK) as Any]
        navigationItem.title = "お問い合わせ"
        sendButton.layer.cornerRadius = 15
        
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailTextFieldTap), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailLabelDown), for: .editingDidEnd)
        emailTextField.keyboardType = .emailAddress
        
        if UserDefaults.standard.object(forKey: "inquiry") != nil {
            let text = UserDefaults.standard.object(forKey: "inquiry")
            if text as! String == "" {
                inquiryLabel.text = "お問い合わせ内容"
                inputLabel.isHidden = false
                return
            }
            inquiryLabel.text = (text as! String)
            inputLabel.isHidden = true
        } else {
            inquiryLabel.text = "お問い合わせ内容"
            inputLabel.isHidden = false
        }
    }
    
    @objc func emailTextFieldTap() {
        emailTopConstraint.constant = 20
        emailLIneHeight.constant = 2
        emailLineView.backgroundColor = UIColor(named: CARROT_ORANGE)
    }
    
    @objc func emailLabelDown() {
        if emailTextField.text == "" {
            emailTopConstraint.constant = 40
            emailLIneHeight.constant = 1
            emailLineView.backgroundColor = UIColor(named: O_BLUE)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
