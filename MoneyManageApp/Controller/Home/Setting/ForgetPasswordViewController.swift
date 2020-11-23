//
//  ForgetPasswordViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/21.
//

import UIKit
import PKHUD
import Firebase
import TextFieldEffects

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setSwipeBack()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" {
            HUD.flash(.labeledError(title: "", subtitle: "メールアドレスを入力してください"), delay: 1)
            generator.notificationOccurred(.error)
            return
        }
        emailTextField.resignFirstResponder()
        resetPassword()
    }
    
    private func resetPassword() {
        
        HUD.show(.progress)
        let email = emailTextField.text
        
        AuthService.resetPassword(email: email!) { (error) in
            if let error = error {
                print("Error resetPassword: \(error.localizedDescription)")
                HUD.flash(.labeledError(title: "", subtitle: " 無効なメールアドレスです "), delay: 2)
                generator.notificationOccurred(.error)
            } else {
                HUD.flash(.labeledSuccess(title: "", subtitle: "案内メールを送信しました"), delay: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func setup() {
        
        navigationItem.title = "パスワードをリセットする"
        emailTextField.delegate = self
        emailTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        emailTextField.placeholder = "メールアドレス"
        emailTextField.keyboardType = .emailAddress
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            emailTextField.becomeFirstResponder()
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewBottomConst.constant = 0
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 70

                switch (UIScreen.main.nativeBounds.height) {
                case 1334:
                    viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height
                    break
                case 2048:
                    viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 40
                    break
                case 2160:
                    viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 45
                    break
                case 2360:
                    viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 140
                    break
                case 2388:
                    viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 155
                    break
                case 2732:
                    viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 328
                    break
                default:
                    break
                }
            } else {
                viewBottomConst.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
