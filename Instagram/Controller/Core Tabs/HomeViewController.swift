//
//  ViewController.swift
//  Instagram
//
//  Created by user216341 on 4/21/22.
//
import FirebaseAuth
import UIKit


struct HomeFeedRenderViewModel{
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {

    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IGFeedPostTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMackModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
 

    }
    private func createMackModels() {
        // use user from databse
        let user = User(username: "Joe",
                        bio: "",
                        name: "",
                        birthDate: "",
                        gender: "male",
                        profilePhoto: URL(string:"https://static.vecteezy.com/system/resources/previews/001/193/929/large_2x/vintage-car-png.png")!)
        // use post from database
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://thumbnail.imgbin.com/19/20/16/imgbin-url-shortening-ly-internet-web-page-hyperlink-others-2EApVhpuS0pBdEMT27wTR2La7_t.jpg")!,
                            postURL: URL(string: "https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg")!,
                            caption: nil,
                            likeCount: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUsers: [],
                            owner: user)
        // use comments from database
        var comments = [PostComment]()
        for x in 0...2{
            comments.append(PostComment(identifier: "\(x)",
                                        username: "@Vali",
                                        text: "Post",
                                        createdDate: Date(),
                                        likes: []))
            
        }
        //Retruneaza un count
        
        for _ in 0...1 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provide: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
      
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
       // let user = SQLiteDatabase().readtest()
        
        //print("am ajuns home",user.name)
    
    }
    private func handleNotAuthenticated(){
        //Check auth status
        if Auth.auth().currentUser == nil{
        
            let loginVC=LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC,animated: false)
        
    

                }
        }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model :HomeFeedRenderViewModel
        if x == 0 {
            
            model = feedRenderModels[0]
            
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x-(x % 4))/4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            return 1
            
        }
        else if subSection == 1{
            return 1
        }
        else if subSection == 2 {
            return 1
        }
        else if subSection == 3 {
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2: comments.count
            case .header, .actions, .primaryContent : return 0
                
            }
        }
        

        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model :HomeFeedRenderViewModel
        if x == 0 {
            
            model = feedRenderModels[0]
            
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x-(x % 4))/4)
            model = feedRenderModels[position]
        }
        let subSection = x % 4
        
        if subSection == 0 {
            let headerModel = model.header
            switch headerModel.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                                                                      for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent : return UITableViewCell()
                
            }
            
        }
        else if subSection == 1{
            let postModel = model.post
            switch postModel.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,
                                                                                    for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
                
            case .comments, .actions, .header : return UITableViewCell()
            }
            
        }
        else if subSection == 2 {
            let actionModel = model.actions
            switch actionModel.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostActionsTableViewCell
                cell.delegate = self
                return cell
            case .comments, .header, .primaryContent : return UITableViewCell()
            }
        }
        else if subSection == 3 {
            let commentModel = model.comments
            switch commentModel.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,
                                                                for: indexPath) as! IGFeedPostGeneralTableViewCell
                cell.configure(with: comments[0])
                return cell
            case .header, .actions, .primaryContent : return UITableViewCell()
            }
        }
        
        return UITableViewCell()

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
       
        if subSection == 0 {
            return 70
        }
        else if subSection == 1 {
            return tableView.width
        }
        else if subSection == 2 {
            return 60
        }
        else if subSection == 3 {
            return 50
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
    
}


extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report", style: .destructive, handler: {[weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet,animated: true)
    }
    func reportPost(){
        
    }
    }
    
