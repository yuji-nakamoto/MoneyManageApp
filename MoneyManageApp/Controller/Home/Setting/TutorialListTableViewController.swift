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
        navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial1VC = storyboard.instantiateViewController(withIdentifier: "Tutorial1VC")
            self.present(turorial1VC, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial2VC = storyboard.instantiateViewController(withIdentifier: "Tutorial2VC")
            self.present(turorial2VC, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial3VC = storyboard.instantiateViewController(withIdentifier: "Tutorial3VC")
            self.present(turorial3VC, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial6VC = storyboard.instantiateViewController(withIdentifier: "Tutorial6VC")
            self.present(turorial6VC, animated: true, completion: nil)
        } else if indexPath.row == 4 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial4VC = storyboard.instantiateViewController(withIdentifier: "Tutorial4VC")
            self.present(turorial4VC, animated: true, completion: nil)
        } else if indexPath.row == 5 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let turorial5VC = storyboard.instantiateViewController(withIdentifier: "Tutorial5VC")
            self.present(turorial5VC, animated: true, completion: nil)
        }
    }
}
