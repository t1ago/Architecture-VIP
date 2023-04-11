//
//  HouseListModels.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/03/23.
//

enum HouseList {
    enum Fetch {
        struct Request {}
        struct Response {
            let houses: [HouseAPIModel]
        }
        struct ViewModel {
            let houses: [HouseViewModel]
        }
    }
}
