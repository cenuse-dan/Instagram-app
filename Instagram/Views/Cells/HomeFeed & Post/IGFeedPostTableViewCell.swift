//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by user216341 on 4/28/22.
//

import UIKit
import SDWebImage
import AVFoundation

/// Cell for primary content
final class IGFeedPostTableViewCell: UITableViewCell {
    
    static let identifier = "IGFeedPostTableViewCell"
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost){
        // configure the cell
        
      //  postImageView.image = UIImage(named: "test")
        //return
        switch post.postType {
        case .photo:
            postImageView.sd_setImage(with: post.postURL, completed: nil)
            
        case .video:
            
            //player = AVPlayer (url: post.postURL)
            print("video")
            player = AVPlayer (url: URL(string: "https://youtu.be/UQvFnNSZ9HM")!)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.bounds
        postImageView.frame = contentView.bounds
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
}
