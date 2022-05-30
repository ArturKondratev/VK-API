//
//  ComunitiTableViewController.swift
//  VK
//
//  Created by Артур Кондратьев on 03.12.2021.
//
import UIKit

final class ComunitiViewController: UITableViewController {
    
    private let serviceGroup = GroupsService()
    private let imageLoader = ImageLoader()
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchGroups()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ComunitiViewCell
        else {
            return UITableViewCell()
        }
        
        cell.nameLable.text = groups[indexPath.row].name
        imageLoader.loadImageGroups(url: groups[indexPath.row].photo100) { image in
            cell.avatarImage.image = image
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CurrentViewController {
            guard
                let vc = segue.destination as? CurrentViewController,
                // let indexPathSection = tableView.indexPathForSelectedRow?.section,
                let indexPathRow = tableView.indexPathForSelectedRow?.row
            else {
                return
            }
            let section = groups[indexPathRow]
            let groupName = section.name
            let sceenName = section.screen_name
            let groupId = section.id
            let groupAvatar = section.photo100
            
            vc.nameGroup = groupName
            vc.infoGroup = sceenName
            vc.groupId = String(groupId)
            vc.avatarGroup = groupAvatar
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let group = groups[indexPath.row]
            serviceGroup.deleteGroup(id: group.id) { result in
                switch result {
                case .success(let info):
                    print(info)
                case.failure(let error):
                    print(error)
                }
            }
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

private extension ComunitiViewController {
    
    func fetchGroups() {
        serviceGroup.loadGroups { [weak self] result in
            switch result {
            case .success(let group):
                DispatchQueue.main.async {
                    self?.groups = group
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

