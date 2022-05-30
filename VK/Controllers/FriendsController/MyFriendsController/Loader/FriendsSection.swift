//
//  FriendsSection.swift
//  VK
//
//  Created by Артур Кондратьев on 15.12.2021.
//

struct FriendsSection: Comparable {

    var key: Character
    var data: [Friend]

    static func < (lhs: FriendsSection, rhs: FriendsSection) -> Bool {
        return lhs.key < rhs.key
    }

    static func == (lhs: FriendsSection, rhs: FriendsSection) -> Bool {
        return lhs.key == rhs.key
    }
}
