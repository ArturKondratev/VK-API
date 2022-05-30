//
//  PhotoGroupsModel.swift
//  VK
//
//  Created by Артур Кондратьев on 01.04.2022.
//

import Foundation

struct PhotoGroups: Codable {
    let response: ResponsePhotoGroups
}

struct ResponsePhotoGroups: Codable {
    let count: Int
    let items: [InfoPhotoGroup]
}

struct InfoPhotoGroup: Codable {
    var sizes: [SizePhoto]
    var text: String

    enum CodingKeys: String, CodingKey {
        case sizes
        case text
    }
}

struct SizePhoto: Codable {
    let url: String
    let type: SizeType

    enum SizeType: String, Codable {
        case m = "m"
        case o = "o"
        case p = "p"
        case q = "q"
        case r = "r"
        case s = "s"
        case w = "w"
        case x = "x"
        case y = "y"
        case z = "z"
    }
}

