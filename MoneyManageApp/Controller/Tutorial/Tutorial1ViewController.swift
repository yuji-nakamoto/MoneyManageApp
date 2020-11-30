//
//  Tutorial1ViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import UIKit
import AVFoundation

class Tutorial1ViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var videoPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            alert()
        }
        startButton.isEnabled = false
        registerButton.isEnabled = false
        startButton.layer.cornerRadius = 35 / 2
        registerButton.layer.cornerRadius = 35 / 2
        setupVideoViewHeight()
    }
    
    private func setupVideoViewHeight() {
        
        print(UIScreen.main.nativeBounds.height)
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            heightConstraint.constant = 400
        case 2208:
            heightConstraint.constant = 450
        case 1792:
            heightConstraint.constant = 530
        case 2436:
            heightConstraint.constant = 480
        case 2532:
            heightConstraint.constant = 500
        case 2688:
            heightConstraint.constant = 550
        case 2778:
            heightConstraint.constant = 580
        default:
            break
        }
        if UIScreen.main.nativeBounds.height >= 2160 {
            heightConstraint.constant = 800
        }
    }
    
    private func alert() {
        
        let alert = UIAlertController(title: "アプリのダウンロード\nありがとうございます😊", message: "", preferredStyle: .alert)
        let next = UIAlertAction(title: "進む", style: UIAlertAction.Style.default) { [self] (alert) in
            setVideoPlayer()
            startButton.isEnabled = true
            registerButton.isEnabled = true
        }
        alert.addAction(next)
        self.present(alert, animated: true,completion: nil)
    }
    
    private func setVideoPlayer() {
        
        guard let path = Bundle.main.path(forResource: "tutorial1", ofType: "mp4") else {
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
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let inputVC = storyboard.instantiateViewController(withIdentifier: "InputVC")
        self.present(inputVC, animated: true, completion: nil)
    }
}
