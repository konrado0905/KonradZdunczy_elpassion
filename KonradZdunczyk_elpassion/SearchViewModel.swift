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

    init(withQueryOnservable queryObservable: Observable<String>, errorHandler: @escaping ErrorHandlerType) {
        self.query = queryObservable
        self.errorHandler = errorHandler

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
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .background))
            .subscribe { [unowned self] (queryText) in
                guard let queryText = queryText.element, queryText.characters.count > 0 else {
                    self.repos.value = []
                    self.users.value = []

                    return
                }

                ApiHelper.searchUsers(withName: queryText, successHandler: { (users) in
                    self.users.value = users.sorted { $0.id < $1.id }
                }, failureHandler: { (error, response) in
                    self.requestErrorHandler(response: response)
                })

                ApiHelper.searchRepos(withName: queryText, successHandler: { (repos) in
                    self.repos.value = repos.sorted { $0.id < $1.id }
                }, failureHandler: { (error, response) in
                    self.requestErrorHandler(response: response)
                })
            }
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

    private func requestErrorHandler(response: DataResponse<Any>) {
        var message = "Request error"
        if let data = response.data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = jsonObject as? [String : String],
            let msg = jsonDict["message"] {
            message = msg
        }

        let domain = "RequestFailure"
        let statusCode = response.response?.statusCode ?? -1
        let error = NSError(domain: domain, code: statusCode, userInfo: [NSLocalizedDescriptionKey : message])
        
        self.errorHandler(error)
    }
}
