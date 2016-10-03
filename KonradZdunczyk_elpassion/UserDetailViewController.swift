//
//  UserDetailViewController.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStars: UILabel!
    @IBOutlet weak var userFollowers: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
