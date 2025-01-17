//
//  ParchmentInputViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/06.
//

import UIKit
import Parchment

class ParchmentInputViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let spendingVC = storyboard.instantiateViewController(withIdentifier: "SpendingVC")
        let incomeVC = storyboard.instantiateViewController(withIdentifier: "IncomeVC")
        
        spendingVC.title = "支出"
        incomeVC.title = "収入"
        
        let pagingVC = PagingViewController(viewControllers: [spendingVC, incomeVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 17)
        ])
        
        pagingVC.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        pagingVC.selectedFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        pagingVC.selectedTextColor = UIColor(named: O_BLACK)!
        pagingVC.textColor = .systemGray
        pagingVC.indicatorColor = UIColor(named: CARROT_ORANGE)!
        pagingVC.menuItemSize = .fixed(width: 150, height: 40)
        pagingVC.menuHorizontalAlignment = .center
        pagingVC.menuBackgroundColor = UIColor(named: O_WHITE)!
        pagingVC.borderColor = .systemGray5
        
        print(UIScreen.main.nativeBounds.height)
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            NSLayoutConstraint.activate([
                pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 15)
            ])
        case 2208:
            NSLayoutConstraint.activate([
                pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 25)
            ])
        default:
            break
        }
    }
}
