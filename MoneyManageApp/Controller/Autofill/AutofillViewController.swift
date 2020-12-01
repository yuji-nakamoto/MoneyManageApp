//
//  AutofillViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/10.
//

import UIKit
import RealmSwift
import AVFoundation
import EmptyDataSet_Swift
import GoogleMobileAds

class AutofillViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var createButtonView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackTopConst: NSLayoutConstraint!
    @IBOutlet weak var contentsBottomConst: NSLayoutConstraint!
    @IBOutlet weak var contentsTopConst: NSLayoutConstraint!
    
    private var videoPlayer: AVPlayer!
    private var autoArray = [Auto]()
    private var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAuto()
        if UserDefaults.standard.object(forKey: END_TUTORIAL4) == nil {
            showHintView()
        }
    }
    
    @objc func tapCreateButtonView() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let navAutoVC = storyboard.instantiateViewController(withIdentifier: "NavAutoVC")
        navAutoVC.presentationController?.delegate = self
        self.present(navAutoVC, animated: true, completion: nil)
    }
    
    @IBAction func onSider(_ sender: UISlider) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(seekBar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    @IBAction func competionButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backView.alpha = 0
        }) { (_) in
            UserDefaults.standard.set(true, forKey: END_TUTORIAL4)
        }
    }
    
    private func fetchAuto() {
        
        let realm = try! Realm()
        
        autoArray.removeAll()
        let auto = realm.objects(Auto.self)
        autoArray.append(contentsOf: auto)
        autoArray = autoArray.sorted(by: { (a, b) -> Bool in
            return a.date < b.date
        })
        tableView.reloadData()
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/5979521196"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func showHintView() {
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            stackTopConst.constant = 10
            contentsBottomConst.constant = -30
            contentsTopConst.constant = 10
            heightConstraint.constant = 370
        case 1792:
            heightConstraint.constant = 470
        case 2048:
            heightConstraint.constant = 650
        case 2160:
            heightConstraint.constant = 700
        case 2208:
            heightConstraint.constant = 380
        case 2360:
            heightConstraint.constant = 700
        case 2388:
            heightConstraint.constant = 700
        case 2436:
            heightConstraint.constant = 390
        case 2532:
            heightConstraint.constant = 420
        case 2688:
            heightConstraint.constant = 470
        case 2732:
            heightConstraint.constant = 700
        case 2778:
            heightConstraint.constant = 500
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            setVideoPlayer()
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                backView.alpha = 1
            }, completion: nil)
        }
    }
    
    private func setup() {
        navigationItem.title = "自動入力"
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCreateButtonView))
        createButtonView.addGestureRecognizer(tap)
        createButtonView.layer.cornerRadius = 44 / 2
        startButton.layer.cornerRadius = 35 / 2
        completionButton.layer.cornerRadius = 35 / 2
        backView.alpha = 0
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    private func setVideoPlayer() {
        
        guard let path = Bundle.main.path(forResource: "tutorial3", ofType: "mp4") else {
            fatalError("Movie file can not find.")
        }
        let fileURL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: fileURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer
        layer.frame = contentView.bounds
        contentView.layer.addSublayer(layer)
        
        seekBar.minimumValue = 0
        seekBar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        
        let interval : Double = Double(0.5 * seekBar.maximumValue) / Double(seekBar.bounds.maxX)
        
        let time : CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
        
        videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
            
            let duration = CMTimeGetSeconds(self.videoPlayer.currentItem!.duration)
            let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
            let value = Float(self.seekBar.maximumValue - self.seekBar.minimumValue) * Float(time) / Float(duration) + Float(self.seekBar.minimumValue)
            self.seekBar.value = value
        })
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
}

extension AutofillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AutofillListTableViewCell
        
        cell.configureAutoCell(autoArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        id = autoArray[indexPath.row].id
        UserDefaults.standard.set(id, forKey: EDIT_AUTO_ID)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let editAutoVC = storyboard.instantiateViewController(withIdentifier: "EditAutoVC")
        editAutoVC.presentationController?.delegate = self
        self.present(editAutoVC, animated: true, completion: nil)
    }
}

extension AutofillViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    fetchAuto()
  }
}

extension AutofillViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "自動入力はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2 as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "下部にあるボタンから自動入力を作成できます", attributes: attributes)
    }
}
