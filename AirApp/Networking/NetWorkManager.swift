//
//  NetWorkMAnager.swift
//  AirApp
//
//  Created by mini on 16/08/2024.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

open class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
open func fetchPopulationData(for type: PopulationType) async throws -> [Population] {
        let urlString = "https://datausa.io/api/data?drilldowns=\(type.rawValue)&measures=Population"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(PopulationResponse.self, from: data)
            return response.data
        } catch {
            throw NetworkError.decodingError
        }
    }
}
