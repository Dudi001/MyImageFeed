//
//  ImageListCell.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 24.02.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}


final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    static let reuseIdentifier = "ImageListCell"
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
}

extension ImagesListCell {
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: "ActiveLike"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "NoActiveLike"), for: .normal)
        }
    }
    
    @IBAction private func likeButtonClicked() {
       delegate?.imageListCellDidTapLike(self)
    } 
}





