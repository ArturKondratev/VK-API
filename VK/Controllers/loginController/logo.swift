//
//  logo.swift
//  VK
//
//  Created by Артур Кондратьев on 16.12.2021.
//

import UIKit

@IBDesignable class logo: UIView {

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        addSubview(imageView)
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor.black.cgColor
//        imageView.layer.masksToBounds = true
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 20, height: 20)
//        self.layer.shadowRadius = 10
//        self.layer.shadowOpacity = 0.8
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageView.frame = bounds
//        let radius = frame.size.width / 2
//        self.layer.cornerRadius = radius
//        imageView.layer.cornerRadius = radius
//    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
    }

}
