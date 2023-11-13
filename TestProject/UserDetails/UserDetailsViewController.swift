//
//  UserDetailsViewController.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import UIKit
import Combine
import SnapKit
import Core

final class UserDetailsViewController: UIViewController {

    private let viewModel: UserDetailsViewModel
    private let stackView = UIStackView()
    private let usernameLabel = UILabel()
    private let linkButton = UIButton()
    private let avatarImageView = UIImageView()

    init(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: Bundle.main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        setupAvatarImageView()
        setupStackView()
        setupUsernameLabel()
        setupLinkButton()
    }

    private func setupAvatarImageView() {
        let avatarSide: CGFloat = 200.0

        avatarImageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarSide / 2.0

        viewModel.loadUserAvatar { [weak self] image in
            self?.avatarImageView.image = image
        }

        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(avatarSide)
            $0.centerY.equalToSuperview().multipliedBy(0.65)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(32.0)
            $0.leading.equalToSuperview().offset(24.0)
            $0.trailing.equalToSuperview().offset(-24.0)
            $0.bottom.lessThanOrEqualToSuperview().offset(-24.0)
        }
    }

    private func setupUsernameLabel() {
        usernameLabel.text = viewModel.username
        usernameLabel.font = .boldSystemFont(ofSize: 24.0)
        usernameLabel.textAlignment = .center

        stackView.addArrangedSubview(usernameLabel)
    }

    private func setupLinkButton() {
        linkButton.setTitle(viewModel.gitHubLink, for: .normal)
        linkButton.setTitleColor(.blue, for: .normal)
        linkButton.titleLabel?.textAlignment = .center
        linkButton.titleLabel?.numberOfLines = 0
        linkButton.addTarget(self, action: #selector(handleLinkButtonAction(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(linkButton)
    }

    @objc
    private func handleLinkButtonAction(_ sender: UIButton) {
        viewModel.openGitHubPreview()
    }

}
