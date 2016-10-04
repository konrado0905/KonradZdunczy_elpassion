//
//  FakeApiHelper.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 04/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation

enum FakeSuccessApiHelper: ApiHelperProtocol {
    static func searchUsers(withName name: String,
                            successHandler: @escaping ([User]) -> (),
                            failureHandler: @escaping (NSError) -> ()) {
        let users = [User(id: 3, login: "User_3", avatar_url: nil),
                     User(id: 2, login: "User_2", avatar_url: nil),
                     User(id: 1, login: "User_1", avatar_url: nil),
                     User(id: 4, login: "User_4", avatar_url: nil)]

        successHandler(users)
    }

    static func searchRepos(withName name: String,
                            successHandler: @escaping ([Repository]) -> (),
                            failureHandler: @escaping (NSError) -> ()){
        let repos = [Repository(id: 2, fullName: "Repo_2"),
                     Repository(id: 3, fullName: "Repo_3"),
                     Repository(id: 1, fullName: "Repo_1")]

        successHandler(repos)
    }

    static func starsNumber(ofUser user: User,
                            successHandler: @escaping ((Int) -> ()),
                            failureHandler: @escaping (NSError) -> ()) {
        successHandler(7)
    }

    static func followersNumber(ofUser user: User,
                                successHandler: @escaping ((Int) -> ()),
                                failureHandler: @escaping (NSError) -> ()) {
        successHandler(10)
    }
}

enum FakeFailureApiHelper: ApiHelperProtocol {
    static func searchUsers(withName name: String,
                            successHandler: @escaping ([User]) -> (),
                            failureHandler: @escaping (NSError) -> ()) {
        failureHandler(NSError())
    }

    static func searchRepos(withName name: String,
                            successHandler: @escaping ([Repository]) -> (),
                            failureHandler: @escaping (NSError) -> ()){
        failureHandler(NSError())
    }

    static func starsNumber(ofUser user: User,
                            successHandler: @escaping ((Int) -> ()),
                            failureHandler: @escaping (NSError) -> ()) {


        failureHandler(NSError())
    }

    static func followersNumber(ofUser user: User,
                                successHandler: @escaping ((Int) -> ()),
                                failureHandler: @escaping (NSError) -> ()) {
        failureHandler(NSError())
    }
}
