//
//  MainViewModel.swift
//  Weather_UI
//
//  Created by Nikunj on 10/05/24.
//

import SwiftUI

enum SearchState {
    case inactive
    case searching
    case searched
}

@Observable
class MainViewModel {
    
    // MARK: - Variables
    
    var defaultCityName = "Bengaluru"
    
    
    var allWeatherInfo: [WeatherInfoUI] = []
    var currentPage: Int? = 0
    
    var weeklyTemperature: [WeatherWeeklyUI] = [
    ]
    
    var searchedCities: [CityInfoNW] = []
    
    var searchedState: SearchState = .inactive
    var searchOpened = false
    var searchedQuery = "" {
        didSet {
            if searchedQuery.count >= 3 {
                searchForCities()
            }
        }
    }
    
    
    let mainUseCase: MainUseCase = MainUseCase()
    
    
    // MARK: - Inits
    init(forTest: Bool = false) {
        self.generateTemperatures()
        if forTest {
            let weatherInfo = WeatherInfoUI(coordinates: WeatherCoordinatesUI(longitude: 77.6033, latitude: 12.9762), weather: [WeatherDescriptionUI(id: 802, main: "Clouds", description: "scattered clouds", icon: "04d")], climateInfo: WeatherMainUI(temperature: 22.4, precipitation: 26.34, minTemperature: 18.2, maxTemperature: 25.8, airPressure: 1016.0, humidity: 73.0), visibility: 6000, windInfo: WindInfoUI(speed: 2.06, degree: 90.0), timeStamp: 1715536198.0, clouds: CloudInfoUI(cloudPercentage: 40.0), dayInfo: DayTimeInfoUI(countryCode: "", sunriseTime: 0.0, sunsetTime: 0.0), timeZone: 19800.0, cityID: 1277333, cityName: "Bengaluru", order: nil)
            
            let delhiInfo = WeatherInfoUI(coordinates: WeatherCoordinatesUI(longitude: 77.6033, latitude: 12.9762), weather: [WeatherDescriptionUI(id: 802, main: "Clear", description: "scattered clouds", icon: "01n")], climateInfo: WeatherMainUI(temperature: 26.8, precipitation: 26.34, minTemperature: 20.1, maxTemperature: 28.9, airPressure: 1016.0, humidity: 73.0), visibility: 6000, windInfo: WindInfoUI(speed: 2.06, degree: 90.0), timeStamp: 1715536198.0, clouds: CloudInfoUI(cloudPercentage: 40.0), dayInfo: DayTimeInfoUI(countryCode: "", sunriseTime: 0.0, sunsetTime: 0.0), timeZone: 19800.0, cityID: 1277333, cityName: "Delhi", order: nil)
            
            let bilaspurInfo = WeatherInfoUI(coordinates: WeatherCoordinatesUI(longitude: 77.6033, latitude: 12.9762), weather: [WeatherDescriptionUI(id: 802, main: "Rainy", description: "scattered clouds", icon: "10n")], climateInfo: WeatherMainUI(temperature: 24.3, precipitation: 26.34, minTemperature: 19.4, maxTemperature: 27.4, airPressure: 1016.0, humidity: 73.0), visibility: 6000, windInfo: WindInfoUI(speed: 2.06, degree: 90.0), timeStamp: 1715536198.0, clouds: CloudInfoUI(cloudPercentage: 40.0), dayInfo: DayTimeInfoUI(countryCode: "", sunriseTime: 0.0, sunsetTime: 0.0), timeZone: 19800.0, cityID: 1277333, cityName: "Bilaspur", order: nil)

            let singaporeInfo = WeatherInfoUI(coordinates: WeatherCoordinatesUI(longitude: 77.6033, latitude: 12.9762), weather: [WeatherDescriptionUI(id: 802, main: "Clear", description: "scattered clouds", icon: "01n")], climateInfo: WeatherMainUI(temperature: 21.2, precipitation: 26.34, minTemperature: 19.4, maxTemperature: 26.8, airPressure: 1016.0, humidity: 73.0), visibility: 6000, windInfo: WindInfoUI(speed: 2.06, degree: 90.0), timeStamp: 1715536198.0, clouds: CloudInfoUI(cloudPercentage: 40.0), dayInfo: DayTimeInfoUI(countryCode: "", sunriseTime: 0.0, sunsetTime: 0.0), timeZone: 19800.0, cityID: 1277333, cityName: "Singapore", order: nil)

            self.searchedCities = [
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "BN", region: "", regionCode: "", latitude: 0, longitude: 0),
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0),
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0),
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0),
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0),
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0),
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0),
                CityInfoNW(city: "Ban", name: "", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0),

            ]
            
            
            self.allWeatherInfo.append(weatherInfo)
            self.allWeatherInfo.append(delhiInfo)
            self.allWeatherInfo.append(bilaspurInfo)
            self.allWeatherInfo.append(singaporeInfo)
            
        }
    }
    
    
    // MARK: - Functions
    func getCurrentWeather() -> WeatherInfoUI {
        guard !self.allWeatherInfo.isEmpty else {
            return WeatherInfoUI(coordinates: WeatherCoordinatesUI(longitude: 0, latitude: 0), weather: [], climateInfo: WeatherMainUI(temperature: 25, precipitation: 0, minTemperature: 0, maxTemperature: 0, airPressure: 0, humidity: 0), visibility: 0, windInfo: WindInfoUI(speed: 0, degree: 0), timeStamp: 2142, clouds: CloudInfoUI(cloudPercentage: 24), dayInfo: DayTimeInfoUI(countryCode: "", sunriseTime: 0, sunsetTime: 0), timeZone: 0, cityID: 0, cityName: "", order: 0)
        }
        
        return allWeatherInfo[currentPage ?? 0]
    }
    
    func searchForCities() {
        self.searchedState = .searching
        Task {
            let cities = await self.mainUseCase.searchForCities(query: self.searchedQuery)
            print("Cities", cities)
            self.searchedCities = cities
            self.searchedState = .searched
        }
    }
    
    func resetSearch() {
        withAnimation(.smooth) {
            self.searchedState = .inactive
            self.searchedCities = []
            self.searchOpened.toggle()
            self.searchedQuery = ""
        }
    }
}

extension MainViewModel {
    func generateWeekdayLabelsAndWeatherData(count: Int) -> [(weekday: String, minTemp: Double, maxTemp: Double, temp: Double, description: String)] {
        let weatherDescriptions = ["Clear & Sunny", "Cloudy", "Sunny", "Rainy", "Windy", "Stormy"]
        
        var result: [(weekday: String, minTemp: Double, maxTemp: Double, temp: Double, description: String)] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Full weekday name

        let today = Date()

        for i in 0..<count {
            if let nextDate = calendar.date(byAdding: .day, value: i, to: today) {
                let weekdayLabel = (i == 0) ? "Today" : dateFormatter.string(from: nextDate)
                
                let minTemperature = Double.random(in: 14...25)
                let maxTemperature = Double.random(in: (minTemperature + 1)...40)
                let randomTemperature = Double.random(in: minTemperature...maxTemperature)
                let randomDescription = (i == 0) ? "Clouds" : weatherDescriptions.randomElement()!
                
                result.append((weekday: weekdayLabel, minTemp: minTemperature, maxTemp: maxTemperature, temp: randomTemperature, description: randomDescription))
            }
        }

        return result
    }

    func generateTemperatures() {
        let count = 7
        let weekdayLabelsAndTemperatures = generateWeekdayLabelsAndWeatherData(count: count)

        self.weeklyTemperature = weekdayLabelsAndTemperatures.map({ WeatherWeeklyUI(temperature: $0.temp, minimumTemperature: $0.minTemp, maximumTemperature: $0.maxTemp, weekday: $0.weekday, currentDescription: $0.description) })
    }
    

}
