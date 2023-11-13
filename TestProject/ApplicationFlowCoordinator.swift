//
//  ApplicationFlowCoordinator.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import Core
import UIKit

final class ApplicationFlowCoordinator {
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }

    func execute() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        navigationController.viewControllers = [buildUsersListViewController()]
    }

    private func buildUsersListViewController() -> UIViewController {
        let usersRepository = UsersRepository(networkClient: .init())
        let model = UsersListModel(usersRepository: usersRepository)
        let viewModel = UsersListViewModel(model: model)
        let viewController = UsersListViewController(viewModel: viewModel)

        model.delegate = self
        viewController.title = NSLocalizedString("Users", comment: "")

        return viewController
    }

    private func presentUserDetails(of user: User) {
        let model = UserDetailsModel(user: user)
        let viewModel = UserDetailsViewModel(model: model)
        let viewController = UserDetailsViewController(viewModel: viewModel)

        model.delegate = self
        viewController.title = user.username
        navigationController.pushViewController(viewController, animated: true)
    }

    private func presentWebView(url: URL) {
        let viewController = WebViewController(url: url)
        navigationController.present(viewController, animated: true)
    }

}

extension ApplicationFlowCoordinator: UsersListDelegate {

    func usersList(_ model: UsersListModel, didRequestUserDetails user: User) {
        presentUserDetails(of: user)
    }

}

extension ApplicationFlowCoordinator: UserDetailsDelegate {

    func userDetails(_ model: UserDetailsModel, didRequestWebPreview url: URL) {
        presentWebView(url: url)
    }

}
