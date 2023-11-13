//
//  UserDetailsViewModel.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import UIKit
import Combine
import Core
import Kingfisher

final class UserDetailsViewModel {

    var user: User { model.user }

    private let model: UserDetailsModel
    
    init(model: UserDetailsModel) {
        self.model = model
    }

    func loadUserAvatar(completion: @escaping (UIImage?) -> Void) {
        KingfisherManager.shared.retrieveImage(
            with: user.avatarURL,
            options: nil,
            progressBlock: nil
        ) { result in
            switch result {
            case .success(let subresult):
                completion(subresult.image)

            case .failure:
                completion(nil)
            }
        }
    }

    func openGitHubPreview() {
        model.openGitHubPreview()
    }

}
