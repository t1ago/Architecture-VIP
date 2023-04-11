//
//  APIWorkerProtocol.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 27/03/23.
//

import Foundation

enum APIWorkerComplete<D>{
    case success(D)
    case fail
}

protocol APIWorkerProtocol: AnyObject {
    
    associatedtype P
    associatedtype R
    
    typealias completed = APIWorkerComplete<R>
    
    var API_URL: String { get }
    
    func fetch<P>(with params: P?, complete result: @escaping (completed) -> Void)
}

extension APIWorkerProtocol {
    var url: String { "" }
    
    func fetch<P>(with params: P?, complete result: @escaping (completed) -> Void) { }
}
