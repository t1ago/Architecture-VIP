//
//  FindMemberRouter.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 13/04/23.
//

import Foundation

protocol MemberListRouterLogic {
    func find(member: MemberViewModel)
}

class MemberListRouter: MemberListRouterLogic {
    var viewController: MemberListViewController?
    
    func find(member: MemberViewModel) {
        let findMemberViewController = FindMemberViewController()
        findMemberViewController.viewModel = member
        
        viewController?.navigationController?.pushViewController(findMemberViewController, animated: true)
    }
}
