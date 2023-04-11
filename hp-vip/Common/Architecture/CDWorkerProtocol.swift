//
//  CDWorkerProtocol.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 30/03/23.
//

import Foundation

protocol CDWorkerProtocol: AnyObject {
    associatedtype T
    
    var ENTITY: String { get }
    
    func fetch() -> [T]
    func save<P>(param: [P])
}

extension CDWorkerProtocol {
    var ENTITY: String { "" }
    
    func fetch() -> [T] { return [] }
    
    func save<P>(param: [P]) { }
}
