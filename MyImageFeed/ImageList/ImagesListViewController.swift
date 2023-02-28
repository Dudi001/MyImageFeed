//
//  ViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 18.02.2023.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var ImageList: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) { }
}
