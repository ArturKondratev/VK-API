//
//  ComunitiModel.swift
//  VK
//
//  Created by Артур Кондратьев on 09.12.2021.
//

import Foundation

struct GroupsVK: Decodable {
    let response: ResponseGroup
}

struct ResponseGroup: Decodable {
    let count: Int
    let items: [Group]
}

struct Group: Decodable {
    let id: Int
    let name: String
    let photo100: String
    let screen_name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case photo100 = "photo_100"
        case screen_name = "screen_name"
    }
}
