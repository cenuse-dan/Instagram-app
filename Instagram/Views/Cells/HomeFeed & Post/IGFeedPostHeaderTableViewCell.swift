//
//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//
//  Created by user216341 on 4/28/22.
//

import UIKit
import SDWebImage

protocol IGFeedPostHeaderTableViewCellDelegate: AnyObject {
    func didTapMoreButton () // poate atribui model
}

class IGFeedPostHeaderTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostHeaderTableViewCell"
  
    weak var delegate: IGFeedPostHeaderTableViewCellDelegate?
    
    private let profielPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profielPhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self,
                             action: #selector(didTapButton),
                             for: .touchUpInside)
        

    }
    @objc private func didTapButton() {
        delegate?.didTapMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: User){
        // configure the cell
        usernameLabel.text = model.username
        //profielPhotoImageView.sd_setImage(with: model.profilePhoto,completed: nil)
        profielPhotoImageView.image = UIImage(systemName: "person.circle")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 4
        profielPhotoImageView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profielPhotoImageView.layer.cornerRadius = size/2
        moreButton.frame = CGRect(x: contentView.width-size-2, y: 2, width: size, height: size)
        
        usernameLabel.frame = CGRect (x: profielPhotoImageView.right+10, y: 2, width: contentView.width-(size*2)-15, height: contentView.height-4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        //profielPhotoImageView.sd_setImage(with: model.profilePhoto,completed: nil)
        profielPhotoImageView.image = nil
    }
}
