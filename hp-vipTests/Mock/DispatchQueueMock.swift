//
//  DispatchQueueMock.swift
//  hp-vipTests
//
//  Created by Tiago Henrique Piantavinha on 24/03/23.
//
@testable import hp_vip

final class DispatchQueueMock: Dispatching {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
