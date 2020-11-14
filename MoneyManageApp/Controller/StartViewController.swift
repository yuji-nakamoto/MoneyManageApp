//
//  StartViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/13.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toTabVC()
    }
    
    private func toTabVC() {
        indicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            
            if UserDefaults.standard.object(forKey: END_TUTORIAL) != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
                self.present(tabVC, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tutorial1VC = storyboard.instantiateViewController(withIdentifier: "Tutorial1VC")
                self.present(tutorial1VC, animated: true, completion: nil)
            }
        }
    }
}