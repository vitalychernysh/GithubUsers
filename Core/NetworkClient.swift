//
//  NetworkClient.swift
//  Core
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import Combine

public final class NetworkClient {
    
    public init() {}

    func executeRequest<T: Decodable>(url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: responseType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
