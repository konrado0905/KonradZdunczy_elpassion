//
//  UserDetailViewController.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailViewController: UIViewController {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStars: UILabel!
    @IBOutlet weak var userFollowers: UILabel!

    var userDetailViewModel: UserDetailViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRx()
    }

    private func setupRx() {
        guard let userDetailViewModel = userDetailViewModel else { return }

        userDetailViewModel
            .rx_avatar
            .drive(userAvatar.rx.image)
            .addDisposableTo(disposeBag)

        userDetailViewModel
            .rx_userName
            .drive(onNext: { [unowned self] (text) in
                self.userName.text = text
            })
            .addDisposableTo(disposeBag)

        userDetailViewModel
            .rx_starsText
            .drive(onNext: { [unowned self] (text) in
                self.userStars.text = text
            })
            .addDisposableTo(disposeBag)

        userDetailViewModel
            .rx_followersText
            .drive(onNext: { [unowned self] (text) in
                self.userFollowers.text = text
            })
            .addDisposableTo(disposeBag)
    }
}
