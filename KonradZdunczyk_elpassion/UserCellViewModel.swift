//
//  UserCellViewModel.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import UIKit

struct UserCellViewModel: CellViewModel {
    let id: Int
    let title: String
    var accessoryType: UITableViewCellAccessoryType = .disclosureIndicator

    init(user: User) {
        id = user.id
        title = user.login
    }
}
