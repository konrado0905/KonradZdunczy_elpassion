//
//  ApiHelperProtocol.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 04/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation

protocol ApiHelperProtocol {
    static func searchUsers(withName name: String,
                            successHandler: @escaping ([User]) -> (),
                            failureHandler: @escaping (NSError) -> ())

    static func searchRepos(withName name: String,
                            successHandler: @escaping ([Repository]) -> (),
                            failureHandler: @escaping (NSError) -> ())

    static func starsNumber(ofUser user: User,
                            successHandler: @escaping (Int) -> (),
                            failureHandler: @escaping (NSError) -> ())

    static func followersNumber(ofUser user: User,
                                successHandler: @escaping (Int) -> (),
                                failureHandler: @escaping (NSError) -> ())
}
