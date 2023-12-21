//
//  UsersRepository.swift
//  Core
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import Combine

public final class UsersRepository {

    private let networkClient: NetworkClient
    private let storageKey: String = "usersRepositoryKey"

    private static let loggerPrefix: String = "Users Repository: "

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func fetchUsers() -> AnyPublisher<[User], Error> {
        let urlString = "https://api.github.com/users"

        Logger.verbose(Self.loggerPrefix + "Started executing request by url: \(urlString)")

        guard let url = URL(string: urlString) else { fatalError() }

        return networkClient
            .executeRequest(url: url, responseType: [User].self)
            .handleEvents(receiveOutput: { [weak self] users in
                self?.storeUsers(users)
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.success(Self.loggerPrefix + "Completed executing successfully.")
                    
                case .failure(let error):
                    Logger.error(Self.loggerPrefix + "Failed with error: \(error)")
                }
            }).eraseToAnyPublisher()
    }

    public func printStoredUsers() {
        let storedUsers = retrieveStoredUsers()

        guard !storedUsers.isEmpty else {
            Logger.warn(Self.loggerPrefix + "Stored users list is empty")

            return
        }

        storedUsers.enumerated().forEach { index, user in
            print("User \(index): nickname = `\(user.username)`, id = \(user.id)")
        }
    }

    public func clearStorage() {
        let storedUsers = retrieveStoredUsers()

        guard !storedUsers.isEmpty else {
            Logger.warn(Self.loggerPrefix + "Nothing to clear. Stored users list is empty.")

            return
        }

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: storageKey)
        defaults.synchronize()

        Logger.verbose(Self.loggerPrefix + "Successfully cleared \(storedUsers.count) users.")
    }

    private func storeUsers(_ users: [User]) {
        guard let encodedData = try? JSONEncoder().encode(users) else { return }

        UserDefaults.standard.set(encodedData, forKey: storageKey)
        Logger.verbose(Self.loggerPrefix + "Successfully stored \(users.count) users into a local storage.")
    }

    private func retrieveStoredUsers() -> [User] {
        guard let savedData = UserDefaults.standard.data(forKey: storageKey),
              let decodedUsers = try? JSONDecoder().decode([User].self, from: savedData) else {
            return []
        }

        return decodedUsers
    }

}
