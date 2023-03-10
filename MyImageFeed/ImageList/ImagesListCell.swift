//
//  ImageListCell.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 24.02.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    static let reuseIdentifier = "ImageListCell"
    
}

extension ImagesListCell {
    func configCell(image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date

        let likeImage = isLiked ? UIImage(named: "ActiveLike") : UIImage(named: "NoActiveLike")
        likeButton.setImage(likeImage, for: .normal)
    }
}

