//
//  NewsObject.swift
//  VK
//
//  Created by Артур Кондратьев on 16.05.2022.
//

import SwiftyJSON

struct NewsList {
    var news: [New]
    var next_from: String
}

struct New {
    var item: NewsObjectItems
    var profile: NewsObjectProfiles?
    var group: NewsObjectGroups?
}

struct NewsObject {
    var items: [NewsObjectItems]
    var profiles: [NewsObjectProfiles]
    var groups: [NewsObjectGroups]
    var next_from: String
}

class NewsObjectItems {
    var source_id: Int = 0
    var date: Double = 0
    var text: String?
    var commentsCount: Int = 0
    var likesCount: Int = 0
    var likesUser: Int = 0
    var repostsCount: Int = 0
    var repostsUser: Int = 0
    var viewsCount: Int = 0
    
    var photoUrl: String?
    var width: Int = 0
    var heigh: Int = 0
    var aspectRatio: CGFloat { return CGFloat(heigh)/CGFloat(width)}
    
    convenience init (json: JSON) {
        self.init()
        
        if let source_id = json["source_id"].int {
            self.source_id = source_id
        }
        if let date = json["date"].double {
            self.date = date
        }
        if let text = json["text"].string {
            self.text = text
        }
        if let likesCount = json["likes"]["count"].int {
            self.likesCount = likesCount
        }
        if let likesUser = json["likes"]["user_likes"].int {
            self.likesUser = likesUser
        }
        if let commentsCount = json["comments"]["count"].int {
            self.commentsCount = commentsCount
        }
        if let repostsCount = json["reposts"]["count"].int {
            self.repostsCount = repostsCount
        }
        if let repostsUser = json["reposts"]["user_reposted"].int {
            self.repostsUser = repostsUser
        }
        if let viewsCount = json["views"]["count"].int {
            self.viewsCount = viewsCount
        }
        
        let sizesArray = json["attachments"][0]["photo"]["sizes"].arrayValue
        
        if !sizesArray.isEmpty {
            let xSize = sizesArray.first(where: { $0["type"].stringValue == "x" }) ?? sizesArray.last
            let url = xSize!["url"].string
                self.width = xSize!["width"].intValue
                self.heigh = xSize!["height"].intValue
                self.photoUrl = url
        }
    }
}

class NewsObjectProfiles {
    var id: Int = 0
    var first_name: String = ""
    var last_name: String = ""
    var photo_50: String = ""
    
    
    convenience init (json: JSON) {
        self.init()
        
        if let id = json["id"].int {
            self.id = id
        }
        if let first_name = json["first_name"].string {
            self.first_name = first_name
        }
        if let last_name = json["last_name"].string {
            self.last_name = last_name
        }
        if let photo_50 = json["photo_50"].string {
            self.photo_50 = photo_50
        }
    }
}

class NewsObjectGroups {
    var id: Int = 0
    var name: String = ""
    var photo_50: String = ""
    
    convenience init (json: JSON) {
        self.init()
        
        if let id = json["id"].int {
            self.id = id
        }
        if let name = json["name"].string {
            self.name = name
        }
        if let photo_50 = json["photo_50"].string {
            self.photo_50 = photo_50
        }
    }
}
