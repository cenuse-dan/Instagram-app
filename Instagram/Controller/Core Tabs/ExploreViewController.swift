//
//  ExploreViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//

import UIKit

import AVFoundation
class ExploreViewController: UIViewController {

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        playVideo()
        

        
        // Do any additional setup after loading the view.
    }
    func playVideo(){
        let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "videoplayback", ofType: "mp4")!)
        print(AVAsset(url: videoURL).isPlayable)
        let player = AVPlayer (url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x:0, y: 100, width: view.width, height: view.width)
        playerLayer.backgroundColor = UIColor.label.cgColor
       // playerLayer.videoGravity = .resizeAspect
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
  

    
    }
    




