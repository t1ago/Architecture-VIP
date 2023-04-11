//
//  MemberListModels.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

enum MemberListModels {
    enum Fetch {
        struct Request {
            let houseName: String
        }
        struct Response {
            let members: [MemberAPIModel]
        }
        struct ViewModel {
            let membersAlive: Int
            let members: [MemberViewModel]
        }
    }
}
