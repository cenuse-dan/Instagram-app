//
//  Models.swift
//  Instagram
//
//  Created by user216341 on 4/29/22.
//

import Foundation


struct User{
    let username: String
    let bio: String
    let name: String
    let birthDate: String
    let gender: String
    let profilePhoto: URL
   
}

struct UserCount{
    let followers: Int
    let following: Int
    let posts: Int
}
public enum UserPostType: String{
    case photo = "Photo"
    case video = "Video"
}

/// Represents a user post
///
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL  // video or URL or full res photo
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let owner: User
}

struct PostLike{
    let username: String
    let postIdentifier: String
}

struct CommentLike{
    let username: String
    let commentIdentifier: String
}

struct PostComment{
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
    
}
