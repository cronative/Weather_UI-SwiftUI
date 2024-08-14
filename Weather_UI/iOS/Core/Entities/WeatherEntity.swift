//
//  WeatherEntity.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation

struct WeatherEntity: DatabaseCore {
    
    // MARK: - Functions
    func addWeatherInfoToDB(weatherInfo: WeatherInfoDB) {
        add(weatherInfo)
    }
    
    func deleteWeatherInfoToDB(weatherInfo: WeatherInfoDB) {
        delete(weatherInfo)
    }
    
    func getAllWeatherInfo() -> [WeatherInfoDB] {
        let weatherInfo = get(fromEntity: WeatherInfoDB.self, withPredicate: nil)
        
        return Array(weatherInfo)
    }
}
