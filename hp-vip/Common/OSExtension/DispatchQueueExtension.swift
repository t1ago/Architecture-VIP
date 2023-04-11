//
//  DispatchQueueExtension.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 24/03/23.
//

import Foundation

protocol Dispatching {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: Dispatching {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .userInteractive, flags: [], execute: work)
    }
}
