//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by user216341 on 4/29/22.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject{
    func profileHeaderDidTopPostsButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
   
}

final class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    static let shared = ProfileInfoHeaderCollectionReusableView()
    var db = SQLiteDatabase()
    var j = 0
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    public var profilePhotoImageView: UIImageView = {
  
        var imageView = UIImageView()
        imageView.image = UIImage(named: "test")
        
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Posts", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
//    private let editProfileButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Edit Your Profile", for: .normal)
//        button.setTitleColor(.label, for: .normal)
//        button.backgroundColor = .secondarySystemBackground
//        return button
//    }()
    
    public let nameLabel: UILabel = {
       // let user = SQLiteDatabase().readtest()
        var label = UILabel()
        //label.text = user.name // De aici ea el numele orice ar fi
        label.textColor = .label
        label.numberOfLines = 1
        
        return label
    }()
    public let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Primu cont"
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
        backgroundColor = .systemBackground
        clipsToBounds = true
    
  
        //SQLiteDatabase().readtest()
      
    }
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(postsButton)
       // addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
    private func addButtonActions() {
        followersButton.addTarget(self,
                                  action: #selector(didTapFollowerButton),
                                  for: .touchUpInside)
        followingButton.addTarget(self,
                                  action: #selector(didTapFollowingButton),
                                  for: .touchUpInside)
//        editProfileButton.addTarget(self,
//                                  action: #selector(didTapEditProfileButton),
//                                  for: .touchUpInside)
        postsButton.addTarget(self,
                                  action: #selector(didTapPostsButton),
                                  for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = width/4
        profilePhotoImageView.frame = CGRect(x: 5,
                                             y: 5,
                                             width: profilePhotoSize,
                                             height: profilePhotoSize).integral
        let buttonHeight = profilePhotoSize/2
        let countButtonWidth = (width-10-profilePhotoSize)/3
        
        postsButton.frame = CGRect(x: profilePhotoImageView.right,
                                   y: profilePhotoSize/4,
                                   width: countButtonWidth,
                                   height: buttonHeight).integral
        
        followersButton.frame = CGRect(x: postsButton.right,
                                       y: profilePhotoSize/4,
                                       width: countButtonWidth,
                                       height: buttonHeight).integral
        
        followingButton.frame = CGRect(x: followersButton.right,
                                       y: profilePhotoSize/4,
                                       width: countButtonWidth,
                                       height: buttonHeight).integral
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
//        editProfileButton.frame = CGRect(x: profilePhotoImageView.right,
//                                         y: 5 + buttonHeight,
//                                         width: countButtonWidth*3,
//                                         height: buttonHeight).integral
//
        nameLabel.frame = CGRect(x: 5,
                                 y: 5 + profilePhotoImageView.bottom,
                                 width: width-10,
                                 height: 50).integral
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        
        bioLabel.frame = CGRect(x: 5,
                                 y: 5 + nameLabel.bottom,
                                 width: width-10,
                                height: bioLabelSize.height).integral
        
    }
    
    //MARK: - Actions
    @objc private func didTapFollowerButton(){
        delegate?.profileHeaderDidTapFollowersButton(self)
    }
    @objc private func didTapFollowingButton(){
        delegate?.profileHeaderDidTapFollowingButton(self)
    }
    @objc private func didTapEditProfileButton(){
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }
    @objc private func didTapPostsButton(){
        delegate?.profileHeaderDidTopPostsButton(self)
    }
    
    
}


