//
//  SingleImageViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 07.03.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
