//
//  GroupsSection.swift
//  VK
//
//  Created by Артур Кондратьев on 30.03.2022.
//

struct GroupsSection: Comparable {

    var key: Character
    var data: [Group]

    static func < (lhs: GroupsSection, rhs: GroupsSection) -> Bool {
        return lhs.key < rhs.key
    }

    static func == (lhs: GroupsSection, rhs: GroupsSection) -> Bool {
        return lhs.key == rhs.key
    }
}
