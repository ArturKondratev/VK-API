//
//  Session.swift
//  VK
//
//  Created by Артур Кондратьев on 09.01.2022.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    private init() {}
    
	var token: String?
	var userId: Int?
}
