//
//  InputBaseViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/12/01.
//

import UIKit

class InputBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "入力"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let parchemtVC = storyboard.instantiateViewController(withIdentifier: "MyNavVC")
        parchemtVC.presentationController?.delegate = self
        self.present(parchemtVC, animated: true, completion: nil)
    }
}

extension InputBaseViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
    self.present(tabVC, animated: false, completion: nil)
  }
}
