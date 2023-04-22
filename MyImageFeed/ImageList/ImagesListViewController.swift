//
//  ViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 18.02.2023.
//

import UIKit
import Kingfisher


final class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var InfoImageObserver: NSObjectProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosObserver()
        imagesListService.fetchPhotosNextPage()
        updateTableViewAnimated()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageName = photos[indexPath.row].largeImageURL
            print("FULL IMAGE: \(imageName)")
            if let url = URL(string: imageName) {
                viewController.imageView.kf.setImage(with: url, placeholder: UIImage(named: "DownloadingImage"))
            }
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из определенного типа
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        //приводим к нужному нам типу
        guard let imageListCell = cell as? ImagesListCell else {
            print("We have a problem")
            return UITableViewCell()
        }
        //конфигурируем и возвращаем
        imageListCell.delegate = self
        let cellPhotoURL = photos[indexPath.row].thumbImageURL
        
        if let url = URL(string: cellPhotoURL) {
            imageListCell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "DownloadingImage")){ _ in
                imageListCell.cellImage.kf.indicatorType = .activity
                if let date = self.photos[indexPath.row].createdAt {
                    let dateString = self.dateFormatter.string(from: date)
                    imageListCell.dateLabel.text = "\(dateString)"
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        
        return imageListCell
    }
}

//MARK: TableView delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}


extension ImagesListViewController {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    
    private func photosObserver() {
        InfoImageObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не спамь лайками.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: ImageListCell Deleagete
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
               let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photosId: photo.id, isLiked: !photo.isLiked) { result in
            switch result{
            case .success():
                print("OK")
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("LIKE ERRPR: \(error)")
                self.showAlert()
            }
        }
    }
    
    
}
