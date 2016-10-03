//
//  User.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Mappable {
    private(set) var id: Int!
    private(set) var login: String!
    private(set) var avatar_url: URL!

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        login <- map["login"]
        avatar_url <- (map["avatar_url"], URLTransform())
    }
}
