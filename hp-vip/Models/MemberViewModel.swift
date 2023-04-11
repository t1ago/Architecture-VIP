//
//  MemberViewModel.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation

struct MemberViewModel: Codable, Equatable {
    let id: String
    let name: String
    let yearOfBirth: Int?
    let alive: Bool
    let image: Data?
}
