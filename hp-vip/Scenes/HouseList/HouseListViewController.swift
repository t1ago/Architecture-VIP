//
//  HouseListViewController.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/03/23.
//

import UIKit

protocol HouseListViewControllerLogic : AnyObject {
    func loading(isLoading: Bool)
    func fetchHouses(viewModel: HouseList.Fetch.ViewModel)
    func fail()
}

class HouseListViewController: UIViewController {
    
    var interactor: HouseListInteractorLogic?
    var router: HouseListRouterLogic?
    var queueMain: Dispatching
    
    lazy var scrollView: ViewUIScrollView = {
        let scroll = ViewUIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var lblSelectHouse: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Selecione sua Casa"
        return label
    }()
    
    lazy var lineHouse1: GroupHouseUIButton = {
        let stack = GroupHouseUIButton()
        return stack
    }()
    
    lazy var house1: HouseUIButton = {
        let button = HouseUIButton<HouseViewModel>()
        return button
    }()
    
    lazy var house2: HouseUIButton = {
        let button = HouseUIButton<HouseViewModel>()
        return button
    }()
    
    lazy var lineHouse2: GroupHouseUIButton = {
        let stack = GroupHouseUIButton()
        return stack
    }()
    
    lazy var house3: HouseUIButton = {
        let button = HouseUIButton<HouseViewModel>()
        return button
    }()
    
    lazy var house4: HouseUIButton = {
        let button = HouseUIButton<HouseViewModel>()
        return button
    }()
    
    lazy var loading: LoadingUIActivityIndicatior = {
        let activityindicator = LoadingUIActivityIndicatior()
        return activityindicator
    }()
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .white
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.layout.addSubview(lblSelectHouse)
        scrollView.layout.addSubview(lineHouse1)
        scrollView.layout.addSubview(lineHouse2)
        lineHouse1.addArrangedSubview(house1)
        lineHouse1.addArrangedSubview(house2)
        lineHouse2.addArrangedSubview(house3)
        lineHouse2.addArrangedSubview(house4)
        adjustConstraints()
        addListener()
    }
    
    init(queueMain: Dispatching = DispatchQueue.main) {
        self.queueMain = queueMain
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, deprecated, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loading(isLoading: true)
        interactor?.fetchHouses()
    }
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
    
    private func adjustConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            lblSelectHouse.topAnchor.constraint(equalTo: scrollView.layout.topAnchor, constant: 10.0),
            lblSelectHouse.centerXAnchor.constraint(equalTo: scrollView.layout.centerXAnchor),
            
            lineHouse1.topAnchor.constraint(equalTo: lblSelectHouse.bottomAnchor, constant: 50.0),
            lineHouse1.centerXAnchor.constraint(equalTo: scrollView.layout.centerXAnchor),
            
            house1.heightAnchor.constraint(equalToConstant: 130.0),
            house1.widthAnchor.constraint(equalTo: house1.heightAnchor),
            
            house2.heightAnchor.constraint(equalTo: house1.heightAnchor),
            house2.widthAnchor.constraint(equalTo: house1.widthAnchor),
            
            lineHouse2.topAnchor.constraint(equalTo: lineHouse1.bottomAnchor, constant: 50.0),
            lineHouse2.centerXAnchor.constraint(equalTo: scrollView.layout.centerXAnchor),
            lineHouse2.bottomAnchor.constraint(equalTo: scrollView.layout.bottomAnchor, constant: -15.0),
            
            house3.heightAnchor.constraint(equalToConstant: 130.0),
            house3.widthAnchor.constraint(equalTo: house1.heightAnchor),
            
            house4.heightAnchor.constraint(equalTo: house1.heightAnchor),
            house4.widthAnchor.constraint(equalTo: house1.widthAnchor),
        ])
    }
    
    private func addListener() {
        house1.addTarget(self, action: #selector(selectedHouse), for: .touchUpInside)
        house2.addTarget(self, action: #selector(selectedHouse), for: .touchUpInside)
        house3.addTarget(self, action: #selector(selectedHouse), for: .touchUpInside)
        house4.addTarget(self, action: #selector(selectedHouse), for: .touchUpInside)
    }
    
    @objc func selectedHouse(_ sender: UIButton) {
        guard let button = sender as? HouseUIButton<HouseViewModel>,
              let houseName = button.viewModel?.name else { return }
        router?.membersList(with: houseName)
    }
    
    private func addLoading() {
        loading.startAnimating()
        self.view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func removeLoading() {
        queueMain.async {
            self.loading.stopAnimating()
            self.loading.removeFromSuperview()
            self.view.layoutIfNeeded()
        }
    }
}

extension HouseListViewController: HouseListViewControllerLogic {
    func loading(isLoading: Bool) {
        if isLoading {
            addLoading()
        } else {
            removeLoading()
        }
    }
    
    func fetchHouses(viewModel: HouseList.Fetch.ViewModel) {
        let buttons = [house1, house2, house3, house4]

        for (index, house) in viewModel.houses.enumerated() {
            let image = UIImage(data: house.image)

            queueMain.async {
                buttons[index].viewModel = house
                buttons[index].setImage(image, for: .normal)
            }
        }
        
        interactor?.loading(isLoading: false)
    }
    
    func fail() {
        queueMain.async { [weak self] in
            let alert = UIAlertController(title: "Casas", message: "Falha ao carregar as casas", preferredStyle: .alert)
            let tryAgain = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.interactor?.loading(isLoading: true)
                self?.interactor?.fetchHouses()
            }
            alert.addAction(tryAgain)
            self?.present(alert, animated: true)
        }
    }
}
