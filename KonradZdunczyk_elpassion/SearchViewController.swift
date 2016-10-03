//
//  SearchViewController.swift
//  KonradZdunczyk_elpassion
//
//  Created by Konrad Zdunczyk on 03/10/16.
//  Copyright © 2016 Konrad Zdunczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UserRepoCell.self, forCellReuseIdentifier: "cell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.keyboardDismissMode = .onDrag
        }
    }

    private let disposeBag = DisposeBag()
    fileprivate var searchViewModel: SearchViewModel!

    var rx_searchBarText: Observable<String> {
        return searchBar.rx
            .text
            .throttle(1.0, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        setupRx()
    }

    func setupRx() {
        searchViewModel = SearchViewModel(withQueryOnservable: rx_searchBarText, errorHandler: showAlert)

        searchBar.rx
            .searchButtonClicked
            .bindNext { [unowned self] in
                self.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)

        searchViewModel
            .rx_repoCellViewModels
            .drive(onNext: { [unowned self] (repos) in
                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)

        searchViewModel
            .rx_userCellViewModels
            .drive(onNext: { [unowned self] (users) in
                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }

    private func showAlert(onError error: NSError) {
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }

            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let alertOkAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alertController.addAction(alertOkAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
// MARK: UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SearchViewModel.Consts.ReposSectionNumber:
            return searchViewModel.repossCount
        case SearchViewModel.Consts.UserSectionNumber:
            return searchViewModel.usersCount
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserRepoCell

        if let viewModel = searchViewModel.getCellViewModel(forIndexPath: indexPath) {
            cell.setup(withCellModelView: viewModel)
        }

        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SearchViewModel.Consts.ReposSectionNumber:
            return "Repos"
        case SearchViewModel.Consts.UserSectionNumber:
            return "Users"
        default:
            return nil
        }
    }
}
