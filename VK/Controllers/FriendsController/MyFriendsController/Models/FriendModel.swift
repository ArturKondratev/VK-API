//
//  FriendModel.swift
//  VK
//
//  Created by Артур Кондратьев on 03.12.2021.
//

import Foundation

struct FriendsVK: Codable {
	let response: ResponseFriends
}

struct ResponseFriends: Codable {
	let count: Int
	let items: [Friend]
}

struct Friend: Codable {
	var id: Int
	var firstName: String
	var lastName: String
	var photo50: String

	enum CodingKeys: String, CodingKey {
		case id
		case firstName = "first_name"
		case lastName = "last_name"
		case photo50 = "photo_50"
	}
}
