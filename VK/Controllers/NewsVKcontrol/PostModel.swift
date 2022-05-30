//
//  PostModel.swift
//  VK
//
//  Created by Артур Кондратьев on 16.05.2022.
//

import Foundation
import SwiftUI

struct Post {
    
    enum PostType: String {
        case imageOnly = "ImagePostCell"
        case textOnly = "TextPostcell"
        case imageAndText = "ImageAndText"
    }
    
    let text: String?
    let photoUrl: URL?
    
    var postType: PostType? {
        let hasImage = photoUrl != nil
        let hastext = text != nil
        
        switch (hasImage, hastext) {
        case (true, true): return .imageAndText
        case (true, false): return .imageOnly
        case (false, true): return .textOnly
        case (false, false): return nil
        }
    }
}
