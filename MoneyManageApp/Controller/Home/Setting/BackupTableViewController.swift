//
//  BackupTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/19.
//

import UIKit
import GoogleMobileAds
import RealmSwift
import PKHUD

class BackupTableViewController: UITableViewController, GADInterstitialDelegate {
    
    @IBOutlet weak var backupButton: UIButton!
    @IBOutlet weak var backupLabel1: UILabel!
    @IBOutlet weak var backupLabel2: UILabel!
    @IBOutlet weak var backupLabel3: UILabel!
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backupButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "データをバックアップしますか？", preferredStyle: .alert)
        let alert2 = UIAlertController(title: "バックアップが存在します", message: "上書きしますか？", preferredStyle: .alert)
        let backup = UIAlertAction(title: "バックアップする", style: UIAlertAction.Style.default) { [self] (alert) in
            
            doBackup()
            HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let backup2 = UIAlertAction(title: "上書きする", style: UIAlertAction.Style.default) { [self] (alert) in
            
            doBackup()
            HUD.flash(.labeledSuccess(title: "", subtitle: "バックアップしました"), delay: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        if backupLabel1.text != "バックアップはありません" && UserDefaults.standard.object(forKey: CHECK1) != nil {
            alert2.addAction(backup2)
            alert2.addAction(cancel)
            self.present(alert2,animated: true,completion: nil)
        } else if backupLabel2.text != "バックアップはありません" && UserDefaults.standard.object(forKey: CHECK2) != nil {
            alert2.addAction(backup2)
            alert2.addAction(cancel)
            self.present(alert2,animated: true,completion: nil)
        } else if backupLabel3.text != "バックアップはありません" && UserDefaults.standard.object(forKey: CHECK3) != nil {
            alert2.addAction(backup2)
            alert2.addAction(cancel)
            self.present(alert2,animated: true,completion: nil)
        } else {
            alert.addAction(backup)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    private func doBackup() {
        do {
            let url = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dateformater = DateFormatter()
            dateformater.dateFormat = "yyyy-MM-dd-hh-mm-ss"
            dateformater.locale = Locale(identifier: "ja_JP")
            let fileName = "バックアップ " + dateformater.string(from: Date())
            
            if UserDefaults.standard.object(forKey: CHECK1) != nil {
                UserDefaults.standard.set(fileName, forKey: BACKUP1)
            } else if UserDefaults.standard.object(forKey: CHECK2) != nil {
                UserDefaults.standard.set(fileName, forKey: BACKUP2)
            } else if UserDefaults.standard.object(forKey: CHECK3) != nil {
                UserDefaults.standard.set(fileName, forKey: BACKUP3)
            }
            
            try backupLocalStore(storeBackupDirectoryURL: url, backupStoreFilename: fileName)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func backupLocalStore(storeBackupDirectoryURL: URL, backupStoreFilename: String) throws {
        let backupURL = storeBackupDirectoryURL.appendingPathComponent(backupStoreFilename)
        do {
            let realm = try Realm()
            realm.beginWrite()
            try realm.writeCopy(toFile: backupURL)
            realm.cancelWrite()
        } catch {
            throw error
        }
    }
    
    private func setup() {
        
        navigationItem.title = "バックアップ"
        UserDefaults.standard.removeObject(forKey: CHECK1)
        UserDefaults.standard.removeObject(forKey: CHECK2)
        UserDefaults.standard.removeObject(forKey: CHECK3)
        checkMark1.isHidden = true
        checkMark2.isHidden = true
        checkMark3.isHidden = true
        backupButton.isEnabled = false
        backupButton.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
        
        if UserDefaults.standard.object(forKey: BACKUP1) != nil {
            let fileName = UserDefaults.standard.object(forKey: BACKUP1) as! String
            backupLabel1.text = fileName
        } else {
            backupLabel1.text = "バックアップはありません"
        }
        
        if UserDefaults.standard.object(forKey: BACKUP2) != nil {
            let fileName = UserDefaults.standard.object(forKey: BACKUP2) as! String
            backupLabel2.text = fileName
        } else {
            backupLabel2.text = "バックアップはありません"
        }
        
        if UserDefaults.standard.object(forKey: BACKUP3) != nil {
            let fileName = UserDefaults.standard.object(forKey: BACKUP3) as! String
            backupLabel3.text = fileName
        } else {
            backupLabel3.text = "バックアップはありません"
        }
    }
    
    private func setupCheckMark() {
        
        if UserDefaults.standard.object(forKey: CHECK1) != nil {
            checkMark1.isHidden = false
            checkMark2.isHidden = true
            checkMark3.isHidden = true
            backupButton.isEnabled = true
        } else if UserDefaults.standard.object(forKey: CHECK2) != nil {
            checkMark1.isHidden = true
            checkMark2.isHidden = false
            checkMark3.isHidden = true
            backupButton.isEnabled = true
        } else if UserDefaults.standard.object(forKey: CHECK3) != nil {
            checkMark1.isHidden = true
            checkMark2.isHidden = true
            checkMark3.isHidden = false
            backupButton.isEnabled = true
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
