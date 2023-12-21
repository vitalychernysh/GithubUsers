//
//  UsersListModel.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import Core
import Combine

protocol UsersListDelegate: AnyObject {

    func usersList(_ model: UsersListModel, didRequestUserDetails user: User)

}

final class UsersListModel {

    weak var delegate: UsersListDelegate?

    var usersPublisher: AnyPublisher<[User], Error> {
        usersSubject.eraseToAnyPublisher()
    }

    private let usersSubject: CurrentValueSubject<[User], Error> = .init([])
    private let usersRepository: UsersRepository
    
    private var disposeBag: Set<AnyCancellable> = .init()

    init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }

    func fetchUsers() {
        usersRepository.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break

                case .failure:
                    self?.usersSubject.send(completion: completion)
                }
            } receiveValue: { [weak self] users in
                self?.usersSubject.send(users)
            }.store(in: &disposeBag)
    }

    func openDetailsForUser(at index: Int) {
        delegate?.usersList(self, didRequestUserDetails: usersSubject.value[index])
    }

    func printStorage() {
        usersRepository.printStoredUsers()
    }

    func clearStorage() {
        usersRepository.clearStorage()
    }

}
