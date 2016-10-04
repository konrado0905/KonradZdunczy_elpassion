//
//  ApiHelper.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import Alamofire
import ObjectMapper

enum ApiHelper: ApiHelperProtocol {
    static func searchUsers(withName name: String,
                            successHandler: @escaping ([User]) -> (),
                            failureHandler: @escaping (NSError) -> ()) {
        Alamofire
            .request(GitHubRouter.searchUser(name: name))
            .validate(statusCode: 200..<300)
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { (response) in
                switch response.result {
                case .success(let json):
                    let users: [User]

                    if let searchResult = Mapper<SearchResult<User>>().map(JSONObject: json) {
                        users = searchResult.items ?? []
                    } else {
                        users = []
                    }

                    successHandler(users)
                case .failure:
                    failureHandler(getError(fromResponse: response))
                }
            }
    }

    static func searchRepos(withName name: String,
                            successHandler: @escaping ([Repository]) -> (),
                            failureHandler: @escaping (NSError) -> ()) {
        Alamofire
            .request(GitHubRouter.searchRepo(name: name))
            .validate(statusCode: 200..<300)
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { (response) in
                switch response.result {
                case .success(let json):
                    let repos: [Repository]

                    if let searchResult = Mapper<SearchResult<Repository>>().map(JSONObject: json) {
                        repos = searchResult.items ?? []
                    } else {
                        repos = []
                    }

                    successHandler(repos)
                case .failure:
                    failureHandler(getError(fromResponse: response))
                }
            }
    }

    static func starsNumber(ofUser user: User,
                            successHandler: @escaping (Int) -> (),
                            failureHandler: @escaping (NSError) -> ()) {
        let request = Alamofire.request(GitHubRouter.usersStars(user: user))
        totalObjectsNumber(withRequest: request, successHandler: successHandler, failureHandler: { (_, response) in
            failureHandler(getError(fromResponse: response))
        })
    }

    static func followersNumber(ofUser user: User,
                               successHandler: @escaping (Int) -> (),
                               failureHandler: @escaping (NSError) -> ()) {
        let request = Alamofire.request(GitHubRouter.usersFallowers(user: user))
        totalObjectsNumber(withRequest: request, successHandler: successHandler, failureHandler: { (_, response) in
            failureHandler(getError(fromResponse: response))
        })
    }

    private static func getError(fromResponse response: DataResponse<Any>) -> NSError {
        var message = "Request error"
        if let data = response.data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = jsonObject as? [String : String],
            let msg = jsonDict["message"] {
            message = msg
        }

        let domain = "RequestFailure"
        let statusCode = response.response?.statusCode ?? -1
        return NSError(domain: domain, code: statusCode, userInfo: [NSLocalizedDescriptionKey : message])
    }

    private static func getPageNumber(fromUrlString urlString: String) -> Int? {
        let urlComponents = NSURLComponents(string: urlString)
        if let pageNumberString = urlComponents?.queryItems?.filter({ $0.name == "page"}).first?.value {
            return Int(pageNumberString)
        }

        return nil
    }

    private static func getPagesInfo(fromResponse response: HTTPURLResponse?) -> (numberOfPages: Int, lastPageLink: URL)? {
        guard let response = response, let linksString = response.allHeaderFields["Link"] as? String else { return nil }
        guard let linksRegex = try? NSRegularExpression(pattern: "<.+?>", options: []) else { return nil }

        let results  = linksRegex.matches(in: linksString,
                                          options: [],
                                          range: NSRange(location: 0,
                                                         length: linksString.characters.count))
        let linksNSString = linksString as NSString
        let resultsArray = results.map {
            linksNSString
                .substring(with: $0.range)
                .replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
        }

        guard resultsArray.count == 2 else { return nil }

        if let lastPageUrlString = resultsArray.last,
            let lastPageUrl = URL(string: lastPageUrlString),
            let numberOfPages = getPageNumber(fromUrlString: lastPageUrlString) {
            return (numberOfPages, lastPageUrl)
        }

        return nil
    }

    private static func objectsNumberAtPage(withRequest request: DataRequest,
                                            successHandler: @escaping ((Int, DataResponse<Data>) -> ()),
                                            failureHandler: @escaping ((Error, DataResponse<Any>) -> ())) {
        func numberOfObjects(fromResponse response: DataResponse<Data>) -> Int {
            guard let jsonData = response.result.value,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
                let jsonArray = jsonObject as? [[String: Any]] else {
                    return 0
            }

            return jsonArray.count
        }

        request
            .validate(statusCode: 200..<300)
            .responseData(queue: DispatchQueue.global(qos: .background)) { (response) in
                switch response.result {
                case .success:
                    successHandler(numberOfObjects(fromResponse: response), response)
                default:
                    break
                }
            }
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { (response) in
                switch response.result {
                case .failure(let error):
                    failureHandler(error, response)
                default:
                    break
                }
        }
    }

    private static func totalObjectsNumber(withRequest request: DataRequest,
                                           successHandler: @escaping ((Int) -> ()),
                                           failureHandler: @escaping ((Error, DataResponse<Any>) -> ())) {
        objectsNumberAtPage(
            withRequest: request,
            successHandler: { (numberOfObjectsAtFirstPage, response) in
                if let pagesInfo = ApiHelper.getPagesInfo(fromResponse: response.response), pagesInfo.numberOfPages > 1 {
                    let multiplier = pagesInfo.numberOfPages - 1
                    let request = Alamofire.request(pagesInfo.lastPageLink,
                                                    method: .get,
                                                    parameters: nil,
                                                    encoding: URLEncoding.queryString,
                                                    headers: nil)

                    objectsNumberAtPage(
                        withRequest: request,
                        successHandler: { (numberOfObjectsAtLastPage, response) in
                            let numberOfObjectsTotal = numberOfObjectsAtFirstPage * multiplier + numberOfObjectsAtLastPage
                            successHandler(numberOfObjectsTotal)
                        }, failureHandler: failureHandler)
                } else {
                    successHandler(numberOfObjectsAtFirstPage)
                }
            }, failureHandler: failureHandler)
    }
}
