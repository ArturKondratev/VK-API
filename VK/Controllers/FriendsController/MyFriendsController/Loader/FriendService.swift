//
//  FriendService.swift
//  VK
//
//  Created by Артур Кондратьев on 24.01.2022.
//

import Foundation

// MARK: - Request Friend Vk.API
// создадим енум-кейс с типами запросов

fileprivate enum TypeMethods: String {
    case friendsGet = "/method/friends.get"
    case friendsSearch = "/method/friends.search"
    
}

// Создадим список типов запросов
fileprivate enum TypeRequest: String {
    case get = "GET"
    case post = "POST"
}


final class FriendService {
    
    // MARK: - Error
    // создадим енум с возможными ошибками
    enum FriendsError: Error {
        case parseError
        case requestError(Error)
    }
    
    // создадим собственную сессию в которой определим конфигурацию запроса по дефолту
    private let session: URLSession = {
        // конфиг по дефолту
        let config = URLSessionConfiguration.default
        // с собственная сессия с конфигурацией
        let session = URLSession(configuration: config)
        // возвращаем константу сессия
        return session
    }()
    //    // определим наш реалм менеджер
    // private let realmService = RealmManager.shared
    // определим по какому протоколу будем делать запрос
    private let scheme = "https"
    // определим адресс сервера
    private let host = "api.vk.com"
    // определим в каком формате нам нужно вернуть данные
    private let decoder = JSONDecoder()
    
    // MARK: - Запросы на сервер
    /*
     Создадим метод который отправит запрос на сервер для получения списка друзей текущего пользователя
     */
    func loadFriends(completion: @escaping (Result<[Friend], FriendsError>) -> Void) {
        // проверим константу с полученным токеном если true то продолжаем запрос если false то ничего не вернем
        guard let token = Session.instance.token else {
            return
        }
        // определим наши параметры для запроса к серверу
        // по умолчанию используется йд текущего пользователя параметр extended выводит полную информацию о группе см. АПИ ВК метод friends.get
        
        let params: [String: String] = [ "fields": "photo_50" ]
        
        // присвоим константе сконфигурированный УРЛ для отправки запроса
        let url = configureUrl(token: token,
                               method: .friendsGet,
                               httpMethod: .get,
                               params: params)
        // выведим в консоль наш с конфигурированный УРЛ
        print(url)
        // создадим задачу для запуска
        let task = session.dataTask(with: url) { data, response, error in
            // делаем проверку по отсутствию значения в параметре error
            if let error = error {
                // если true то вернуть ошибку
                return completion(.failure(.requestError(error)))
            }
            // делаем проверку по наличию данных в константе data
            guard let data = data else { return }
            
            do {
                //данные полученные от сервера декодируем
                let result = try self.decoder.decode(FriendsVK.self, from: data)
                // выводим результат в консоль
                print(result)
                //                // добавим метод по добавлении массива обьекта в БД
                //                try? self.realmService?.add(object: result.response.items)
                // если true то заполняем массив
                return completion(.success(result.response.items))
            } catch {
                // если false то ошибка
                return completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    

    
}

// MARK: - Private
// расширим класс для определения модели конфигурации УРЛ
private extension FriendService {
    // опишем метод который будет содержать что должно храниться в запросе
    func configureUrl(token: String,
                      method: TypeMethods,
                      httpMethod: TypeRequest,
                      params: [String: String]) -> URL {
        
        // определим переменную которая содержит массив параметров для запросов
        var queryItems = [URLQueryItem]()
        
        // добавляем общие для всех параметры
        // токен цифровой ключ доступа
        queryItems.append(URLQueryItem(name: "access_token", value: token))
        // версия API VK
        queryItems.append(URLQueryItem(name: "v", value: "5.81"))
        // сделаем счетчик параметров и значений из осапиных параметров по модели
        for (param, value) in params {
            queryItems.append(URLQueryItem(name: param, value: value))
        }
        
        // определим в параметр наши УРЛ компоненты протокол-хост-метод-параметры
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        urlComponents.queryItems = queryItems
        
        // проверяем наш УРЛ если true то ОК если false то вывести ошибку
        guard let url = urlComponents.url else {
            fatalError("URL is invalid")
        }
        return url
    }
}
