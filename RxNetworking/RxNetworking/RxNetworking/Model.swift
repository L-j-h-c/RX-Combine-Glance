//
//  Model.swift
//  RxNetworking
//
//  Created by Junho Lee on 2022/05/11.
//

import Foundation

struct Response: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: PostData
}

// MARK: - DataClass
struct PostData: Codable {
    let postID: Int
    let title, content, tag: String
    let imageURL: String
    let createdAt: String
    let writer: Writer
    let emojiList: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, content, tag, imageURL, createdAt, writer, emojiList
    }
}

// MARK: - Writer
struct Writer: Codable {
    let userID: Int
    let nickname: String
    let profileImageID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case profileImageID = "profileImageId"
    }
}
