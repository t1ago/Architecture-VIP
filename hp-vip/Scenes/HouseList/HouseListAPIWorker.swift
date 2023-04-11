//
//  HouseListAPIWorker.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/03/23.
//

import Foundation

protocol HouseListAPIWorkerLogic: APIWorkerProtocol where P == String, R == HouseList.Fetch.Response { }

class HouseListAPIWorker: HouseListAPIWorkerLogic {
    var API_URL: String { "https://legacy--api.herokuapp.com/api/v1/houses" }
    
    deinit {
        print("Removido da memória: \(String(describing: self))")
    }
    
    func fetch<P>(with params: P?, complete result: @escaping (completed) -> Void) {

        let url = URL(string: "\(API_URL)")!

        let task = URLSession.shared.dataTask(with: url) { value, response, error in
            if let value = value {
                let houses = try? JSONDecoder().decode([HouseAPIModel].self, from: value)
                result(.success(R(houses: houses ?? [])))
            } else {
                result(.fail)
            }
        }
        task.resume()
    }
}
