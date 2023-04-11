//
//  MemberListPresenter.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation
import UIKit.UIImage

protocol MemberListPresenterLogic: AnyObject {
    func loading(isLoading: Bool)
    func selectedHouse(houseName: String)
    func fetchMembers(response: MemberListModels.Fetch.Response)
}

class MemberListPresenter {
    weak var viewController: MemberListViewControllerLogic?
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
}

extension MemberListPresenter: MemberListPresenterLogic {
    func loading(isLoading: Bool) {
        viewController?.loading(isLoading: isLoading)
    }
    
    func selectedHouse(houseName: String) {
        viewController?.selectedHouse(houseName: houseName)
    }
    
    func fetchMembers(response: MemberListModels.Fetch.Response) {
        let members = response.members.map { member in
            var viewModel: MemberViewModel
            var data: Data!
            if let imageUrl = member.image, !imageUrl.isEmpty {
                let url = URL(string: imageUrl)
                data = try? Data(contentsOf: url!)
            }
            else {
                let image = UIImage(named: "hogwarts_logo")
                data = image?.pngData() ?? Data()
            }
            
            
            viewModel = MemberViewModel(id: member.id,
                                        name: member.name,
                                        yearOfBirth: member.yearOfBirth,
                                        alive: member.alive,
                                        image: data)
            
            return viewModel
        }
        
        let viewModel = MemberListModels.Fetch.ViewModel(membersAlive: members.filter({ $0.alive == true }).count,
                                                         members: members)
        viewController?.fetchMembers(viewModel: viewModel)
    }
}
