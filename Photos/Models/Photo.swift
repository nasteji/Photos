//
//  Photo.swift
//  Photos
//
//  Created by Анастасия Живаева on 02.02.2022.
//

import Foundation
import UIKit

typealias PhotoArray = [Photo]

// MARK: - ItemPhotoElement
struct Photo: Codable {
    let id: String
    let createdAt: String
    var likedByUser: Bool
    let likes: Int
    let downloads: Int?
    let location: Location?
    let urls: Urls
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
        case location
        case urls, user
        case likes, downloads
    }
}

// MARK: - Location
struct Location: Codable {
    let title, country, name, city: String?
}

// MARK: - Urls
struct Urls: Codable {
    let small: String
}

// MARK: - User
struct User: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
