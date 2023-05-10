//
//  ViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 18.02.2023.
//

import UIKit
import Kingfisher


protocol ImagelistViewControllerProtocol: AnyObject {
    var presenter: ImageListViewPresenterProtocol? { get set }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController, ImagelistViewControllerProtocol {
    var presenter: ImageListViewPresenterProtocol?
    

    @IBOutlet private var tableView: UITableView!
    
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
        
//        photosObserver()
        presenter?.photosObserver()
        imagesListService.fetchPhotosNextPage()
        updateTableViewAnimated()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageName = photos[indexPath.row].largeImageURL
            if let urlImage = URL(string: imageName) {
                viewController.urlImage = urlImage
            }
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configure(_ presenter: ImageListViewPresenterProtocol) {
             self.presenter = presenter
             presenter.view = self
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
            imageListCell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "DownloadingImage")){[weak self] _ in
                guard let self = self else {return }
                imageListCell.cellImage.kf.indicatorType = .activity
                if let date = self.photos[indexPath.row].createdAt {
                    let dateString = self.dateFormatter.string(from: date)
                    imageListCell.dateLabel.text = "\(dateString)"
                    imageListCell.setIsLiked(self.photos[indexPath.row].isLiked)
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
    
    
//    private func photosObserver() {
//        InfoImageObserver = NotificationCenter.default.addObserver(
//            forName: ImagesListService.DidChangeNotification,
//            object: nil,
//            queue: .main) {
//                [weak self] _ in
//                guard let self = self else { return }
//                self.updateTableViewAnimated()
//            }
//    }
    
//    private func showAlert() {
//        let alert = UIAlertController(
//            title: "Ошибка",
//            message: "Не спамь лайками.",
//            preferredStyle: .alert)
//        let action = UIAlertAction(title: "Не буду!", style: .default)
//
//
//        alert.addAction(action)
//        present(alert, animated: true)
//    }
}

//MARK: ImageListCell Deleagete
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photosId: photo.id, isLiked: !photo.isLiked) {[weak self] result in
            guard let self = self else { return }
            switch result{
            case .success():
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.presenter?.showAlert(vc: self)
                return assertionFailure("like error: \(error)")
            }
        }
    }
    
    
}
