//
//  ParchmentAutoInputViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import Parchment

class ParchmentAutoInputViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "自動入力の作成"
        navigationController?.navigationBar.shadowImage = UIImage()
        initPagingVC()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let autoSpendingVC = storyboard.instantiateViewController(withIdentifier: "AutoSpendingVC")
        let autoIncomeVC = storyboard.instantiateViewController(withIdentifier: "AutoIncomeVC")
        
        autoSpendingVC.title = "支出"
        autoIncomeVC.title = "収入"
        
        let pagingVC = PagingViewController(viewControllers: [autoSpendingVC, autoIncomeVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        ])
   
        pagingVC.font = UIFont(name: "HiraMaruProN-W4", size: 12)!
        pagingVC.selectedFont = UIFont(name: "HiraMaruProN-W4", size: 14)!
        pagingVC.selectedTextColor = UIColor(named: O_BLACK)!
        pagingVC.textColor = .systemGray
        pagingVC.indicatorColor = UIColor(named: CARROT_ORANGE)!
        pagingVC.menuItemSize = .fixed(width: 150, height: 40)
        pagingVC.menuHorizontalAlignment = .center
        pagingVC.menuBackgroundColor = UIColor(named: O_WHITE)!
        pagingVC.borderColor = .systemGray5
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            NSLayoutConstraint.activate([
                pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 55)
            ])
            break
        default:
            break
        }
    }
}
