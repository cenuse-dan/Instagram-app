//
//  Models.swift
//  Instagram
//
//  Created by user216341 on 4/29/22.
//

import Foundation
enum Gender{
    case male, female, other
}

struct User{
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let counds: UserCount
    let joinDate: Date
}

struct UserCount{
    let followers: Int
    let following: Int
    let posts: Int
}
public enum UserPostType{
    case photo, video
}

/// Represents a user post
///
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL  // video or URL or full res photo
    let caption: String?
    let likeCount: Int
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
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
    let ssername: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
    
}
