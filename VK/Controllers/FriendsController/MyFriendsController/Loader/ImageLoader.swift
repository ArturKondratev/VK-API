//
//  ImageLoader.swift
//  VK
//
//  Created by Олег Ганяхин on 30.01.2022.
//

import Foundation
import UIKit

// MARK: - ClassLoaderImage convertbl URL(String) in data
class ImageLoader {
    
    // создадим собственную сессию в которой определим конфигурацию запроса по дефолту
    private let session: URLSession = {
        // конфиг по дефолту
        let config = URLSessionConfiguration.default
        // с собственная сессия с конфигурацией
        let session = URLSession(configuration: config)
        // возвращаем константу сессия
        return session
    }()
    
    // Загружает данные для картинки и возвращает их, если получилось
    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        // запишем константу которая в себя запишет либо данные картинки либо ошибку
        let completionOnMain: (Result<Data, Error>) -> Void = { result in
            // в потоке майн возвращаем результат
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        // преобразуем УРЛ в дату
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            // проверим нашы полученые данные и если ошибки не нил
            guard let responseData = data, error == nil else {
                // и если константа еррор заполнилась данными вернуть результат ошибки
                if let error = error {
                    // в константу комплешн
                    completionOnMain(.failure(error))
                }
                return
            }
            // если успешно то успех
            completionOnMain(.success(responseData))
            // и продолжаем дальше
        }).resume()
    }
    
    
    func loadImageGroups(url: String, completion: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return}
        loadImage(url: url) { result in
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
