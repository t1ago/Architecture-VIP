//
//  HouseListPresenterTests.swift
//  hp-vipTests
//
//  Created by Tiago Henrique Piantavinha on 24/03/23.
//

import XCTest
@testable import hp_vip

class HouseListViewControllerSpy: HouseListViewControllerLogic {
    var isLoading: Bool = false
    var viewModel: HouseList.Fetch.ViewModel?
    var failed: Bool = false
    
    func loading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func fetchHouses(viewModel: HouseList.Fetch.ViewModel) {
        self.viewModel = viewModel
    }
    
    func fail() {
        self.failed = true
    }
}

final class HouseListPresenterTests: XCTestCase {

    var sut: HouseListPresenter!
    var viewControllerSpy = HouseListViewControllerSpy()

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HouseListPresenter()
        sut.viewController = viewControllerSpy
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testLoading() {
        sut.loading(isLoading: true)
        XCTAssertTrue(viewControllerSpy.isLoading)
        
        sut.loading(isLoading: false)
        XCTAssertFalse(viewControllerSpy.isLoading)
    }
    
    func testFetchHouse() {
        let houseAPI = HouseAPIModel(id: 1, name: "teste", image_url: "http://www.test.test.br", members: 10)
        let response = HouseList.Fetch.Response(houses: [houseAPI])
        sut.fetchHouses(response: response)
        XCTAssertEqual(1, viewControllerSpy.viewModel?.houses.count)
    }
    
    func testFail() {
        sut.fail()
        XCTAssertTrue(viewControllerSpy.failed)
    }

}
