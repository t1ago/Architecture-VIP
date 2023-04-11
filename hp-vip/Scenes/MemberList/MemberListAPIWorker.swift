//
//  MemberListWorker.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation

protocol MemberListWorkerLogic: APIWorkerProtocol where P == String, R == MemberListModels.Fetch.Response { }

class MemberListAPIWorker: MemberListWorkerLogic {
    
    var API_URL: String { "https://hp-api.onrender.com/api/characters/house" }
    
    func fetch<P>(with params: P?, complete result: @escaping (completed) -> Void) {
        guard let path = params else { result(.fail); return }
        let url = URL(string: "\(API_URL)/\(path)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let members = try? JSONDecoder().decode([MemberAPIModel].self, from: data)
                result(.success(R(members: members ?? [])))
            } else {
                result(.fail)
            }
        }
        task.resume()
    }
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
    
    func fetchMembers(houseName: String, completion: @escaping (MemberListModels.Fetch.Response) -> Void) {
        
        
    }
}
