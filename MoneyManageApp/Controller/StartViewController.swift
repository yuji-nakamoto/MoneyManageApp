//
//  StartViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/13.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toTabVC()
        logoImageView.layer.cornerRadius = 10
    }
    
    private func toTabVC() {
        UserDefaults.standard.removeObject(forKey: TIME_OUT)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            
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
