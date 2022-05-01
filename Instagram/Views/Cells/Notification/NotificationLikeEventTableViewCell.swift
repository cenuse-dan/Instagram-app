//
//  NotificationFollowEventTableViewCell.swift
//  Instagram
//
//  Created by user216341 on 4/30/22.
//

import UIKit
import SDWebImage

protocol NotificationLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton (model: UserNotifications)
}

class NotificationLikeEventTableViewCell: UITableViewCell {

  static let identifier = "NotificationLikeEventTableViewCell"
    
    weak var delegate: NotificationLikeEventTableViewCellDelegate?
    private var model: UserNotifications?
    private let profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "@joe liked your photo"
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
        postButton.addTarget(self,
                             action: #selector(didTapPostButton),
                             for: .touchUpInside)
    
        selectionStyle = .none

    }
    @objc private func didTapPostButton(){
        guard let model = model else {
            return
        }
        delegate?.didTapRelatedPostButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserNotifications) {
        self.model = model
        switch model.type {
        case .like(let post):
            let thumbnail = post.thumbnailImage
//            guard !thumbnail.absoluteString.contains("google") else{
//          
//                return
//            }
            postButton.sd_setBackgroundImage(with: thumbnail,
                                             for: .normal,
                                             completed:  nil)
            break
        case .follow:
            break
        }
        label.text = model.text
        
        
       // profileImageView.sd_setImage(with: model.user.profilePhoto,completed: nil)
        profileImageView.loadFrom(URLAddress:"https://www.kindpng.com/picc/m/146-1467015_basic-url-web-address-web-urls-icon-png.png")
        
    }
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        postButton.setBackgroundImage(nil, for: .normal)
//        label.text = nil
//        profileImageView.image = nil
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height-6, height: contentView.height-6)
        
        
        
        profileImageView.layer.cornerRadius = profileImageView.height/2
        let size = contentView.height-4
        postButton.frame = CGRect(x: contentView.width-5-size,
                                  y: 2,
                                  width: size,
                                  height: size)
        label.frame = CGRect (x: profileImageView.right+5,
                              y: 0,
                              width: contentView.width-size-profileImageView.width-16,
                              height: contentView.height)
       
        
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
