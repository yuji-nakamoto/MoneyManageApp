//
//  SettingTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import PKHUD
import StoreKit

class SettingTableViewController: UITableViewController, SKStoreProductViewControllerDelegate {
    
    @IBOutlet weak var animeSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private var user = User()
    
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
    
    @IBAction func logoutButtonPessed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "ログアウトしますか？", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "ログアウトする", style: UIAlertAction.Style.default) { [self] (alert) in
            AuthService.logoutUser { (error) in
                if let error = error {
                    print("Error logout user: \(error.localizedDescription)")
                }
                HUD.flash(.labeledSuccess(title: "", subtitle: "ログアウトしました"), delay: 2)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC")
                    self.present(startVC, animated: true, completion: nil)
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let screenSize = UIScreen.main.bounds
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    private func setup() {
        
        if UserDefaults.standard.object(forKey: ON_ANIME) != nil {
            animeSwitch.isOn = true
        } else {
            animeSwitch.isOn = false
        }
        navigationItem.title = "設定"
        loginButton.isEnabled = false
    }
    
    func showSKStoreViewController() {
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = self
        
        present( productViewController, animated: true, completion: {() -> Void in
            
            let productID = "1540427984"
            let parameters:Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProduct( withParameters: parameters, completionBlock: {(Bool, NSError) -> Void in
                print(Bool)
            })
        })
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "CloudBackupVC", sender: nil)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            performSegue(withIdentifier: "CloudRestoreVC", sender: nil)
        } else if indexPath.section == 2 && indexPath.row == 4 {
            showSKStoreViewController()
        } else if indexPath.section == 2 && indexPath.row == 5 {
            let activityItems = ["自動で入力!簡単ラクラク家計簿アプリ　無料で使えるマネーマネージ", URL(string: "https://apps.apple.com/us/app/%E3%83%9E%E3%83%8D%E3%83%BC%E3%83%9E%E3%83%8D%E3%83%BC%E3%82%B8-%E8%87%AA%E5%8B%95%E3%81%A7%E3%83%A9%E3%82%AF%E3%83%A9%E3%82%AF%E5%AE%B6%E8%A8%88%E7%B0%BF%E3%82%A2%E3%83%97%E3%83%AA/id1540427984#?platform=iphone") as Any] as [Any]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
    }
}

extension SettingTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
