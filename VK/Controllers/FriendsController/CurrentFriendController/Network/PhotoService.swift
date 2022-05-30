//
//  PhotoService.swift
//  VK
//
//  Created by Артур Кондратьев on 31.03.2022.
//

import Foundation
import UIKit

enum PhotosError: Error {
    case parseError
    case requestError(Error)
}

fileprivate enum TypeMethods: String {
    case photosGetAll = "/method/photos.getAll"
}

fileprivate enum TypeRequests: String {
    case get = "GET"
    case post = "POST"
}

class PhotoService {
    
    let imageService = ImageLoader()
    
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()

    private let scheme = "https"
    private let host = "api.vk.com"

    private let decoder = JSONDecoder()

    func loadPhoto(idFriend: String, completion: @escaping (Result<[InfoPhotoFriend], PhotosError>) -> Void) {
        guard let token = Session.instance.token else { return }

        let params: [String: String] = ["owner_id": idFriend,
                                        "extended": "1",
                                        "count": "200"]

        let url = configureUrl(token: token,
                               method: .photosGetAll,
                               htttpMethod: .get,
                               params: params)
        print(url)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(.requestError(error)))
            }
            guard let data = data else {
                return
            }
            do {
                let result = try self.decoder.decode(PhotoFriends.self, from: data)
                print(result)
                return completion(.success(result.response.items))
            } catch {
                return completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    

    func loadImage(url: String, completion: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return}
        imageService.loadImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(let error):
                debugPrint("Error:\(error.localizedDescription)")
            }
        }
    }
    
    
}

private extension PhotoService {
    func configureUrl(token: String,
                      method: TypeMethods,
                      htttpMethod: TypeRequests,
                      params: [String: String]) -> URL {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "access_token", value: token))
        queryItems.append(URLQueryItem(name: "v", value: "5.131"))

        for (param, value) in params {
            queryItems.append(URLQueryItem(name: param, value: value))
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            fatalError("URL is invalid")
        }
        return url
    }
}

