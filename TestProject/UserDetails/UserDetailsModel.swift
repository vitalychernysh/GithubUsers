//
//  UserDetailsModel.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import Core

protocol UserDetailsDelegate: AnyObject {

    func userDetails(_ model: UserDetailsModel, didRequestWebPreview url: URL)

}

final class UserDetailsModel {
    
    let user: User
    
    weak var delegate: UserDetailsDelegate?

    init(user: User) {
        self.user = user
    }

    func openGitHubPreview() {
        delegate?.userDetails(self, didRequestWebPreview: user.gitHubURL)
    }

}
