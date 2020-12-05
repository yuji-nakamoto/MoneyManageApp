//
//  ResetTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/09.
//

import UIKit
import PKHUD
import RealmSwift

class ResetTableViewController: UITableViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.layer.cornerRadius = 10
        if resetSwitch.isOn {
            resetButton.isEnabled = true
        } else {
            resetButton.isEnabled = false
        }
        navigationItem.title = "データリセット"
    }
    
    @IBAction func backButtonPressd(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onResetSwitch(_ sender: UISwitch) {
        if sender.isOn {
            resetButton.isEnabled = true
        } else {
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        let realm = try! Realm()
        let moneyArray = realm.objects(Money.self)
        let spendingArray = realm.objects(Spending.self)
        let incomeArray = realm.objects(Income.self)
        let autoArray = realm.objects(Auto.self)
        let monthlyArray = realm.objects(Monthly.self)
        let mFoodArray = realm.objects(MonthlyFood.self)
        let mBrushArray = realm.objects(MonthlyBrush.self)
        let mHobbyArray = realm.objects(MonthlyHobby.self)
        let mDatingArray = realm.objects(MonthlyDating.self)
        let mTrafficArray = realm.objects(MonthlyTraffic.self)
        let mClotheArray = realm.objects(MonthlyClothe.self)
        let mHealthArray = realm.objects(MonthlyHealth.self)
        let mCarArray = realm.objects(MonthlyCar.self)
        let mEducationArray = realm.objects(MonthlyEducation.self)
        let mSpecialArray = realm.objects(MonthlySpecial.self)
        let mCardArray = realm.objects(MonthlyCard.self)
        let mUtilityArray = realm.objects(MonthlyUtility.self)
        let mCommunicatonArray = realm.objects(MonthlyCommunication.self)
        let mHouseArray = realm.objects(MonthlyHouse.self)
        let mTaxArray = realm.objects(MonthlyTax.self)
        let mInsranceArray = realm.objects(MonthlyInsrance.self)
        let mEtcetoraArray = realm.objects(MonthlyEtcetora.self)
        let mUnCategoryArray = realm.objects(MonthlyUnCategory.self)
        let mSalaryArray = realm.objects(MonthlySalary.self)
        let mTemporaryArray = realm.objects(MonthlyTemporary.self)
        let mBusinessArray = realm.objects(MonthlyBusiness.self)
        let mPensionArray = realm.objects(MonthlyPension.self)
        let mDevidentArray = realm.objects(MonthlyDevident.self)
        let mEstateArray = realm.objects(MonthlyEstate.self)
        let mPaymentArray = realm.objects(MonthlyPayment.self)
        let mUnCategory2Array = realm.objects(MonthlyUnCategory2.self)
        let foodArray = realm.objects(Food.self)
        let hobbyArray = realm.objects(Hobby.self)
        let brushArray = realm.objects(Brush.self)
        let datingArray = realm.objects(Dating.self)
        let trafficArray = realm.objects(Traffic.self)
        let clotheArray = realm.objects(Clothe.self)
        let healtheArray = realm.objects(Health.self)
        let carArray = realm.objects(Car.self)
        let educationArray = realm.objects(Education.self)
        let specialArray = realm.objects(Special.self)
        let cardArray = realm.objects(Card.self)
        let utilityArray = realm.objects(Utility.self)
        let communicationArray = realm.objects(Communicaton.self)
        let houseArray = realm.objects(House.self)
        let taxArray = realm.objects(Tax.self)
        let insranceArray = realm.objects(Insrance.self)
        let etcetoraArray = realm.objects(Etcetora.self)
        let unCategoryArray = realm.objects(UnCategory.self)
        let salaryArray = realm.objects(Salary.self)
        let temporaryArray = realm.objects(Temporary.self)
        let businessArray = realm.objects(Business.self)
        let pensionArray = realm.objects(Pension.self)
        let devidentArray = realm.objects(Devident.self)
        let estateArray = realm.objects(Estate.self)
        let paymentArray = realm.objects(Payment.self)
        let unCategory2Array = realm.objects(UnCategory2.self)
        let alert = UIAlertController(title: "", message: "データをリセットしますか？", preferredStyle: .actionSheet)
        let reset = UIAlertAction(title: "データをリセットする", style: UIAlertAction.Style.default) { [self] (alert) in
            
            try! realm.write {
                realm.delete(moneyArray)
                realm.delete(spendingArray)
                realm.delete(incomeArray)
                realm.delete(autoArray)
                realm.delete(monthlyArray)
                realm.delete(mFoodArray)
                realm.delete(mBrushArray)
                realm.delete(mHobbyArray)
                realm.delete(mDatingArray)
                realm.delete(mTrafficArray)
                realm.delete(mClotheArray)
                realm.delete(mHealthArray)
                realm.delete(mCarArray)
                realm.delete(mEducationArray)
                realm.delete(mSpecialArray)
                realm.delete(mCardArray)
                realm.delete(mUtilityArray)
                realm.delete(mCommunicatonArray)
                realm.delete(mHouseArray)
                realm.delete(mTaxArray)
                realm.delete(mInsranceArray)
                realm.delete(mEtcetoraArray)
                realm.delete(mUnCategoryArray)
                realm.delete(mSalaryArray)
                realm.delete(mTemporaryArray)
                realm.delete(mBusinessArray)
                realm.delete(mPensionArray)
                realm.delete(mDevidentArray)
                realm.delete(mEstateArray)
                realm.delete(mPaymentArray)
                realm.delete(mUnCategory2Array)
                realm.delete(foodArray)
                realm.delete(brushArray)
                realm.delete(hobbyArray)
                realm.delete(datingArray)
                realm.delete(trafficArray)
                realm.delete(clotheArray)
                realm.delete(healtheArray)
                realm.delete(carArray)
                realm.delete(educationArray)
                realm.delete(specialArray)
                realm.delete(cardArray)
                realm.delete(utilityArray)
                realm.delete(communicationArray)
                realm.delete(houseArray)
                realm.delete(taxArray)
                realm.delete(insranceArray)
                realm.delete(etcetoraArray)
                realm.delete(unCategoryArray)
                realm.delete(salaryArray)
                realm.delete(temporaryArray)
                realm.delete(businessArray)
                realm.delete(pensionArray)
                realm.delete(devidentArray)
                realm.delete(estateArray)
                realm.delete(paymentArray)
                realm.delete(unCategory2Array)
                HUD.flash(.labeledSuccess(title: "", subtitle: "データをリセットしました"), delay: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let screenSize = UIScreen.main.bounds
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        alert.addAction(reset)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
}
