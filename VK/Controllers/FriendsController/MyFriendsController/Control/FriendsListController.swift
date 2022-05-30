//
//  FriendsListController.swift
//  VK
//
//  Created by Артур Кондратьев on 03.12.2021.
//

import UIKit

/// Сценарий списка друзей
final class FriendsListController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var service = FriendServiceManager()
    var friend: [FriendsSection] = []
    var filteredFriends: [FriendsSection] = []
    var lettersOfNames: [String] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.sectionFooterHeight = 0.0
        self.tableView.sectionHeaderHeight = 50.0
        searchBar.delegate = self
        fetchFriends()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friend.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend[section].data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = friend[section]
        
        return String(section.key)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return lettersOfNames
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                     for: indexPath) as? FriendsListCell
        else {
            return UITableViewCell()
        }
        
        let section = friend[indexPath.section]
        let name = section.data[indexPath.row].firstName
        let lastName = section.data[indexPath.row].lastName
        let image = section.data[indexPath.row].photo50
        
        cell.friendName.text = name + " " + lastName
        
        service.loadImage(url: image) { image in
            cell.friendAvatar.image = image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView(section: section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CurrentFriendController {
            guard
                let vc = segue.destination as? CurrentFriendController,
                let indexPathSection = tableView.indexPathForSelectedRow?.section,
                let indexPathRow = tableView.indexPathForSelectedRow?.row
            else {
                return
            }
            let section = filteredFriends[indexPathSection]
            let firstName = section.data[indexPathRow].firstName
            let lastName = section.data[indexPathRow].lastName
            let friendId = section.data[indexPathRow].id
            let photo = section.data[indexPathRow].photo50
            
            vc.friendName = firstName
            vc.lastName = lastName
            vc.friendId = String(friendId)
            vc.friendAvatar = photo
        }
    }
}

// MARK: - UISearchBarDelegate
extension FriendsListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends = []
        
        if searchText == "" {
            filteredFriends = friend
        } else {
            for section in friend {
                for (_, friend) in section.data.enumerated() {
                    if friend.firstName.lowercased().contains(searchText.lowercased()) {
                        var searchedSection = section
                        
                        if filteredFriends.isEmpty {
                            searchedSection.data = [friend]
                            filteredFriends.append(searchedSection)
                            break
                        }
                        var found = false
                        for (sectionIndex, filteredSection) in filteredFriends.enumerated() {
                            if filteredSection.key == section.key {
                                filteredFriends[sectionIndex].data.append(friend)
                                found = true
                                break
                            }
                        }
                        if !found {
                            searchedSection.data = [friend]
                            filteredFriends.append(searchedSection)
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // отмена поиска
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true // показать кнопку кансл
        
        let cBtn = searchBar.value(forKey: "cancelButton") as! UIButton
        cBtn.backgroundColor = .lightGray
        cBtn.setTitleColor(.white, for: .normal)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
            // Двигаем кнопку кансл
            cBtn.frame = CGRect(x: cBtn.frame.origin.x - 50,
                                y: cBtn.frame.origin.y,
                                width: cBtn.frame.width,
                                height: cBtn.frame.height)
            
            // Анимируем запуск поиска. -1 чтобы пошла анимация, тогда лупа плавно откатывается
            self.searchBar.frame = CGRect(x: self.searchBar.frame.origin.x,
                                          y: self.searchBar.frame.origin.y,
                                          width: self.searchBar.frame.size.width - 1,
                                          height: self.searchBar.frame.size.height)
            self.searchBar.layoutSubviews()
        })
    }
}


// MARK: - Private

private extension FriendsListController {
    
    func loadLetters() {
        for user in friend {
            lettersOfNames.append(String(user.key))
        }
    }
    
    func fetchFriends() {
        service.loadFriends { [weak self] friends in
            guard let self = self else { return }
            self.friend = friends
            self.filteredFriends = friends
            self.loadLetters()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func createHeaderView(section: Int) -> UIView {
        let header = GradientView()
        header.startColor = .systemBlue
        header.endColor = .white
        
        let letter = UILabel(frame: CGRect(x: 40, y: 10, width: 20, height: 20))
        letter.textColor = .white
        letter.text = lettersOfNames[section]
        letter.font = UIFont.systemFont(ofSize: 20)
        header.addSubview(letter)
        return header
    }
}
