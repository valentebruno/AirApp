//
//  MockNetworkManager.swift
//  AirApp
//
//  Created by mini on 16/08/2024.
//

class MockNetworkManager: NetworkManager {
    var mockResult: Result<[Population], Error>?
    
    override func fetchPopulationData(for type: PopulationType) async throws -> [Population] {
        guard let result = mockResult else {
            fatalError("Mock result not set")
        }
        
        switch result {
        case .success(let populations):
            return populations
        case .failure(let error):
            throw error
        }
    }
}
