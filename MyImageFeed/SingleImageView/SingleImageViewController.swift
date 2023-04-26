//
//  SingleImageViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 07.03.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    var urlImage: URL?
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        showImage(largeURL: urlImage!)
    }
    

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        let actionShareButton = UIActivityViewController(
            activityItems: [image!],
            applicationActivities: nil
        )
        present(actionShareButton, animated: true)
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController {
    private func showImage(largeURL: URL) {
        guard isViewLoaded else {return}
        let imageView = UIImageView()
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: largeURL,
                                    placeholder: UIImage(named: "placeholder")) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {return}
            switch result {
            case .success(let imageResult):
                self.imageView.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать ещё раз?",
            preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "Нет", style: .default){ _ in
            self.dismiss(animated: true)
        }
        let actionYes = UIAlertAction(title: "Да", style: .default){ [weak self] _ in
            if let imageTemp = self?.urlImage{
                self?.showImage(largeURL: imageTemp)
            }
            
        }
        
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true)
    }
}
