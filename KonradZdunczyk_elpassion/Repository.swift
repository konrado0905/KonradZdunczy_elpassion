//
//  Repository.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import ObjectMapper

struct Repository: Mappable {
    private(set) var id: Int!
    private(set) var language: String!
    private(set) var name: String!
    private(set) var url: URL!
    private(set) var fullName: String!

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        language <- map["language"]
        url <- (map["url"], URLTransform())
        name <- map["name"]
        fullName <- map["full_name"]
    }
}
