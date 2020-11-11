//
//  SortListTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit

class SortListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var dateDescButton: UIButton!
    @IBOutlet weak var dateAsceButton: UIButton!
    @IBOutlet weak var priceDecsButton: UIButton!
    @IBOutlet weak var priceAsceButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    private let userDefaults = UserDefaults.standard

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSort()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func selectedSort() {
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!]
        navigationItem.title = "並べ替え"
        dateDescButton.isHidden = true
        dateAsceButton.isHidden = true
        priceDecsButton.isHidden = true
        priceAsceButton.isHidden = true
        categoryButton.isHidden = true
        
        if userDefaults.object(forKey: DATE_ASCE) != nil {
            dateDescButton.isHidden = true
            dateAsceButton.isHidden = false
            priceDecsButton.isHidden = true
            priceAsceButton.isHidden = true
            categoryButton.isHidden = true
        } else if userDefaults.object(forKey: PRICE_DESC) != nil {
            dateDescButton.isHidden = true
            dateAsceButton.isHidden = true
            priceDecsButton.isHidden = false
            priceAsceButton.isHidden = true
            categoryButton.isHidden = true
        } else if userDefaults.object(forKey: PRICE_ASCE) != nil {
            dateDescButton.isHidden = true
            dateAsceButton.isHidden = true
            priceDecsButton.isHidden = true
            priceAsceButton.isHidden = false
            categoryButton.isHidden = true
        } else if userDefaults.object(forKey: CATEGORY_DESC) != nil {
            dateDescButton.isHidden = true
            dateAsceButton.isHidden = true
            priceDecsButton.isHidden = true
            priceAsceButton.isHidden = true
            categoryButton.isHidden = false
        } else {
            dateDescButton.isHidden = false
            dateAsceButton.isHidden = true
            priceDecsButton.isHidden = true
            priceAsceButton.isHidden = true
            categoryButton.isHidden = true
        }
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            userDefaults.removeObject(forKey: DATE_ASCE)
            userDefaults.removeObject(forKey: PRICE_DESC)
            userDefaults.removeObject(forKey: PRICE_ASCE)
            userDefaults.removeObject(forKey: CATEGORY_DESC)
            selectedSort()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
            
        } else if indexPath.row == 1 {
            userDefaults.set(true, forKey: DATE_ASCE)
            userDefaults.removeObject(forKey: PRICE_DESC)
            userDefaults.removeObject(forKey: PRICE_ASCE)
            userDefaults.removeObject(forKey: CATEGORY_DESC)
            selectedSort()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }

        } else if indexPath.row == 2 {
            userDefaults.removeObject(forKey: PRICE_ASCE)
            userDefaults.set(true, forKey: PRICE_DESC)
            userDefaults.removeObject(forKey: DATE_ASCE)
            userDefaults.removeObject(forKey: CATEGORY_DESC)
            selectedSort()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }

        } else if indexPath.row == 3 {
            userDefaults.removeObject(forKey: DATE_ASCE)
            userDefaults.removeObject(forKey: PRICE_DESC)
            userDefaults.set(true, forKey: PRICE_ASCE)
            userDefaults.removeObject(forKey: CATEGORY_DESC)
            selectedSort()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }

        } else {
            userDefaults.removeObject(forKey: DATE_ASCE)
            userDefaults.removeObject(forKey: PRICE_DESC)
            userDefaults.removeObject(forKey: PRICE_ASCE)
            userDefaults.set(true, forKey: CATEGORY_DESC)
            selectedSort()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
