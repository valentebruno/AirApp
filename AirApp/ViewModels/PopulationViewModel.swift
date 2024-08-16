//
//  ViewModel.swift
//  AirApp
//
//  Created by mini on 16/08/2024.
//

import Foundation

class PopulationViewModel: ObservableObject {
    @Published var populations: [Population] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchPopulationData(for type: PopulationType) {
        isLoading = true
        error = nil
        
        Task {
            do {
                let data = try await networkManager.fetchPopulationData(for: type)
                DispatchQueue.main.async {
                    self.populations = data
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}
