//
//  UserDetailViewModelTest.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 04/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift

class UserDetailViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var userDetailVM: UserDetailViewModel!
    
    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()

        disposeBag = nil
        userDetailVM = nil
    }

    func testUserName_TextValue() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeSuccessApiHelper.self)

        userDetailVM
            .rx_userName
            .drive(onNext: { (text) in
                XCTAssertEqual(text, user.login)
            })
            .addDisposableTo(disposeBag)
    }

    func testFollowersText_ValueOnSuccess() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeSuccessApiHelper.self)

        Thread.sleep(forTimeInterval: 0.5)

        userDetailVM
            .rx_followersText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Followers: 10")
            })
            .addDisposableTo(disposeBag)
    }

    func testFollowersText_ValueOnFailure() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeFailureApiHelper.self)

        Thread.sleep(forTimeInterval: 0.5)

        userDetailVM
            .rx_followersText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Followers: 0")
            })
            .addDisposableTo(disposeBag)
    }

    func testStarsText_ValueOnSuccess() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeSuccessApiHelper.self)

        Thread.sleep(forTimeInterval: 0.5)

        userDetailVM
            .rx_starsText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Stars: 7")
            })
            .addDisposableTo(disposeBag)
    }

    func testStarsText_ValueOnFailure() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeFailureApiHelper.self)

        Thread.sleep(forTimeInterval: 0.5)

        userDetailVM
            .rx_starsText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Stars: 0")
            })
            .addDisposableTo(disposeBag)
    }
}
