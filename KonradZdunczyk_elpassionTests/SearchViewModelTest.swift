//
//  SearchViewModelTest.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 04/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift

class SearchViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var searchVM: SearchViewModel!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()

        disposeBag = nil
        searchVM = nil
    }

    func testUserCellViewModels_OnEmptyQuery() {
        let observable = Observable<String>
            .just("")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        searchVM
            .rx_userCellViewModels
            .drive(onNext: { (users) in
                XCTAssertEqual(users.count, 0)
            })
            .addDisposableTo(disposeBag)
    }

    func testUserCellViewModels_OnNotEmptyQuery() {
        let observable = Observable<String>
            .just("User")


        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        searchVM
            .rx_userCellViewModels
            .drive(onNext: { (users) in
                XCTAssertEqual(users.count, 4)
            })
            .addDisposableTo(disposeBag)
    }

    func testUserCellViewModels_SortedAscendingById() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        searchVM
            .rx_userCellViewModels
            .drive(onNext: { (users) in
                XCTAssertEqual(users.count, 4)
                XCTAssertEqual(users[0].id, 1)
                XCTAssertEqual(users[1].id, 2)
                XCTAssertEqual(users[2].id, 3)
                XCTAssertEqual(users[3].id, 4)
            })
            .addDisposableTo(disposeBag)
    }

    func testRepoCellViewModels_OnEmptyQuery() {
        let observable = Observable<String>
            .just("")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        searchVM
            .rx_repoCellViewModels
            .drive(onNext: { (repos) in
                XCTAssertEqual(repos.count, 0)
            })
            .addDisposableTo(disposeBag)
    }

    func testRepoCellViewModels_OnNotEmptyQuery() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        searchVM
            .rx_repoCellViewModels
            .drive(onNext: { (repos) in
                XCTAssertEqual(repos.count, 3)
            })
            .addDisposableTo(disposeBag)
    }

    func testRepoCellViewModels_SortedAscendingById() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        searchVM
            .rx_repoCellViewModels
            .drive(onNext: { (repos) in
                XCTAssertEqual(repos.count, 3)
                XCTAssertEqual(repos[0].id, 1)
                XCTAssertEqual(repos[1].id, 2)
                XCTAssertEqual(repos[2].id, 3)
            })
            .addDisposableTo(disposeBag)
    }

    func testGetCellViewModel_IsRepoCellViewModel() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        let indexPath = IndexPath(row: 0, section: SearchViewModel.Consts.ReposSectionNumber)
        let vm = searchVM.getCellViewModel(forIndexPath: indexPath)
        XCTAssertTrue(vm is RepoCellViewModel)
    }

    func testGetCellViewModel_IsUserCellViewModel() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        let indexPath = IndexPath(row: 0, section: SearchViewModel.Consts.UserSectionNumber)
        let vm = searchVM.getCellViewModel(forIndexPath: indexPath)
        XCTAssertTrue(vm is UserCellViewModel)
    }

    func testGetCellViewModel_IsNil() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        let indexPath = IndexPath(row: 0, section: 69)
        let vm = searchVM.getCellViewModel(forIndexPath: indexPath)
        XCTAssertNil(vm)
    }

    func testGetUserDetailViewModel_UserExist() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeSuccessApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        let vm = searchVM.getUserDetailViewModel(forUserId: 1)
        XCTAssertNotNil(vm)

        vm!.rx_userName
            .drive(onNext: { (text) in
                XCTAssertEqual(text, "User_1")
            })
            .addDisposableTo(disposeBag)
    }

    func testGetUserDetailViewModel_UserDoesntExist() {
        let observable = Observable<String>
            .just("User")

        searchVM = SearchViewModel(withQueryOnservable: observable, apiHelperType: FakeFailureApiHelper.self, errorHandler: { (_) in })

        Thread.sleep(forTimeInterval: 0.5)

        let vm = searchVM.getUserDetailViewModel(forUserId: 1)
        XCTAssertNil(vm)
    }
}
