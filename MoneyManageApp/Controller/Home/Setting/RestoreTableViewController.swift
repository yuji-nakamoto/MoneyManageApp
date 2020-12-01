//
//  RestoreTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/19.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import PKHUD

class RestoreTableViewController: UITableViewController, GADInterstitialDelegate {
    
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var restoreLabel1: UILabel!
    @IBOutlet weak var restoreLabel2: UILabel!
    @IBOutlet weak var restoreLabel3: UILabel!
    @IBOutlet weak var checkMark1: UIButton!
    @IBOutlet weak var checkMark2: UIButton!
    @IBOutlet weak var checkMark3: UIButton!
    
    private var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setSwipeBack()
        setupCheckMark()
        interstitial = createAndLoadIntersitial()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "データを復元しますか？", preferredStyle: .alert)
        let restore = UIAlertAction(title: "復元する", style: UIAlertAction.Style.default) { [self] (alert) in
            doRestore()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
       
        alert.addAction(restore)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    private func doRestore() {
        do {
            var url = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            if UserDefaults.standard.object(forKey: CHECK1) != nil && UserDefaults.standard.object(forKey: BACKUP1) != nil {
                let fileName = UserDefaults.standard.object(forKey: BACKUP1) as! String
                url.appendPathComponent(fileName)

            } else if UserDefaults.standard.object(forKey: CHECK2) != nil && UserDefaults.standard.object(forKey: BACKUP2) != nil {
                let fileName = UserDefaults.standard.object(forKey: BACKUP2) as! String
                url.appendPathComponent(fileName)
                
            } else if UserDefaults.standard.object(forKey: CHECK3) != nil && UserDefaults.standard.object(forKey: BACKUP3) != nil {
                let fileName = UserDefaults.standard.object(forKey: BACKUP3) as! String
                url.appendPathComponent(fileName)
            }
            try realmRestore(backupFileURL: url)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func realmRestore(backupFileURL: URL) throws {
        guard let realmFileUrl = Realm.Configuration.defaultConfiguration.fileURL else {
            throw NSError.init(domain: "Realmのファイルパスが取得できませんでした。", code: -1, userInfo: nil)
        }
        try FileManager.default.removeItem(at: realmFileUrl)
        try FileManager.default.copyItem(at: backupFileURL, to: realmFileUrl)
        HUD.flash(.labeledSuccess(title: "", subtitle: "復元しました"), delay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Error interstitial")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func setup() {
        
        navigationItem.title = "バックアップの復元"
        UserDefaults.standard.removeObject(forKey: CHECK1)
        UserDefaults.standard.removeObject(forKey: CHECK2)
        UserDefaults.standard.removeObject(forKey: CHECK3)
        checkMark1.isHidden = true
        checkMark2.isHidden = true
        checkMark3.isHidden = true
        restoreButton.isEnabled = false
        restoreButton.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
        
        if UserDefaults.standard.object(forKey: BACKUP1) != nil {
            let fileName = UserDefaults.standard.object(forKey: BACKUP1) as! String
            restoreLabel1.text = fileName
        } else {
            restoreLabel1.text = "バックアップはありません"
        }
        
        if UserDefaults.standard.object(forKey: BACKUP2) != nil {
            let fileName = UserDefaults.standard.object(forKey: BACKUP2) as! String
            restoreLabel2.text = fileName
        } else {
            restoreLabel2.text = "バックアップはありません"
        }
        
        if UserDefaults.standard.object(forKey: BACKUP3) != nil {
            let fileName = UserDefaults.standard.object(forKey: BACKUP3) as! String
            restoreLabel3.text = fileName
        } else {
            restoreLabel3.text = "バックアップはありません"
        }
    }
    
    private func setupCheckMark() {
        
        if UserDefaults.standard.object(forKey: CHECK1) != nil  && UserDefaults.standard.object(forKey: BACKUP1) != nil {
            checkMark1.isHidden = false
            checkMark2.isHidden = true
            checkMark3.isHidden = true
            restoreButton.isEnabled = true
        } else if UserDefaults.standard.object(forKey: CHECK2) != nil && UserDefaults.standard.object(forKey: BACKUP2) != nil {
            checkMark1.isHidden = true
            checkMark2.isHidden = false
            checkMark3.isHidden = true
            restoreButton.isEnabled = true
        } else if UserDefaults.standard.object(forKey: CHECK3) != nil && UserDefaults.standard.object(forKey: BACKUP3) != nil {
            checkMark1.isHidden = true
            checkMark2.isHidden = true
            checkMark3.isHidden = false
            restoreButton.isEnabled = true
        }
    }
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4750883229624981/7295600156")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: CHECK1)
            UserDefaults.standard.removeObject(forKey: CHECK2)
            UserDefaults.standard.removeObject(forKey: CHECK3)
            setupCheckMark()
            
        } else if indexPath.row == 1 {
            UserDefaults.standard.set(true, forKey: CHECK2)
            UserDefaults.standard.removeObject(forKey: CHECK1)
            UserDefaults.standard.removeObject(forKey: CHECK3)
            setupCheckMark()
            
        } else if indexPath.row == 2 {
            UserDefaults.standard.set(true, forKey: CHECK3)
            UserDefaults.standard.removeObject(forKey: CHECK1)
            UserDefaults.standard.removeObject(forKey: CHECK2)
            setupCheckMark()
        }
    }
}
