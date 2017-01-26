//
//  SearchViewModel.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper

class SearchViewModel {
    enum Consts {
        static let ReposSectionNumber = 0
        static let UserSectionNumber = 1
    }

    public typealias ErrorHandlerType = ((NSError) -> ())

    private let query: Observable<String>
    private let errorHandler: ErrorHandlerType

    private let disposeBag = DisposeBag()

    private let repos = Variable<[Repository]>([])
    let rx_repoCellViewModels: Driver<[RepoCellViewModel]>
    var repossCount: Int {
        return repos.value.count
    }

    private let users = Variable<[User]>([])
    let rx_userCellViewModels: Driver<[UserCellViewModel]>
    var usersCount: Int {
        return users.value.count
    }

    private let apiHelperType: ApiHelperProtocol.Type

    init(withQueryOnservable queryObservable: Observable<String>, apiHelperType: ApiHelperProtocol.Type, errorHandler: @escaping ErrorHandlerType) {
        self.query = queryObservable
        self.errorHandler = errorHandler
        self.apiHelperType = apiHelperType

        rx_repoCellViewModels = repos
            .asObservable()
            .map {
                return $0.map({ RepoCellViewModel(repo: $0) })
            }
            .asDriver(onErrorJustReturn: [])

        rx_userCellViewModels = users
            .asObservable()
            .map {
                return $0.map({ UserCellViewModel(user: $0) })
            }
            .asDriver(onErrorJustReturn: [])

        query
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] (queryText) in
                guard queryText.characters.count > 0 else {
                    self.repos.value = []
                    self.users.value = []

                    return
                }

                apiHelperType.searchUsers(withName: queryText, successHandler: { (users) in
                    self.users.value = users.sorted { $0.id < $1.id }
                }, failureHandler: { (error) in
                    self.errorHandler(error)
                })

                apiHelperType.searchRepos(withName: queryText, successHandler: { (repos) in
                    self.repos.value = repos.sorted { $0.id < $1.id }
                }, failureHandler: { (error) in
                    self.errorHandler(error)
                })
            })
            .addDisposableTo(disposeBag)
    }

    func getCellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModel? {
        switch indexPath.section {
        case Consts.ReposSectionNumber:
            if indexPath.row < repossCount {
                let repo = repos.value[indexPath.row]
                return RepoCellViewModel(repo: repo)
            }
        case Consts.UserSectionNumber:
            if indexPath.row < usersCount {
                let user = users.value[indexPath.row]
                return UserCellViewModel(user: user)
            }
        default:
            break
        }

        return nil
    }

    func getUserDetailViewModel(forUserId userId: Int) -> UserDetailViewModel? {
        guard let user = users.value.filter({ $0.id == userId }).first else { return nil }

        return UserDetailViewModel(user: user, apiHelperType: apiHelperType)
    }
}
