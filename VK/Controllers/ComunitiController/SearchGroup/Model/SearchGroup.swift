//
//  SearchGroup.swift
//  VK
//
//  Created by Артур Кондратьев on 24.05.2022.
//

import Foundation

struct SearchGroup: Decodable {
    let response: ResponseGroupS
}

struct ResponseGroupS: Decodable {
    let count: Int
    let items: [GroupSearch]
}

struct GroupSearch: Decodable {
    let id: Int
    let name: String
    let photo100: String
    let is_member: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case is_member
        case photo100 = "photo_100"
    }
}
