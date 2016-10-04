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

extension ApiHelperProtocol {
    static func searchUsers(withName name: String,
                            successHandler: @escaping (([User]) -> ()),
                            failureHandler: @escaping (NSError) -> ()) { }

    static func searchRepos(withName name: String,
                            successHandler: @escaping (([Repository]) -> ()),
                            failureHandler: @escaping (NSError) -> ()) { }

    static func starsNumber(ofUser user: User,
                            successHandler: @escaping ((Int) -> ()),
                            failureHandler: @escaping (NSError) -> ()) { }

    static func followersNumber(ofUser user: User,
                                successHandler: @escaping ((Int) -> ()),
                                failureHandler: @escaping (NSError) -> ()) { }
}

enum FakeSuccessApiHelper: ApiHelperProtocol {
    static func starsNumber(ofUser user: User,
                            successHandler: @escaping ((Int) -> ()),
                            failureHandler: @escaping (NSError) -> ()) {
        successHandler(7)
    }

    static func followersNumber(ofUser user: User,
                                successHandler: @escaping ((Int) -> ()),
                                failureHandler: @escaping (NSError) -> ()) {
        successHandler(10)
    }
}

enum FakeFailureApiHelper: ApiHelperProtocol {
    static func starsNumber(ofUser user: User,
                            successHandler: @escaping ((Int) -> ()),
                            failureHandler: @escaping (NSError) -> ()) {


        failureHandler(NSError())
    }

    static func followersNumber(ofUser user: User,
                                successHandler: @escaping ((Int) -> ()),
                                failureHandler: @escaping (NSError) -> ()) {
        failureHandler(NSError())
    }
}

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

    func testUserNameText() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeSuccessApiHelper.self)

        userDetailVM
            .rx_userName
            .drive(onNext: { (text) in
                XCTAssertEqual(text, user.login)
            })
            .addDisposableTo(disposeBag)
    }

    func testFollowersTextOnSuccess() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeSuccessApiHelper.self)

        userDetailVM
            .rx_followersText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Followers: 10")
            })
            .addDisposableTo(disposeBag)
    }

    func testFollowersTextOnFailure() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeFailureApiHelper.self)

        userDetailVM
            .rx_followersText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Followers: 0")
            })
            .addDisposableTo(disposeBag)
    }

    func testStarsTextOnSuccess() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeSuccessApiHelper.self)

        userDetailVM
            .rx_starsText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Stars: 7")
            })
            .addDisposableTo(disposeBag)
    }

    func testStarsTextOnFailure() {
        let user = User(id: 1, login: "User", avatar_url: nil)
        userDetailVM = UserDetailViewModel(user: user, apiHelperType: FakeFailureApiHelper.self)

        userDetailVM
            .rx_starsText
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "Stars: 0")
            })
            .addDisposableTo(disposeBag)
    }
}
