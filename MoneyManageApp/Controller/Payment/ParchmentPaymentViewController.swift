//
//  ParchmentPaymentViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import Parchment

class ParchmentPaymentViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentVC")
        let withdrawalVC = storyboard.instantiateViewController(withIdentifier: "WithdrawalVC")
        
        paymentVC.title = "入金"
        withdrawalVC.title = "出金"
        
        let pagingVC = PagingViewController(viewControllers: [withdrawalVC, paymentVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 55)
        ])
   
        pagingVC.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        pagingVC.selectedFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        pagingVC.selectedTextColor = UIColor(named: O_BLACK)!
        pagingVC.textColor = .systemGray
        pagingVC.indicatorColor = UIColor(named: CARROT_ORANGE)!
        pagingVC.menuItemSize = .fixed(width: 150, height: 40)
        pagingVC.menuHorizontalAlignment = .center
        pagingVC.menuBackgroundColor = UIColor(named: O_WHITE)!
        pagingVC.borderColor = .clear
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            NSLayoutConstraint.activate([
                pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 25)
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
