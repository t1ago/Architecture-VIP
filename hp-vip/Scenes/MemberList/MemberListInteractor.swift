//
//  MemberListInteractor.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation

protocol MemberListInteractorLogic: AnyObject {
    func loading(isLoading: Bool)
    func selectedHouse()
    func fetchMembers()
    func refreshMembers()
}

class MemberListInteractor {
    var houseName: String
    var memberListPresenter: MemberListPresenterLogic
    var memberListAPIWorker: any MemberListWorkerLogic
    var memberListCDWorker: any MemberListCDWorkerLogic
    
    init(houseName: String,
         memberListPresenter: MemberListPresenterLogic,
         memberListAPIWorker: any MemberListWorkerLogic = MemberListAPIWorker(),
         memberListCDWorker: any MemberListCDWorkerLogic = MemberListCDWorker()) {
        self.houseName = houseName
        self.memberListPresenter = memberListPresenter
        self.memberListAPIWorker = memberListAPIWorker
        self.memberListCDWorker = memberListCDWorker
    }
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
}

extension MemberListInteractor: MemberListInteractorLogic {
    func loading(isLoading: Bool) {
        memberListPresenter.loading(isLoading: isLoading)
    }
    
    func selectedHouse() {
        memberListPresenter.selectedHouse(houseName: houseName)
    }
    
    func fetchMembers() {
        let members = memberListCDWorker.fetch(houseName: houseName)
        
        if members.count > 0 {
            memberListPresenter.fetchMembers(response: MemberListModels.Fetch.Response(members: members))
        } else {
            memberListAPIWorker.fetch(with: houseName) { [weak self] response in
                guard let self = self else { return }
                switch(response) {
                case .success(let value):
                    self.memberListCDWorker.save(houseName: self.houseName, param: value.members)
                    self.memberListPresenter.fetchMembers(response: value)
                    NotificationCenter.default.post(name: .addShortcutItemNotification, object: self.houseName)
                default:
                    break
                }
            }
        }
    }
    
    func refreshMembers() {
        memberListCDWorker.remove(houseName: houseName)
        fetchMembers()
    }
}
