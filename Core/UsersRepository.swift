//
//  UsersRepository.swift
//  Core
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import Combine

public final class UsersRepository {

    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func fetchUsers() -> AnyPublisher<[User], Error> {
        guard let url = URL(string: "https://api.github.com/users") else { fatalError() }

        return networkClient.executeRequest(url: url, responseType: [User].self)
    }

}
