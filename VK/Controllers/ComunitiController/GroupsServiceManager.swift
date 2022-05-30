//
//  GroupsServiceManager.swift
//  VK
//
//  Created by Артур Кондратьев on 30.03.2022.
//

import UIKit

class GroupsServiceManager {
    
    private var service = GroupsService()
    
    private let imageService = ImageLoader()
    
    private func sortGroups(_ array: [Group]) -> [Character: [Group]] {
        // создадим переменную которая будет в себе хранить словарь из ключа(чарактер):значение из модели
        var newArray: [Character: [Group]] = [:]
        // запустим счетчик который будет перебирать друзей из масива друзей
        for group in array {
            // создадим константу ферстчар с первым символом первого имени(firstName)
            // и проверим если true то продолжаем если false то закончить выполнение итерации цикла
            guard let firstChar = group.name.first else {
                continue
            }
            // создадим переменную которая хранит в себе массив букв(первые буквы имени)
            // проверим если такого значения(ключа) нет, то создадим секцию с этим значением(ключом)
            guard var array = newArray[firstChar] else {
                // константа с массивом друзей
                let newValue = [group]
                // обнавление значения ключа
                newArray.updateValue(newValue, forKey: firstChar)
                // завершаем итерацию цикла
                continue
            }

            // если секция нашлась то добавим в массив ещё одну
            array.append(group)
            newArray.updateValue(array, forKey: firstChar)
        }
        return newArray
    }
    
    // создадим метод который вернет секцию
    private func formGroupSection(_ array: [Character: [Group]]) -> [GroupsSection] {
        // создадим переменную которая хранит в себе массив секций
        var sectionArray: [GroupsSection] = []
        // запустим счетчик ключа и значения по переданному масиву
        for (key, array) in array {
            // если тру, то добавить в массив ключ и значение
            sectionArray.append(GroupsSection(key: key, data: array))
        }
        // сортируем секции по алфавиту
        sectionArray.sort {$0 < $1}
        return sectionArray
    }
    
    // создадим статическую функцию которая вернет массив сортированных секций
    private func formGroupArray(from array: [Group]?) -> [GroupsSection] {
        guard let array = array else {
            return []
        }
        let sorted = sortGroups(array)
        return formGroupSection(sorted)
    }
    
    // Загружаем список друзей
    func loadGroups(completion: @escaping ([GroupsSection]) -> Void) {
        service.loadGroups { [weak self] result in
            switch result {
            case .success(let group):
                guard let section = self?.formGroupArray(from: group) else { return }
                completion(section)
            case .failure(_):
                return
            }
        }
    }
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        // если в константе урл нет записи то вернем пустоту
        guard let url = URL(string: url) else { return }
        // запустим метод который преобразует УРЛ в дату с входным параметром УРЛ
        imageService.loadImage(url: url) { result in
            switch result {
                // если все успешно, то нашу преобразованую data преобразуем в UIImage
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                // возвращаем полученную картинку
                completion(image)
                // если не удачно то выведем в консоль ошибку
            case .failure(let error):
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }
}
