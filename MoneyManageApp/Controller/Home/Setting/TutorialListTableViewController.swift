//
//  TutorialListTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import UIKit

class TutorialListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "マネージの使い方"
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func bacButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial2VC = storyboard.instantiateViewController(withIdentifier: "Tutorial2VC")
            turorial2VC.modalPresentationStyle = .automatic
            self.present(turorial2VC, animated: true, completion: nil)
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial3VC = storyboard.instantiateViewController(withIdentifier: "Tutorial3VC")
            turorial3VC.modalPresentationStyle = .automatic
            self.present(turorial3VC, animated: true, completion: nil)
            
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial6VC = storyboard.instantiateViewController(withIdentifier: "Tutorial6VC")
            turorial6VC.modalPresentationStyle = .automatic
            self.present(turorial6VC, animated: true, completion: nil)
            
        } else if indexPath.section == 0 && indexPath.row == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial4VC = storyboard.instantiateViewController(withIdentifier: "Tutorial4VC")
            turorial4VC.modalPresentationStyle = .automatic
            self.present(turorial4VC, animated: true, completion: nil)
            
        } else if indexPath.section == 0 && indexPath.row == 4 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial5VC = storyboard.instantiateViewController(withIdentifier: "Tutorial5VC")
            turorial5VC.modalPresentationStyle = .automatic
            self.present(turorial5VC, animated: true, completion: nil)
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let backupTutorialVC = storyboard.instantiateViewController(withIdentifier: "BackupTutorialVC")
            backupTutorialVC.modalPresentationStyle = .automatic
            self.present(backupTutorialVC, animated: true, completion: nil)
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let restoreTutorialVC = storyboard.instantiateViewController(withIdentifier: "RestoreTutorialVC")
            restoreTutorialVC.modalPresentationStyle = .automatic
            self.present(restoreTutorialVC, animated: true, completion: nil)
            
        } else if indexPath.section == 1 && indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resetTutorialVC = storyboard.instantiateViewController(withIdentifier: "ResetTutorialVC")
            resetTutorialVC.modalPresentationStyle = .automatic
            self.present(resetTutorialVC, animated: true, completion: nil)
        }
    }
}
