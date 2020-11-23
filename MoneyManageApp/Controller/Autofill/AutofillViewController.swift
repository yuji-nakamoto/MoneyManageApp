//
//  AutofillViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/10.
//

import UIKit
import RealmSwift
import AVFoundation
import GoogleMobileAds

class AutofillViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
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
        startButton.layer.cornerRadius = 35 / 2
        completionButton.layer.cornerRadius = 35 / 2
        backView.alpha = 0
        navigationItem.title = "自動入力"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAuto()
        
        if UserDefaults.standard.object(forKey: END_TUTORIAL4) == nil {
            showHintView()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditAutoItemVC" {
            let editAutoItemVC = segue.destination as! EditAutoItemViewController
            editAutoItemVC.id = id
        }
    }
    
    private func showHintView() {
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            stackTopConst.constant = 10
            contentsBottomConst.constant = -30
            contentsTopConst.constant = 10
            heightConstraint.constant = 370
            break
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            setVideoPlayer()
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                backView.alpha = 1
            }, completion: nil)
        }
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
}

extension AutofillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + 1 + autoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! IncomeCategoryTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! AutofillListTableViewCell
        
        if indexPath.row == 0 {
            return cell1
        } else if indexPath.row == 1 {
            return cell2!
        }
        
        cell3.configureAutoCell(autoArray[indexPath.row - 2])
        return cell3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row >= 2 {
            let auto = autoArray[indexPath.row - 2]
            id = auto.id
            performSegue(withIdentifier: "EditAutoItemVC", sender: nil)
        }
    }
}
