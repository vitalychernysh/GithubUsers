//
//  UsersListViewModel.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import UIKit
import Combine
import Core

final class UsersListViewModel {
    
    struct UserRow {

        let username: String
        let linkDescription: String

    }

    var userRowsPublisher: AnyPublisher<[UserRow], Error> {
        model.usersPublisher.map { users in
            return users.map { UserRow(username: $0.username, linkDescription: $0.gitHubURL.absoluteString) }
        }.eraseToAnyPublisher()
    }

    private let model: UsersListModel

    init(model: UsersListModel) {
        self.model = model
    }

    func fetchUsers() {
        model.fetchUsers()
    }

    func handleRowSelection(at indexPath: IndexPath) {
        model.openDetailsForUser(at: indexPath.row)
    }

    func printStorage() {
        model.printStorage()
    }

    func clearStorage() {
        model.clearStorage()
    }

}
