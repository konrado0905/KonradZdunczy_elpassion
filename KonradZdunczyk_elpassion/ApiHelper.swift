//
//  ApiHelper.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Alamofire
import ObjectMapper

class ApiHelper {
    class func searchUsers(withName name: String,
                           successHandler: @escaping (([User]) -> ()),
                           failureHandler: @escaping ((Error, DataResponse<Any>) -> ())) {
        Alamofire
            .request(GitHubRouter.searchUser(name: name))
            .validate(statusCode: 200..<300)
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { (response) in
                switch response.result {
                case .success(let json):
                    let users: [User]

                    if let searchResult = Mapper<SearchResult<User>>().map(JSONObject: json) {
                        users = searchResult.items ?? []
                    } else {
                        users = []
                    }

                    successHandler(users)
                case .failure(let error):
                    failureHandler(error, response)
                }
            }
    }

    class func searchRepos(withName name: String,
                           successHandler: @escaping (([Repository]) -> ()),
                           failureHandler: @escaping ((Error, DataResponse<Any>) -> ())) {
        Alamofire
            .request(GitHubRouter.searchRepo(name: name))
            .validate(statusCode: 200..<300)
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { (response) in
                switch response.result {
                case .success(let json):
                    let repos: [Repository]

                    if let searchResult = Mapper<SearchResult<Repository>>().map(JSONObject: json) {
                        repos = searchResult.items ?? []
                    } else {
                        repos = []
                    }

                    successHandler(repos)
                case .failure(let error):
                    failureHandler(error, response)
                }
            }
    }
}
