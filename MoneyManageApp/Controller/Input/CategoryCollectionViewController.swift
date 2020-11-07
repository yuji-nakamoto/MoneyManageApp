//
//  CategoryCollectionViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/07.
//

import UIKit
import GoogleMobileAds

class CategoryCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let categoryTitles = ["食費", "日用品", "趣味", "交際費", "交通費", "衣服・美容", "健康・医療", "自動車", "教養・教育", "特別な支出", "水道・光熱費", "通信費", "住宅", "税・社会保険", "保険", "その他", "未分類"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor(named: O_BLACK) as Any]
        navigationItem.title = "カテゴリ選択"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension CategoryCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryTitles.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryLabel.text = categoryTitles[indexPath.row]
        if indexPath.row == 0 {
            cell.categoryImageView.image = UIImage(named: "food")
        } else if indexPath.row == 1 {
            cell.categoryImageView.image = UIImage(named: "brush")
        } else if indexPath.row == 2 {
            cell.categoryImageView.image = UIImage(named: "hobby")
        } else if indexPath.row == 3 {
            cell.categoryImageView.image = UIImage(named: "dating")
        } else if indexPath.row == 4 {
            cell.categoryImageView.image = UIImage(named: "traffic")
        } else if indexPath.row == 5 {
            cell.categoryImageView.image = UIImage(named: "clothe")
        } else if indexPath.row == 6 {
            cell.categoryImageView.image = UIImage(named: "health")
        } else if indexPath.row == 7 {
            cell.categoryImageView.image = UIImage(named: "car")
        } else if indexPath.row == 8 {
            cell.categoryImageView.image = UIImage(named: "education")
        } else if indexPath.row == 9 {
            cell.categoryImageView.image = UIImage(named: "special")
        } else if indexPath.row == 10 {
            cell.categoryImageView.image = UIImage(named: "utility")
        } else if indexPath.row == 11 {
            cell.categoryImageView.image = UIImage(named: "communication")
        } else if indexPath.row == 12 {
            cell.categoryImageView.image = UIImage(named: "house")
        } else if indexPath.row == 13 {
            cell.categoryImageView.image = UIImage(named: "tax")
        } else if indexPath.row == 14 {
            cell.categoryImageView.image = UIImage(named: "insrance")
        } else if indexPath.row == 15 {
            cell.categoryImageView.image = UIImage(named: "etcetra")
        } else if indexPath.row == 16 {
            cell.categoryImageView.image = UIImage(systemName: "questionmark.circle")
            cell.categoryImageView.tintColor = .systemGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: FOOD)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 1 {
            UserDefaults.standard.set(true, forKey: NECESSITIES)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 2 {
            UserDefaults.standard.set(true, forKey: HOBBY)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 3 {
            UserDefaults.standard.set(true, forKey: DATING)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 4 {
            UserDefaults.standard.set(true, forKey: TRAFFIC)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 5 {
            UserDefaults.standard.set(true, forKey: CLOTHES)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 6 {
            UserDefaults.standard.set(true, forKey: HEALTH)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 7 {
            UserDefaults.standard.set(true, forKey: CAR)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 8 {
            UserDefaults.standard.set(true, forKey: EDUCATION)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 9 {
            UserDefaults.standard.set(true, forKey: SPECIAL)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 10 {
            UserDefaults.standard.set(true, forKey: UTILITY)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 11 {
            UserDefaults.standard.set(true, forKey: COMMUNICATION)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 12 {
            UserDefaults.standard.set(true, forKey: HOUSE)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 13 {
            UserDefaults.standard.set(true, forKey: TAX)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 14 {
            UserDefaults.standard.set(true, forKey: INSRACE)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 15 {
            UserDefaults.standard.set(true, forKey: ETCETRA)
            navigationController?.popViewController(animated: true)
        } else if indexPath.row == 16 {
            UserDefaults.standard.set(true, forKey: UN_CATEGORY)
            navigationController?.popViewController(animated: true)
        }
    }
}
