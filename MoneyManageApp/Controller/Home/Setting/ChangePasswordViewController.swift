//
//  ChangePasswordViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/21.
//

import UIKit
import PKHUD
import Firebase
import TextFieldEffects

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var newPasswordTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var emailTopConst: NSLayoutConstraint!
    @IBOutlet weak var newPasswordTopConst: NSLayoutConstraint!
    @IBOutlet weak var passwordTopConst: NSLayoutConstraint!
    @IBOutlet weak var topLabel1: UILabel!
    @IBOutlet weak var topLabel2: UILabel!
    @IBOutlet weak var topLabel3: UILabel!
    @IBOutlet weak var topLabelConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setSwipeBack()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func passwordButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" {
            HUD.flash(.labeledError(title: "", subtitle: "メールアドレスを入力してください"), delay: 1)
            generator.notificationOccurred(.error)
            return
        } else if newPasswordTextField.text == "" {
            HUD.flash(.labeledError(title: "", subtitle: "新しいパスワードを入力してください"), delay: 1)
            generator.notificationOccurred(.error)
            return
        } else if passwordTextField.text == "" {
            HUD.flash(.labeledError(title: "", subtitle: "今までのパスワードを入力してください"), delay: 1)
            generator.notificationOccurred(.error)
            return
        }
        emailTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        changePassword()
    }
    
    private func changePassword() {
        
        HUD.show(.progress)
        let email = emailTextField.text
        let password = passwordTextField.text
        let newPassword = newPasswordTextField.text
        let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("Error reauth: \(error.localizedDescription)")
                HUD.flash(.labeledError(title: "", subtitle: " メールアドレス、もしくはパスワードが誤っています "), delay: 2)
                generator.notificationOccurred(.error)
            } else {
                
                AuthService.changePassword(password: newPassword!) { (error) in
                    if let error = error {
                        print("Error change password: \(error.localizedDescription)")
                        HUD.flash(.labeledError(title: "", subtitle: "無効なパスワードです "), delay: 2)
                        generator.notificationOccurred(.error)
                    } else {
                        HUD.flash(.labeledSuccess(title: "", subtitle: "パスワードを変更しました"), delay: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        })
    }
    
    private func setup() {
        
        navigationItem.title = "パスワードの変更"
        emailTextField.delegate = self
        passwordTextField.delegate = self
        newPasswordTextField.delegate = self
        emailTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        emailTextField.placeholder = "メールアドレス"
        emailTextField.keyboardType = .emailAddress
        newPasswordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        newPasswordTextField.placeholder = "新しいパスワード"
        newPasswordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        passwordTextField.placeholder = "今までパスワード"
        passwordTextField.isSecureTextEntry = true
        
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
                    topLabel1.font = UIFont(name: "HiraMaruProN-W4", size: 17)
                    topLabel2.font = UIFont(name: "HiraMaruProN-W4", size: 17)
                    topLabel3.font = UIFont(name: "HiraMaruProN-W4", size: 17)
                    topLabelConst.constant = 15
                    emailTopConst.constant = 15
                    newPasswordTopConst.constant = 20
                    passwordTopConst.constant = 20
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
