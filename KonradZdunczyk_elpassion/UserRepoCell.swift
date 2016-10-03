//
//  UserRepoCell.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import UIKit

class UserRepoCell: UITableViewCell {
    private(set) var cellViewModel: CellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        cellViewModel = nil
        accessoryType = .none
    }

    func setup(withCellModelView cellViewModel: CellViewModel) {
        self.cellViewModel = cellViewModel
        textLabel?.text = cellViewModel.title
        accessoryType = cellViewModel.accessoryType
    }
}
