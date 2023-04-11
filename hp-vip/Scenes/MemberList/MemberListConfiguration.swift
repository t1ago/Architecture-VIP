//
//  MemberListConfiguration.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation

class MemberListConfiguration {
    static func configure(houseName: String,
                          viewController: MemberListViewController) {
        let presenter = MemberListPresenter()
        presenter.viewController = viewController
        
        let interactor = MemberListInteractor(houseName: houseName,
                                              memberListPresenter: presenter)
        viewController.interactor = interactor
    }
}

