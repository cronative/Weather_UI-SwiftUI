//
//  CurrentWeatherInfo.swift
//  Weather_UI
//
//  Created by Nikunj on 12/05/24.
//

import SwiftUI

struct CurrentWeatherInfo: View {
    
    // MARK: - Variables
    var climateInfo: WeatherMainUI
    var weatherInfo: [WeatherDescriptionUI]
    
    // MARK: - Views
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.025) {
            ViewBuilders.GenerateTemperatureView(temperature: climateInfo.maxTemperature, isCurrent: false)
            ViewBuilders.GenerateTemperatureView(temperature: climateInfo.temperature, isCurrent: true)
            ViewBuilders.GenerateTemperatureView(temperature: climateInfo.minTemperature, isCurrent: false)
            HStack {
                Text(weatherInfo[0].main)
                    .font(Montserrat.semibold.font(size: 16))
                    .textCase(.uppercase)
                    .tracking(1.25)
                
                Image(systemName: WeatherIconGenerator.configurationForCity(weatherIcon: weatherInfo[0].icon).1)
                    .font(.system(size: 22, weight: .medium))
            }
            .padding(.top, 44)
        }
    }
    
    // MARK: - Functions
}

#Preview {
    CurrentWeatherInfo(climateInfo: WeatherMainUI(temperature: 25, precipitation: 4.24, minTemperature: 20, maxTemperature: 28, airPressure: 410, humidity: 203), weatherInfo: [WeatherDescriptionUI(id: 123, main: "Sunny", description: "Sunny", icon: "01d")])
        .environment(MainViewModel(forTest: true))
        .padding(24)
}
