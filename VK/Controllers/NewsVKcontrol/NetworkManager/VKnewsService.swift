//
//  VKnewsService.swift
//  VK
//
//  Created by Артур Кондратьев on 18.04.2022.
//

import Alamofire
import SwiftyJSON

struct Response: Decodable {
    let response: JSON
}

class VKnewsService: UIViewController {
    
    // MARK: - News feed
    
    func loadNews(start_from: String = "",
                  start_time: Double? = nil,
                  completion: ((NewsList?, Error?) -> Void)? = nil) {
        
        let baseUrl = "https://api.vk.com"
        let path = "/method/newsfeed.get"
        
        var params: Parameters = [
            "access_token" : Session.instance.token!,
            "filters" : "post",
        //    "count" : "",
            "start_from" : start_from,
            "v" : "5.81"
        ]
        
        if start_time != nil {
            params ["start_time"] = start_time
        }
        
        AF.request(baseUrl+path, method: .get, parameters: params).responseJSON(queue: .global(qos: .utility)) { respondse in
            
            
            switch respondse.result {
                
            case let .success(value):
                let json = JSON(value)
                
                var newsItem = [NewsObjectItems]()
                var groups = [NewsObjectGroups]()
                var profiles = [NewsObjectProfiles]()
                var next_news = ""
                
                let jsonParseGroup = DispatchGroup()
                
                DispatchQueue.global().async(group: jsonParseGroup) {
                    newsItem = json["response"]["items"].arrayValue.map { NewsObjectItems(json: $0) }
                    next_news = json["response"]["next_from"].stringValue
                }
                
                DispatchQueue.global().async(group: jsonParseGroup) {
                    groups = json["response"]["groups"].arrayValue.map { NewsObjectGroups(json: $0) }
                }
                
                DispatchQueue.global().async(group: jsonParseGroup) {
                    profiles = json["response"]["profiles"].arrayValue.map { NewsObjectProfiles(json: $0) }
                }
                
                jsonParseGroup.notify(queue: DispatchQueue.main) {
                    
                    let newList: [New] = newsItem.map { item in
                        let profile = profiles.first(where: { item.source_id == $0.id })
                        let group = groups.first(where: { item.source_id == -$0.id })
                        
                        return New(item: item, profile: profile, group: group)
                    }
                    
                    let list = NewsList(news: newList, next_from: next_news)
                    
                print(list)
                    completion?(list, nil)
                }
                
            case let .failure(error):
                print(error)
                completion?(nil, error)
            }
        }
    }
}
