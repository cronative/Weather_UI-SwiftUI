//
//  MainUseCase.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation

struct MainUseCase {
    
    // MARK: - Variables
    let repository: MainRepository = MainRepository()
    
    
    // MARK: - Inits
    init() {
        
    }
    
    
    // MARK: - Functions
    
    func searchForCities(query: String) async -> [CityInfoNW] {
        return await self.repository.getCitiesData(query: query)
    }
}
