//
//  ProfileViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//

import UIKit


/// Profile view controller

final class ProfileViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    private var userPosts = [UserPost]()
    let db = SQLiteDatabase()
    func createposts() {
        collectionView?.reloadData()
        let user = db.returnTheCurrentUser()
        print(user)
//        for _ in 0...5 {
//            userPosts.append(UserPost(identifier: "",
//                                      postType: .photo,
//                                      thumbnailImage: URL(string: "https://thumbnail.imgbin.com/19/20/16/imgbin-url-shortening-ly-internet-web-page-hyperlink-others-2EApVhpuS0pBdEMT27wTR2La7_t.jpg")!,
//                                      postURL: URL(string: "https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg")!,
//                                      caption: nil,
//                                      likeCount: [],
//                                      comments: [],
//                                      createdDate: Date(),
//                                      taggedUsers: [],
//                                      owner: user))
//        }
        userPosts = db.returnUserPosts()
        //print(userPosts.count)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //retuser()
        collectionView?.reloadData()
        //db.postcount()
       // db.countuser()
        view.backgroundColor = .systemBackground
        configureNaivationBar()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 1,
                                           bottom: 0,
                                           right: 1)
        let size = (view.width - 4 )/3
        layout.itemSize = CGSize(width: size,
                                 height: size)
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        
        //Cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        //Headers
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        
        collectionView?.register(ProfileTabsCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileTabsCollectionReusableView.identifier )
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
       
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
        ProfileInfoHeaderCollectionReusableView().nameLabel.text = "EU"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView?.reloadData() ///// ASTA !!!!!!!!!!!!!!!!!!!!!!
       print("test")
        createposts()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        createposts()
   
    }
    
    private func configureNaivationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettingsButton))
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
        
    }


}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }
         return userPosts.count
        
        //return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = userPosts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                      for: indexPath)
                                                      as! PhotoCollectionViewCell
        cell.configure(with: model)
        //cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // get the model and open post controoler
        let model = userPosts[indexPath.row]
        let vc = PostViewController(model:model)
        vc.title = "Post"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        if indexPath.section == 1{
            let tabControlHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: ProfileTabsCollectionReusableView.identifier,
                                                                         for: indexPath) as! ProfileTabsCollectionReusableView
            
            tabControlHeader.delegate = self
            return tabControlHeader
        }
                let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier,
                                                                     for: indexPath) as! ProfileInfoHeaderCollectionReusableView


        //AICI FAC PROFIL
        profileHeader.delegate = self
        let user = db.self.returnTheCurrentUser()
       // propostImageView.sd_setImage(with: post.postURL, completed: nil)
        
        profileHeader.profilePhotoImageView.loadFrom(URLAddress: user.profilePhoto.absoluteString)
        //profileHeader.profilePhotoImageView.sd_setImage(with: user.profilePhoto, completed: nil)
        profileHeader.nameLabel.text = user.name
        profileHeader.bioLabel.text = user.bio
       
       return profileHeader
  
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.width,
                          height: collectionView.height/3)
        }
        
        // Size of section tabs
        return CGSize(width: collectionView.width,
                      height: 50)
    }
    
}

// MARK : - ProfileInfoHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTopPostsButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        //scroll to the posts section
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        
    }
    
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData=[UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(username: "@Joe", name: "Joe Smith", type: x%2 == 0 ? .following: .not_following))
        }
        let vc = ListViewController(data: mockData)
        vc.title = "Followers"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData=[UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(username: "@Joe", name: "Joe Smith", type: x%2 == 0 ? .following: .not_following))
        }
        let vc = ListViewController(data: mockData)
        vc.title = "Following"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        
       // present(UINavigationController(rootViewController: vc),animated: true)
        present(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        collectionView?.reloadData()
  
    }
    
    
}

extension ProfileViewController: ProfileTabsCollectionReusableViewDelegate {
    func didTapGridButtonTab() {
        
    }
    
    func didTapTaggedButtonTab() {
        
    }

}

