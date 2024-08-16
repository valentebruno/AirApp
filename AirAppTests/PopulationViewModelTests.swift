//
//  PopulationViewModelTests.swift
//  AirApp
//
//  Created by mini on 16/08/2024.
//

import XCTest
@testable import AirApp

class PopulationViewModelTests: XCTestCase {
    
    var sut: PopulationViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkManager = MockNetworkManager()
        sut = PopulationViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockNetworkManager = nil
        try super.tearDownWithError()
    }
    
    func testFetchPopulationData_Success() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch population data")
        let mockData = [Population(id: "1", year: "2021", population: 1000000, state: "California", nation: nil)]
        mockNetworkManager.mockResult = .success(mockData)
        
        // When
        await sut.fetchPopulationData(for: .state)
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.populations.count, 1)
        XCTAssertEqual(sut.populations.first?.state, "California")
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testFetchPopulationData_Error() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch population data with error")
        mockNetworkManager.mockResult = .failure(NetworkError.noData)
        
        // When
        await sut.fetchPopulationData(for: .nation)
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.populations.isEmpty)
        XCTAssertEqual(sut.error as? NetworkError, .noData)
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
