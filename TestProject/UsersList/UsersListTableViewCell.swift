//
//  UsersListTableViewCell.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import UIKit
import SnapKit

final class UsersListTableViewCell: UITableViewCell {

    private let stackView = UIStackView()
    private let usernameLabel = UILabel()
    private let linkLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(username: String, linkDescription: String) {
        usernameLabel.text = username
        linkLabel.text = linkDescription
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8.0)
            $0.trailing.equalToSuperview().offset(-8.0)
            $0.top.equalToSuperview().offset(8.0)
            $0.bottom.equalToSuperview().offset(-8.0)
        }

        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(linkLabel)
    }

}
