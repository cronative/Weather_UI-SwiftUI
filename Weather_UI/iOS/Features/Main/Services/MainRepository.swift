//
//  Repository.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation

struct MainRepository {
    
    // MARK: - Variables
    private let networkManager: NetworkRequestProtocol
    
    
    // MARK: - Inits
    init(networkManager: NetworkRequestProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    // MARK: - Functions
    func getCitiesData(query: String) async -> [CityInfoNW] {
        do {
            let citiesInfo = try await networkManager.getCitiesForPrefix(cityName: query)
            return citiesInfo?.data ?? []
        } catch {
            
            return []
        }
    }
}
