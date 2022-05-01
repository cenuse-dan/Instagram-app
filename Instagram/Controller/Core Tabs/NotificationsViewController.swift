//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//

import UIKit

enum USerNotificationsType{
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotifications {
    let type: USerNotificationsType
    let text: String
    let user: User
}



final class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    private var models = [UserNotifications]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        //spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
       
    }
    let user1 = User(username: "Joe",
                    bio: "",
                    name: (first: "", last: ""),
                    birthDate: Date(),
                    gender: .male,
                    counds: UserCount(followers: 1, following: 1, posts: 1),
                    joinDate: Date(),
                    profilePhoto: URL(string:"https://static.vecteezy.com/system/resources/previews/001/193/929/large_2x/vintage-car-png.png")!)
    let user2 = User(username: "Rzv",
                    bio: "",
                    name: (first: "", last: ""),
                    birthDate: Date(),
                    gender: .male,
                    counds: UserCount(followers: 1, following: 1, posts: 1),
                    joinDate: Date(),
                    profilePhoto: URL(string:"https://www.kindpng.com/picc/m/181-1813878_vector-car-png-file-vector-png-of-car.png")!)
    var users = [User]()
    
    
    
    private func fetchNotifications() {
        users.append(user1)
        users.append(user2)
       
        for x in 0...20 {
            
            let user = x%3 == 0 ? users[1] : users[0]
            //print (user)
            let post = UserPost(identifier: "",
                                postType: .photo,
                                thumbnailImage: URL(string: "https://thumbnail.imgbin.com/19/20/16/imgbin-url-shortening-ly-internet-web-page-hyperlink-others-2EApVhpuS0pBdEMT27wTR2La7_t.jpg")!,
                                postURL: URL(string: "www.google.com")!,
                                caption: nil,
                                likeCount: [],
                                comments: [],
                                createdDate: Date(),
                                taggedUsers: [],
                                owner: user)
            let model = UserNotifications(type: x%2 == 0 ? .like(post: post) : .follow(state: .following), text: x%2 == 0 ? "Liked" : "Followed"  , user: user)
            models.append(model)
        }
    }
    private func addNoNotificationsView(){
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type{
        case .like(_):
            //like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier, for: indexPath) as! NotificationFollowEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

}


extension NotificationsViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotifications) {
        let user = User(username: "JOe",
                        bio: "",
                        name: (first: "", last: ""),
                        birthDate: Date(),
                        gender: .male,
                        counds: UserCount(followers: 1, following: 1, posts: 1),
                        joinDate: Date(),
                        profilePhoto: URL(string:"https://www.kindpng.com/picc/m/146-1467015_basic-url-web-address-web-urls-icon-png.png")!)
            switch model.type {
            case .like (let post):
            let vc = PostViewController(model: UserPost(identifier: "",
                                                        postType: .photo,
                                                        thumbnailImage: URL(string: "www.google.com")!,
                                                        postURL: URL(string: "www.google.com")!,
                                                        caption: nil,
                                                        likeCount: [],
                                                        comments: [],
                                                        createdDate: Date(),
                                                        taggedUsers: [],
                                                        owner: user))
//            let vc = PostViewController(model:nil)
            vc.title =  post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should never get called")
        }
        //Open the post
        
    }
}


extension NotificationsViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnFollowButton(model: UserNotifications) {
        
        
    }
}
