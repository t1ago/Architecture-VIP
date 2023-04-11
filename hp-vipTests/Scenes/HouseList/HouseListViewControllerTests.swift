//
//  HouseListViewControllerTests.swift
//  hp-vipTests
//
//  Created by Tiago Henrique Piantavinha on 23/03/23.
//

import XCTest
@testable import hp_vip

class HouseListInteractorSpy: HouseListInteractorLogic {
    var isLoading: Bool = false
    var fetched: Bool = false
    
    func loading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func fetchHouses() {
        self.fetched = true
    }
}

class HouseListRouterSpy: HouseListRouterLogic {
    var houseName: String = ""
    
    func membersList(with houseName: String) {
        self.houseName = houseName
    }
}

final class HouseListViewControllerTests: XCTestCase {
    
    var sut: HouseListViewController!
    var interactorSpy = HouseListInteractorSpy()
    var routerSpy = HouseListRouterSpy()

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HouseListViewController(queueMain: DispatchQueueMock())
        sut.interactor = interactorSpy
        sut.router = routerSpy
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testViewLoad() {
        sut.loadView()
        
        XCTAssertNotNil(sut.lblSelectHouse)
        XCTAssertNotNil(sut.lineHouse1)
        XCTAssertNotNil(sut.house1)
        XCTAssertNotNil(sut.house2)
        XCTAssertNotNil(sut.lineHouse2)
        XCTAssertNotNil(sut.house3)
        XCTAssertNotNil(sut.house4)
        XCTAssertNotNil(sut.loading)
    }

    func testViewAppear() {
        sut.viewDidLoad()
        
        XCTAssertTrue(interactorSpy.isLoading)
        XCTAssertTrue(interactorSpy.fetched)
    }
    
    func testLoading() {
        sut.loading(isLoading: true)
        XCTAssertNotNil(sut.loading.superview)
        
        sut.loading(isLoading: false)
        XCTAssertNil(sut.loading.superview)
    }
    
    func testFetchHouses() {
        let houses: [HouseViewModel] = [
            HouseViewModel(name: "Teste1", image: Data(), members: 0),
            HouseViewModel(name: "Teste2", image: Data(), members: 0),
            HouseViewModel(name: "Teste3", image: Data(), members: 0),
            HouseViewModel(name: "Teste4", image: Data(), members: 0)
        ]
        
        let viewModel = HouseList.Fetch.ViewModel(houses: houses)
        
        sut.fetchHouses(viewModel: viewModel)
    }
    
    func testClickHouse() {
        routerSpy.houseName = ""
        let button = HouseUIButton<HouseViewModel>()
        button.viewModel = HouseViewModel(name: "Teste1", image: Data(), members: 0)
        
        sut.selectedHouse(button)
        XCTAssertEqual(routerSpy.houseName, button.viewModel?.name)
        
        routerSpy.houseName = ""
        button.viewModel = nil
        sut.selectedHouse(button)
        XCTAssertEqual(routerSpy.houseName, "")
    }
    
    func testFail() {
        sut.fail()
    }
}
