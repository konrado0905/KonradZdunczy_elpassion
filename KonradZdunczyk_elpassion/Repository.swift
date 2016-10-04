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
    private(set) var fullName: String!

    init?(map: Map) { }

    init(id: Int, fullName: String) {
        self.id = id
        self.fullName = fullName
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        fullName <- map["full_name"]
    }
}
