//
//  CurrentViewController.swift
//  VK
//
//  Created by Артур Кондратьев on 01.04.2022.
//

import UIKit

class CurrentViewController: UIViewController {
    
    @IBOutlet weak var groupAvatar: TestView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupInfo: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let service = PhotoServiceGroups()
    var infoPhotosGroup: [InfoPhotoGroup] = []
    
    var groupId = ""
    var nameGroup = ""
    var infoGroup = ""
    var avatarGroup = ""
    var storedImages: [String] = []
    var storedImagesZ: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchPhotos()
        groupName.text = nameGroup
        groupInfo.text = infoGroup
        
        service.loadImage(url: avatarGroup) { [weak self] image in
            guard let self = self else { return }
            self.groupAvatar.image = image
        }
    }
}

extension CurrentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CurrentGroupViewCell else { return UICollectionViewCell() }
        
        service.loadImage(url: storedImages[indexPath.item]) { image in
            cell.groupImages.image = image
        }
        return cell
    }
}

private extension CurrentViewController {
    
    func sortImage(by sizeType: SizePhoto.SizeType, from array: [InfoPhotoGroup]) -> [String] {
        var imageLinks: [String] = []
        for model in array {
            for size in model.sizes {
                if size.type == sizeType {
                    imageLinks.append(size.url)
                }
            }
        }
        return imageLinks
    }
    
    func fetchPhotos() {
        
        service.loadPhoto(idGroup: groupId) { [weak self] model in
            guard let self = self else { return }
            switch model {
            case .success(let groupPhoto):
                self.infoPhotosGroup = groupPhoto
                let images = self.sortImage(by: .m, from: groupPhoto)
                self.storedImages = images
                let imagesZ = self.sortImage(by: .z, from: groupPhoto)
                self.storedImagesZ = imagesZ
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
