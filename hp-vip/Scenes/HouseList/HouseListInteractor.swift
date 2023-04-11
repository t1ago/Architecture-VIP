//
//  HouseListInteractor.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/03/23.
//

import Foundation

protocol HouseListInteractorLogic: AnyObject {
    func loading(isLoading: Bool)
    func fetchHouses()
}

class HouseListInteractor {
    var houseListAPIWorker: any HouseListAPIWorkerLogic
    var houseListCDWorker: any HouseListCDWorkerLogic
    var houseListPresenter: HouseListPresenterLogic
    
    init(houseListAPIWorker: any HouseListAPIWorkerLogic = HouseListAPIWorker(),
         houseListCDWorker: any HouseListCDWorkerLogic = HouseListCDWorker(),
         houseListPresenter: HouseListPresenterLogic) {
        self.houseListAPIWorker = houseListAPIWorker
        self.houseListCDWorker = houseListCDWorker
        self.houseListPresenter = houseListPresenter
    }
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
}

extension HouseListInteractor: HouseListInteractorLogic {
    func loading(isLoading: Bool) {
        houseListPresenter.loading(isLoading: isLoading)
    }
    
    func fetchHouses() {
        let houses = houseListCDWorker.fetch()
        
        if houses.count > 0 {
            houseListPresenter.fetchHouses(response: HouseList.Fetch.Response(houses: houses))
        } else {
            houseListAPIWorker.fetch(with: "") { [weak self] response in
                switch response {
                case .success(let value):
                    self?.houseListCDWorker.save(param: value.houses)
                    self?.houseListPresenter.fetchHouses(response: value)
                default:
                    self?.houseListPresenter.fail()
                }
            }
        }
    }
}
