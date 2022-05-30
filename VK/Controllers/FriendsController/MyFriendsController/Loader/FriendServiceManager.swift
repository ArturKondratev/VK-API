//
//  FriendServiceManager.swift
//  VK
//
//  Created by Артур Кондратьев on 15.12.2021.
//

import UIKit

// Создадим класс который будет сортировать наших друзей по первой буквы первого имени
class FriendServiceManager {

	// Сущность для работы с апи (Друзья)
	private var service = FriendService()

	// Сущность для загрузки картинок
	private let imageService = ImageLoader()

	// Разбираем друзей по ключам в зависимости от первой буквы первого имени
	private func sortFriends(_ array: [Friend]) -> [Character: [Friend]] {
		// создадим переменную которая будет в себе хранить словарь из ключа(чарактер):значение из модели
		var newArray: [Character: [Friend]] = [:]
		// запустим счетчик который будет перебирать друзей из масива друзей
		for user in array {
			// создадим константу ферстчар с первым символом первого имени(firstName)
			// и проверим если true то продолжаем если false то закончить выполнение итерации цикла
			guard let firstChar = user.firstName.first else {
				continue
			}
			// создадим переменную которая хранит в себе массив букв(первые буквы имени)
			// проверим если такого значения(ключа) нет, то создадим секцию с этим значением(ключом)
			guard var array = newArray[firstChar] else {
				// константа с массивом друзей
				let newValue = [user]
				// обнавление значения ключа
				newArray.updateValue(newValue, forKey: firstChar)
				// завершаем итерацию цикла
				continue
			}

			// если секция нашлась то добавим в массив ещё одну
			array.append(user)
			newArray.updateValue(array, forKey: firstChar)
		}
		return newArray
	}

	// создадим метод который вернет секцию
	private func formFriendSection(_ array: [Character: [Friend]]) -> [FriendsSection] {
		// создадим переменную которая хранит в себе массив секций
		var sectionArray: [FriendsSection] = []
		// запустим счетчик ключа и значения по переданному масиву
		for (key, array) in array {
			// если тру, то добавить в массив ключ и значение
			sectionArray.append(FriendsSection(key: key, data: array))
		}

		// сортируем секции по алфавиту
		sectionArray.sort {$0 < $1}

		return sectionArray
	}

	// создадим статическую функцию которая вернет массив сортированных секций
	private func formFriendArray(from array: [Friend]?) -> [FriendsSection] {
		guard let array = array else {
			return []
		}
		let sorted = sortFriends(array)
		return formFriendSection(sorted)
	}

	// Загружаем список друзей
	func loadFriends(completion: @escaping ([FriendsSection]) -> Void) {
		service.loadFriends { [weak self] result in
			switch result {
			case .success(let friend):
				guard let section = self?.formFriendArray(from: friend) else { return }
				completion(section)
			case .failure(_):
				return
			}
		}
	}

	// MARK: - FunctionLoadImage Convertbl data in UIImage
	// напишем метод который будет преобразооывать УРЛ в UIImage
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
