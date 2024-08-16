//
//  ContentView.swift
//  AirApp
//
//  Created by mini on 16/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PopulationViewModel()
    @State private var selectedType: PopulationType = .state
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Population Type", selection: $selectedType) {
                    Text("State").tag(PopulationType.state)
                    Text("Nation").tag(PopulationType.nation)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(error: error)
                } else {
                    List(viewModel.populations) { population in
                        NavigationLink(destination: PopulationDetailView(population: population)) {
                            PopulationRowView(population: population)
                        }
                    }
                }
            }
            .navigationTitle("Population Data")
        }
        .onAppear {
            viewModel.fetchPopulationData(for: selectedType)
        }
        .onChange(of: selectedType) { _ in
            viewModel.fetchPopulationData(for: selectedType)
        }
    }
}

struct PopulationRowView: View {
    let population: Population
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(population.state ?? population.nation ?? "")
                .font(.headline)
            Text("Year: \(population.year)")
            Text("Population: \(population.population)")
        }
    }
}

struct PopulationDetailView: View {
    let population: Population
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(population.state ?? population.nation ?? "")
                .font(.title)
            Text("Year: \(population.year)")
            Text("Population: \(population.population)")
        }
        .padding()
        .navigationTitle("Population Details")
    }
}

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("An error occurred:")
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
        }
    }
}
