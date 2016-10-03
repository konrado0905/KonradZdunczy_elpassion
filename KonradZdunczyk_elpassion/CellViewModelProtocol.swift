//
//  CellViewModelProtocol.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import UIKit

protocol CellViewModel {
    var id: Int { get }
    var title: String { get }
    var accessoryType: UITableViewCellAccessoryType { get }
}

extension CellViewModel {
    var accessoryType: UITableViewCellAccessoryType {
        return .none
    }
}
