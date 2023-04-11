//
//  MemberListViewController.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import UIKit

protocol MemberListViewControllerLogic: AnyObject {
    func loading(isLoading: Bool)
    func selectedHouse(houseName: String)
    func fetchMembers(viewModel: MemberListModels.Fetch.ViewModel)
}

class MemberListViewController: UIViewController {
    
    var interactor: MemberListInteractorLogic?
    var members: [MemberViewModel] = []
    var membersAlive: Int = 0
    let refreshControl = UIRefreshControl()
    var queueMain: Dispatching
    
    lazy var memberTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(CardMemberView.self, forCellReuseIdentifier: "CardMemberReusableView")
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        refreshControl.alpha = 0
        table.addSubview(refreshControl)
        return table
    }()
    
    lazy var loading: LoadingUIActivityIndicatior = {
        let activityindicator = LoadingUIActivityIndicatior()
        return activityindicator
    }()
    
    lazy var cardFooter: CardMemberFooter = {
        let footer = CardMemberFooter()
        return footer
    }()
    
    init(queueMain: Dispatching = DispatchQueue.main) {
        self.queueMain = queueMain
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, deprecated, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .white
        self.view.addSubview(memberTable)
        adjustConstraint()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loading(isLoading: true)
        interactor?.selectedHouse()
        interactor?.fetchMembers()
    }
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
    
    private func adjustConstraint() {
        NSLayoutConstraint.activate([
            memberTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            memberTable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            memberTable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            memberTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func adjustLayout() {
        let backButton = UIBarButtonItem()
        backButton.title = "Casas"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func addLoading() {
        queueMain.async { [weak self] in
            guard let self = self else { return }
            self.loading.startAnimating()
            self.view.addSubview(self.loading)
            NSLayoutConstraint.activate([
                self.loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        }
    }
    
    private func removeLoading() {
        queueMain.async { [weak self] in
            self?.loading.stopAnimating()
            self?.loading.removeFromSuperview()
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func pullToRefresh(_ sender: AnyObject) {
        interactor?.loading(isLoading: true)
        interactor?.refreshMembers()
        refreshControl.endRefreshing()
    }
}

extension MemberListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = memberTable.dequeueReusableCell(withIdentifier: "CardMemberReusableView") as? CardMemberView
        else { return UITableViewCell() }
        
        let viewModel = members[indexPath.row]
        cell.updateData(member: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if members.count > 0 {
            cardFooter.updateData(total: members.count, totalAlive: membersAlive)
            return cardFooter
        } else {
            return nil
        }
    }
}

extension MemberListViewController: MemberListViewControllerLogic {
    func loading(isLoading: Bool) {
        if isLoading {
            addLoading()
        } else {
            removeLoading()
        }
    }
    
    func selectedHouse(houseName: String) {
        adjustLayout()
        self.title = houseName
    }
    
    func fetchMembers(viewModel: MemberListModels.Fetch.ViewModel) {
        members = viewModel.members
        membersAlive = viewModel.membersAlive
        interactor?.loading(isLoading: false)
        
        queueMain.async { [weak self] in
            self?.memberTable.reloadData()
        }
    }
}
