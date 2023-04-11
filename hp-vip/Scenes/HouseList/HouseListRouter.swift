//
//  HouseListRouter.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import UIKit

protocol HouseListRouterLogic {
    func membersList(with houseName: String)
}

class HouseListRouter {
    var viewController: HouseListViewController?
}

extension HouseListRouter: HouseListRouterLogic {
    func membersList(with houseName: String) {
        let memberListViewController = MemberListViewController()
        MemberListConfiguration.configure(houseName: houseName,
                                          viewController: memberListViewController)
        viewController?.navigationController?.pushViewController(memberListViewController, animated: true)
    }
}
