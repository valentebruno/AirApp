//
//  NetworkManagerTests.swift .swift
//  AirApp
//
//  Created by mini on 16/08/2024.
//

import XCTest
@testable import AirApp

class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager.shared
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testFetchPopulationData_SuccessfulResponse() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Fetch population data")
        
        // When
        do {
            let populations = try await sut.fetchPopulationData(for: .state)
            
            // Then
            XCTAssertFalse(populations.isEmpty, "Population data should not be empty")
            XCTAssertTrue(populations.allSatisfy { $0.state != nil }, "All items should have a state")
            expectation.fulfill()
        } catch {
            XCTFail("Error should not be thrown: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testFetchPopulationData_InvalidURL() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch population data with invalid URL")
        
        // When
        do {
            _ = try await sut.fetchPopulationData(for: .nation)
            XCTFail("This should throw an error")
        } catch {
            // Then
            XCTAssertTrue(error is NetworkError, "Error should be of type NetworkError")
            XCTAssertEqual(error as? NetworkError, .invalidURL, "Error should be invalidURL")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
