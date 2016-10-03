//
//  GitHubRouter.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import Alamofire

enum GitHubRouter: URLRequestConvertible {
    static let baseURLString = "https://api.github.com"

    case searchUser(name: String)
    case searchRepo(name: String)
    case usersStars(user: User)
    case usersFallowers(user: User)

    var method: HTTPMethod {
        switch self {
        case .searchUser:
            return .get
        case .searchRepo:
            return .get
        case .usersStars:
            return .get
        case .usersFallowers:
            return .get
        }
    }

    var path: String {
        switch self {
        case .searchUser:
            return "/search/users"
        case .searchRepo:
            return "/search/repositories"
        case .usersStars(let user):
            return "/users/\(user.login!)/starred"
        case .usersFallowers(let user):
            return "/users/\(user.login!)/followers"
        }
    }

    var parameters: [String : Any] {
        // I know. Very bad practice. Only for test purpose
        var parameters = ["client_id" : "fe5a84cd515ce65c584e",
                          "client_secret" : "73620973cf593bd464b5f439947526c275eea635"]

        switch self {
        case .searchUser(let name):
            parameters["q"] = name
        case .searchRepo(let name):
            parameters["q"] = name
        default:
            break
        }

        return parameters
    }

    func asURLRequest() throws -> URLRequest {
        let url = try GitHubRouter.baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
}
