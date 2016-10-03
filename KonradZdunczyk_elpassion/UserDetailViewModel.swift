//
//  UserDetailViewModel.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import AlamofireImage

class UserDetailViewModel {
    let rx_starsText: Driver<String>
    let rx_followersText: Driver<String>
    let rx_userName: Driver<String>
    let rx_avatar: Driver<UIImage?>

    private let user: User
    private let downloader = ImageDownloader()

    private let starsNumber = Variable<Int>(0)
    private let followersNumber = Variable<Int>(0)
    private let avatar = Variable<UIImage?>(nil)

    init(user: User) {
        self.user = user

        rx_userName = Observable
            .just(user.login)
            .asDriver(onErrorJustReturn: "")

        rx_avatar = avatar
            .asDriver()

        rx_starsText = starsNumber
            .asObservable()
            .map({ return "Stars: \($0)" })
            .asDriver(onErrorJustReturn: "Stars: 0")

        rx_followersText = followersNumber
            .asObservable()
            .map({ return "Followers: \($0)" })
            .asDriver(onErrorJustReturn: "Followers: 0")

        if let avatarUrl = user.avatar_url {
            let urlRequest = URLRequest(url: avatarUrl)

            downloader.download(urlRequest) { [weak self] response in
                if let image = response.result.value {
                    self?.avatar.value = image
                }
            }
        }

        ApiHelper.starsNumber(
            ofUser: user,
            successHandler: { [weak self] (starsNumber) in
                self?.starsNumber.value = starsNumber
            }, failureHandler: { [weak self] (error, respond) in
                self?.starsNumber.value = 0
            })

        ApiHelper.followersNumber(
            ofUser: user,
            successHandler: { [weak self] (fallowersNumber) in
                self?.followersNumber.value = fallowersNumber
            }, failureHandler: { [weak self] (error, respond) in
                self?.followersNumber.value = 0
            })
    }
}
