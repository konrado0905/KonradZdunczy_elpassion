//
//  RepoCellViewModel.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation

struct RepoCellViewModel: CellViewModel {
    let id: Int
    let title: String

    init(repo: Repository) {
        id = repo.id
        title = repo.fullName
    }
}
