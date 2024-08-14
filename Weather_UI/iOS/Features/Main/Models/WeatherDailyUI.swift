//
//  WeatherDailyUI.swift
//  Weather_UI
//
//  Created by Nikunj on 15/05/24.
//

import Foundation

struct WeatherWeeklyUI: Identifiable {
    let id: UUID = UUID()
    
    let temperature: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    
    let weekday: String
    let currentDescription: String
}
