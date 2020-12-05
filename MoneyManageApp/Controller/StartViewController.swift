//
//  StartViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/13.
//

import UIKit
import Firebase
import PKHUD
import RealmSwift
import TextFieldEffects

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var moneyIdTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var loginBottomConst: NSLayoutConstraint!
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNotice()
        checkCreateUser()
        print("Realm URL: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
    }
    
    // MARK: - Actions
    
    @IBAction func useButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "利用をはじめますか？", preferredStyle: .alert)
        let start = UIAlertAction(title: "はじめる", style: UIAlertAction.Style.default) { [self] (alert) in
            createAccount()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(start)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()
    }
    
    
    
    // MARK: - login
    
    private func login() {
        
        let realm = try! Realm()
        let rUserArray = realm.objects(RUser.self)
        let rUser = RUser()
        
        if moneyIdTextField.text == "" {
            HUD.flash(.labeledError(title: "", subtitle: "マネーマネージIDを入力してください"), delay: 1)
            generator.notificationOccurred(.error)
            return
        } else if passwordTextField.text == "" {
            HUD.flash(.labeledError(title: "", subtitle: "パスワードを入力してください"), delay: 1)
            generator.notificationOccurred(.error)
            return
        }
        
        HUD.show(.progress)
        AuthService.loginUser(email: moneyIdTextField.text!, password: passwordTextField.text!) { [self] (error) in
            if let error = error {
                print("Error create user: \(error.localizedDescription)")
                HUD.flash(.labeledError(title: "", subtitle: "マネーマネージID、もしくはパスワードが誤っています"), delay: 2)
                generator.notificationOccurred(.error)
                return
            }
            try! realm.write() {
                realm.delete(rUserArray)
            }
            rUser.manageId = moneyIdTextField.text!
            rUser.password = passwordTextField.text!
            rUser.uid = Auth.auth().currentUser!.uid
            try! realm.write() {
                realm.add(rUser)
            }
            HUD.flash(.labeledSuccess(title: "", subtitle: "ログインしました"), delay: 1)
            toTabVC()
        }
    }
    
    // MARK: - Create account
    
    private func createAccount() {
        
        let realm = try! Realm()
        let rUserArray = realm.objects(RUser.self)
        let rUser = RUser()
        let uid = UUID().uuidString
        let password = randomString(length: 10)
        let manageId = uid.prefix(10) + "@money.manage"
        
        HUD.show(.progress)
        AuthService.createUser(email: String(manageId), password: password) { [self] (error) in
            if let error = error {
                print("Error create user: \(error.localizedDescription)")
                HUD.flash(.labeledError(title: "", subtitle: "ユーザー情報の作成に\n失敗しました"), delay: 2)
                generator.notificationOccurred(.error)
                createAccount()
                return
            }
            try! realm.write() {
                realm.delete(rUserArray)
            }
            rUser.uid = Auth.auth().currentUser!.uid
            rUser.manageId = String(manageId)
            rUser.password = password
            try! realm.write() {
                realm.add(rUser)
            }
            User.saveUser(uid: Auth.auth().currentUser!.uid, manegeId: String(manageId))
            HUD.flash(.labeledSuccess(title: "", subtitle: "ユーザー情報を作成しました"), delay: 1)
            toTabVC()
        }
    }
    
    // MARK: - Helpers
    
    private func checkCreateUser() {
        
        if Auth.auth().currentUser != nil {
            toTabVC()
        } else {
            showEffectView()
        }
    }
    
    private func toTabVC() {
        UserDefaults.standard.removeObject(forKey: TIME_OUT)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            if UserDefaults.standard.object(forKey: END_TUTORIAL) != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
                self.present(tabVC, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tutorial1VC = storyboard.instantiateViewController(withIdentifier: "Tutorial1VC")
                self.present(tutorial1VC, animated: true, completion: nil)
            }
        }
    }
    
    private func showEffectView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            visualEffectView.frame = self.view.frame
            view.addSubview(self.visualEffectView)
            visualEffectView.alpha = 0
            view.addSubview(loginView)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                visualEffectView.alpha = 1
                loginView.alpha = 1
            }, completion: nil)
        }
    }
    
    private func setNotice() {
        let realm = try! Realm()
        let noticeArray = realm.objects(Notice.self)
        let notice = Notice()
        
        if noticeArray.count == 0 {
            notice.noticeId1 = 1
            notice.noticeId2 = 2
            notice.noticeId3 = 3
            notice.noticeId4 = 4
            notice.noticeId5 = 5
            
            try! realm.write() {
                realm.add(notice)
            }
        }
    }
    
    private func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    private func setup() {
        loginView.alpha = 0
        logoImageView.layer.cornerRadius = 10
        
        moneyIdTextField.delegate = self
        passwordTextField.delegate = self
        moneyIdTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        moneyIdTextField.placeholder = "マネーマネージID"
        moneyIdTextField.keyboardType = .emailAddress
        passwordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        passwordTextField.placeholder = "パスワード"
        passwordTextField.isSecureTextEntry = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            loginBottomConst.constant = 0
        } else {
            if #available(iOS 11.0, *) {
                loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 70
                
                switch (UIScreen.main.nativeBounds.height) {
                case 1334:
                    loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height
                case 2048:
                    loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 40
                case 2160:
                    loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 45
                case 2208:
                    loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height
                case 2360:
                    loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 140
                case 2388:
                    loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 155
                case 2732:
                    loginBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 328
                default:
                    break
                }
            } else {
                loginBottomConst.constant = keyboardViewEndFrame.height
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
