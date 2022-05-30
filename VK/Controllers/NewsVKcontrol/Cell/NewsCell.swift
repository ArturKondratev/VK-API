//
//  NewsCell.swift
//  VK
//
//  Created by Артур Кондратьев on 16.05.2022.
//

import UIKit

extension DateFormatter {
    convenience init(with format: String) {
        self.init()
        self.dateFormat = format
    }
}

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var publicationTimeLable: UILabel!
    
    @IBOutlet weak var newsTextLable: UILabel! {
        didSet {
            newsTextLable.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var newsPhotoImageView: UIImageView! {
        didSet {
            newsPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var viewsImageView: UIButton!
    
    private let dateFormatter = DateFormatter(with: "dd.MM.yyyy HH.mm")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height/2
    }
    
    func configure(new: New) {
        
        let imageUrl = (new.group != nil) ? new.group?.photo_50 : new.profile?.photo_50
        let text = (new.group != nil) ? new.group?.name : "\(new.profile?.last_name ?? "")  \(new.profile?.first_name ?? "")"
        
        userPhotoImageView.kf.setImage(with: URL(string: imageUrl ?? ""))
        userNameLable.text = text
        publicationTimeLable.text = unixTimeConvertion(unixTime: new.item.date)
        
        
        if let text = new.item.text {
            setNewsText(text: text)
        }
        
        if let image = new.item.photoUrl {
            newsPhotoImageView.kf.setImage(with: URL(string: image))
        }
    
        
        
        likeButton.configuration?.title = "\(new.item.likesCount)"
        commentsButton.configuration?.title = "\(new.item.commentsCount)"
        repostButton.configuration?.title = "\(new.item.repostsCount)"
        viewsImageView.configuration?.title = "\(new.item.viewsCount)"
    }
    
    func unixTimeConvertion(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsLabelFrame()
        iconFrame()
    }
    
    
    let instets: CGFloat = 50.0
    
    func setNewsText (text: String) {
        newsTextLable.text = text
        newsLabelFrame()
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // определяем максимальную ширину текста - это ширина ячейки минус
        // отступы слева и справа
        let maxWidth = bounds.width - instets * 2
        // получаем размеры блока под надпись
        // используем максимальную ширину и максимально возможную высоту
        let textBlock = CGSize(width: maxWidth, height:
                                CGFloat.greatestFiniteMagnitude)
        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options:
                                            .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        // получаем ширину блока, переводим её в Double
        let width = Double(rect.size.width)
        // получаем высоту блока, переводим её в Double
        let height = Double(rect.size.height)
        // получаем размер, при этом округляем значения до большего целого
        // числа
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func newsLabelFrame() {
        //получаем размер текста, передавая сам текст и шрифт.
        let weaterLabelSize = getLabelSize(text: newsTextLable.text!, font:
                                            newsTextLable.font)
        //рассчитывает координату по оси Х
        let weaterLabelX = (bounds.width - weaterLabelSize.width) / 2
        //получим точку верхнего левого угла надписи
        let weaterLabelOrigin = CGPoint(x: weaterLabelX, y: instets)
        //получаем фрейм и устанавливаем UILabel
        newsTextLable.frame = CGRect(origin: weaterLabelOrigin, size:
                                        weaterLabelSize)
    }
    
    func iconFrame() {
        let iconSideLinght: CGFloat = 100
    
        let iconSize = CGSize(width: iconSideLinght, height:
                                iconSideLinght)
        let iconOrigin = CGPoint(x: bounds.midX - iconSideLinght / 2, y:
                                    bounds.midY - iconSideLinght / 2)
        newsPhotoImageView.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
}


