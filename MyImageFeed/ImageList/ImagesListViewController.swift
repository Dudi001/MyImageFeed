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
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController, ImagelistViewControllerProtocol {
    var presenter: ImageListViewPresenterProtocol?
    

    @IBOutlet private var tableView: UITableView!
    
//    var photos: [Photo] = []
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
        presenter?.updateTableView()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            guard let imageName = presenter?.photos[indexPath.row].largeImageURL else { return  }
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
        return presenter?.photos.count ?? 0
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
        guard let cellPhotoURL = presenter?.photos[indexPath.row].thumbImageURL else {
            return UITableViewCell(style: .default, reuseIdentifier: "")
        }
        
        if let url = URL(string: cellPhotoURL) {
            let placeholderImage = UIImage(named: "DownloadingImage")
            imageListCell.cellImage.kf.setImage(with: url, placeholder: placeholderImage){[weak self] _ in
                guard let self = self else {return }
                imageListCell.cellImage.kf.indicatorType = .activity
                if let date = self.presenter?.photos[indexPath.row].createdAt {
                    let dateString = self.dateFormatter.string(from: date)
                    imageListCell.dateLabel.text = "\(dateString)"
                    if let presenter = self.presenter {
                        imageListCell.setIsLiked(presenter.photos[indexPath.row].isLiked)
                    }
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
        guard let presenter = presenter else { return 100 }
        
        let image = presenter.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        if indexPath.row + 1 == presenter.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}


extension ImagesListViewController {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            var indexPaths: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
}

//MARK: ImageListCell Deleagete
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
                let presenter = presenter
        else { return }
        let photo = presenter.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photosId: photo.id, isLiked: !photo.isLiked) {[weak self] result in
            guard let self = self else { return }
            switch result{
            case .success:
                presenter.photos = self.imagesListService.photos
                cell.setIsLiked(presenter.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                presenter.showAlert(vc: self)
                return assertionFailure("like error: \(error)")
            }
        }
    }
    
    
}
