//
//  Models.swift
//  AirApp
//
//  Created by mini on 16/08/2024.
//
enum PopulationType: String {
    case state = "State"
    case nation = "Nation"
}

struct PopulationResponse: Codable {
    let data: [Population]
}

struct Population: Identifiable, Codable {
    let id: String
    let year: String
    let population: Int
    let state: String?
    let nation: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case year = "Year"
        case population = "Population"
        case state = "State"
        case nation = "Nation"
    }
}



