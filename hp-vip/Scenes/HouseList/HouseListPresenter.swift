//
//  HouseListPresenter.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/03/23.
//

import Foundation

protocol HouseListPresenterLogic: AnyObject {
    func loading(isLoading: Bool)
    func fetchHouses(response: HouseList.Fetch.Response)
    func fail()
}

class HouseListPresenter {
    weak var viewController: HouseListViewControllerLogic?
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
}

extension HouseListPresenter: HouseListPresenterLogic {
    func loading(isLoading: Bool) {
        viewController?.loading(isLoading: isLoading)
    }
    
    func fetchHouses(response: HouseList.Fetch.Response) {
        let houses = response.houses.map { house in
            let url = URL(string: house.image_url)
            let data = try? Data(contentsOf: url!)
            let viewModel = HouseViewModel(name: house.name,
                                           image: data ?? Data(),
                                           members: house.members)
            return viewModel
        }
        
        let viewModel = HouseList.Fetch.ViewModel(houses: houses)
        viewController?.fetchHouses(viewModel: viewModel)
    }
    
    func fail() {
        viewController?.fail()
    }
}
