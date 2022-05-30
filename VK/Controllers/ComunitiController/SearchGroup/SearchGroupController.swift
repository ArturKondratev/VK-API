//
//  SearchGroupController.swift
//  VK
//
//  Created by Артур Кондратьев on 24.05.2022.
//

import UIKit

class SearchGroupController: UITableViewController, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let groupService = GroupService()
    private let imageLoader = ImageLoader()
    private var groups: [GroupSearch] = []
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        // navigationController?.navigationBar.prefersLargeTitles = true
        //  searchController.obscuresBackgroundDuringPresentation = false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SearchGroupCell
        else {
            return UITableViewCell()
        }
        
        cell.groupName.text = groups[indexPath.row].name
        imageLoader.loadImageGroups(url: groups[indexPath.row].photo100) { image in
            cell.avatarImage.image = image
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let group = groups[indexPath.row]
        
        if group.is_member == 1 {
            showInfo()
        } else {
            successInfo(nameGroup: group.name)
            self.groupService.addGroup(idGroup: group.id) { result in
                switch result {
                case .success(let info):
                    print(info)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            
            self.groupService.loadGroupSearch(searchText: searchText) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let group):
                    DispatchQueue.main.async {
                        self.groups = group
                        print(group)
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        })
    }
    
    func successInfo(nameGroup: String) {
        // Создаем контроллер
        let alert = UIAlertController(title: "Сообщение", message: "Вы вступили в сообщество \(nameGroup)", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alert.addAction(action)
        // Показываем UIAlertController
        present(alert, animated: true, completion: nil)
    }
    
    func showInfo() {
        // Создаем контроллер
        let alert = UIAlertController(title: "Сообщение", message: "Вы состоите в этой группе", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alert.addAction(action)
        // Показываем UIAlertController
        present(alert, animated: true, completion: nil)
    }
}
