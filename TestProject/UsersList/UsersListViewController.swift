//
//  UsersListViewController.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import UIKit
import Combine
import SnapKit
import Core

final class UsersListViewController: UIViewController {
    
    typealias UserRow = UsersListViewModel.UserRow

    private let viewModel: UsersListViewModel
    private let tableView = UITableView()
    private let cellReuseIdentifier = String(describing: UsersListTableViewCell.self)
    private let refreshControl: UIRefreshControl = .init()

    private var disposeBag: Set<AnyCancellable> = .init()
    private var userRows: [UserRow] = []

    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: Bundle.main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupNavigationItem()
        setupTableView()
        setupRefreshControl()
        setupBindings()

        viewModel.fetchUsers()
    }

    private func setupBindings() {
        viewModel.userRowsPublisher.sink(receiveCompletion: { [weak self] completion in
            guard let self, case .failure(let error) = completion else { return }

            self.refreshControl.endRefreshing()
            self.handleError(error)
        }, receiveValue: { [weak self] userRows in
            guard let self else { return }

            self.userRows = userRows
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }).store(in: &disposeBag)
    }

    private func setupNavigationItem() {
        let clearStorageItem = UIBarButtonItem(
            title: NSLocalizedString("Clear storage", comment: ""),
            style: .plain,
            target: self,
            action: #selector(handleClearStorageButtonAction(_:))
        )
        let printStorageItem = UIBarButtonItem(
            title: NSLocalizedString("Print storage", comment: ""),
            style: .plain,
            target: self,
            action: #selector(handlePrintStorageButtonAction(_:))
        )

        navigationItem.leftBarButtonItem = clearStorageItem
        navigationItem.rightBarButtonItem = printStorageItem
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UsersListTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)

        tableView.addSubview(refreshControl)
    }

    private func handleError(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)

        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    @objc
    private func handlePrintStorageButtonAction(_ sender: UIBarButtonItem) {
        viewModel.printStorage()
    }
    
    @objc
    private func handleClearStorageButtonAction(_ sender: UIBarButtonItem) {
        viewModel.clearStorage()
    }

    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        viewModel.fetchUsers()
    }

}

extension UsersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? UsersListTableViewCell else {
            return .init()
        }
        
        let userRow = userRows[indexPath.row]
        cell.apply(username: userRow.username, linkDescription: userRow.linkDescription)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleRowSelection(at: indexPath)
    }

}
