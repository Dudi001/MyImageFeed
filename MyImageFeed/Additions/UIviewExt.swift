//
//  UIviewExt.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 16.03.2023.
//

import UIKit

extension UIView {
    func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}

