//
//  Tutorial4VCViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/14.
//

import UIKit
import AVFoundation

class Tutorial4ViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    var videoPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 35 / 2
        setVideoPlayer()
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            heightConstraint.constant = 350
            break
        default:
            break
        }
    }
    
    private func setVideoPlayer() {
        
        guard let path = Bundle.main.path(forResource: "tutorial4", ofType: "mp4") else {
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
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
