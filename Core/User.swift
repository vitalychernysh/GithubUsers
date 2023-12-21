//
//  User.swift
//  Core
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

public final class User: Codable {

    public let id: Int
    public let username: String
    public let gitHubURL: URL
    public let avatarURL: URL

    enum CodingKeys: String, CodingKey {

        case id
        case username = "login"
        case gitHubURL = "html_url"
        case avatarURL = "avatar_url"

    }

}
