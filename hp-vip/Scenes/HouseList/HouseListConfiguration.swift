//
//  HouseListConfiguration.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation

class HouseListConfiguration {
    static func configure(viewController: HouseListViewController) {
        let router = HouseListRouter()
        router.viewController = viewController
        
        let presenter = HouseListPresenter()
        presenter.viewController = viewController
        
        let interactor = HouseListInteractor(houseListPresenter: presenter)
        viewController.interactor = interactor
        viewController.router = router
    }
}
