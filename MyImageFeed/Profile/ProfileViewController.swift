//
//  ProfileViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 04.03.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private var loginLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    private let profileService = ProfileService.shared
    private let token = OAuth2TokenStorage().token
    private var profileImageServiceObserver: NSObjectProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupAvatarImageView()
        setupNameLabel()
        setupLoginLabel()
        setupDescriptionLabel()
        setupLogoutButton()
        updateProfile()
        updateAvatar()
        addObserverProfileImageService()
        
    }
    
    private func addObserverProfileImageService() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
    }
    
    private func updateAvatar() {
            guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let url = URL(string: profileImageURL)
            else { return }
        avatarImageView.kf.setImage(with: url)
        }
    
    private func updateProfile() {
        guard let profile = profileService.profile else {return }
        self.nameLabel.text = profile.fullname
        self.loginLabel.text = profile.loginname
        self.descriptionLabel.text = profile.bio
    }
    
    
    private func addViews() {
        let listViews = [avatarImageView, nameLabel, loginLabel, descriptionLabel, logoutButton]
        listViews.forEach{self.view.setupView($0) }
    }
    
    private func setupAvatarImageView() {
        avatarImageView.image = Resourses.Images.Profile.mockPhoto
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 32

        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.text = Resourses.Strings.Profile.name
        nameLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
    
    private func setupLoginLabel() {
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.text = Resourses.Strings.Profile.nickname
        loginLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.text = Resourses.Strings.Profile.description
        descriptionLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: logoutButton.rightAnchor)
        ])
    }
    
    private func setupLogoutButton() {
        logoutButton.setImage(Resourses.Images.Profile.logOut, for: .normal)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
        ])
    }
}

