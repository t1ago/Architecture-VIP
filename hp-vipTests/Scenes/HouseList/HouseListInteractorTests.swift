//
//  HouseInteractorTests.swift
//  hp-vipTests
//
//  Created by Tiago Henrique Piantavinha on 24/03/23.
//

import XCTest
@testable import hp_vip

class HouseListPresenterSpy: HouseListPresenterLogic {
    var failed: Bool = false
    var isLoading: Bool = false
    var response: HouseList.Fetch.Response?
    
    
    func loading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func fetchHouses(response: HouseList.Fetch.Response) {
        self.response = response
    }
    
    func fail() {
        self.failed = true
    }
}

class HouseListAPIWorkerSpy: HouseListAPIWorkerLogic {
    var failed: Bool = false
    
    var API_URL: String { "" }
    
    func fetch<P>(with params: P?, complete result: @escaping (completed) -> Void) {
        if failed {
            result(.fail)
        } else {
            let houseAPIModel = HouseAPIModel(id: 1, name: "teste", image_url: "", members: 10)
            result(.success(R(houses: [houseAPIModel])))
        }
    }
}

class HouseListCDWorkerSpy: HouseListCDWorkerLogic {
    
    var houses: [HouseAPIModel] = []
    
    func save<P>(param: [P]) {
    }
    
    func fetch() -> [T] {
        return houses
    }
}

final class HouseListInteractorTests: XCTestCase {
    var sut: HouseListInteractor!
    var workerAPISpy = HouseListAPIWorkerSpy()
    var workerCDSpy = HouseListCDWorkerSpy()
    var presenterSpy = HouseListPresenterSpy()

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HouseListInteractor(houseListAPIWorker: workerAPISpy,
                                  houseListCDWorker: workerCDSpy,
                                  houseListPresenter: presenterSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testLoading() {
        sut.loading(isLoading: true)
        XCTAssertTrue(presenterSpy.isLoading)
        
        sut.loading(isLoading: false)
        XCTAssertFalse(presenterSpy.isLoading)
    }
    
    func testFetchHousesWithoutCache() {
        workerCDSpy.houses = []
        sut.fetchHouses()
        XCTAssertEqual(1, presenterSpy.response?.houses.count)
    }
    
    func testFetchHousesWithCache() {
        workerCDSpy.houses = [HouseAPIModel(id: 1, name: "teste", image_url: "", members: 10)]
        sut.fetchHouses()
        XCTAssertEqual(1, presenterSpy.response?.houses.count)
    }
    
    func testFail() {
        workerAPISpy.failed = true
        sut.fetchHouses()
        XCTAssertTrue(presenterSpy.failed)
    }

}
