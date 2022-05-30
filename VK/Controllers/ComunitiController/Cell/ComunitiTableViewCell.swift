//
//  ComunitiTableViewCell.swift
//  VK
//
//  Created by Артур Кондратьев on 03.12.2021.
//

import UIKit

class ComunitiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ComunitiList: UILabel!
    @IBOutlet weak var ComunutiAvatar: UIImageView!
    
    func configure(name: String, icon: UIImage) {
        ComunitiList.text = name
        ComunutiAvatar.image = icon
        
    }
    
}
