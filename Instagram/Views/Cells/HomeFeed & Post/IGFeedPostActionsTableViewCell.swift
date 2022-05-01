//
//  IGFeedPostActionsTableViewCell.swift
//  Instagram
//
//  Created by user216341 on 4/28/22.
//

import UIKit
protocol IGFeedPostActionsTableViewCellDelegate: AnyObject {
    func didTapLikeButton()
    func didTapCommentButton()
    func didTapSendButton()
}
class IGFeedPostActionsTableViewCell: UITableViewCell {
    
    static let identifier = "IGFeedPostActionsTableViewCell"
    
    weak var delegate: IGFeedPostActionsTableViewCellDelegate?
    
    private let likedButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration:  config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
        let image = UIImage(systemName: "message", withConfiguration:  config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
        let image = UIImage(systemName: "paperplane", withConfiguration:  config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    @objc private func didTapLikeButton(){
        delegate?.didTapLikeButton()
            var image : UIImage?
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
            image = UIImage(systemName: "heart.fill", withConfiguration:  config)
            likedButton.setImage(image, for: .normal)
            image?.accessibilityIdentifier = "heart.fill"
        
        
//        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
//        let image = UIImage(systemName: "heart", withConfiguration:  config)
//        likedButton.setImage(image, for: .normal)
//        likedButton.imageView?.accessibilityIdentifier = "heart"
    
        
        
    }
    @objc private func didTapCommentButton(){
        delegate?.didTapCommentButton()
    }
    @objc private func didTapSendButton(){
        delegate?.didTapSendButton()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.addSubview(likedButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sendButton)
        likedButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post:UserPost){
        // configure the cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonSize = contentView.height-10
        let buttons = [likedButton, commentButton, sendButton]
        for x in 0..<buttons.count {
            let button = buttons[x]
            button.frame = CGRect(x: (CGFloat(x)*buttonSize) + (10*CGFloat(x+1)), y: 5, width: buttonSize, height: buttonSize)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}

extension HomeViewController: IGFeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        print("Like")
      
    }
    func didTapCommentButton() {
        print("Comment")
    }
    func didTapSendButton() {
        print("Send")
    }
}
