//
//  Weather.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation

struct WeatherInfoNW: Decodable {
    let coordinates: WeatherCoordinatesNW
    let weather: [WeatherDescriptionNW]
    let climateInfo: WeatherMainNW
    let visibility: Int?
    let windInfo: WindInfoNW
    let timeStamp: Double
    let clouds: CloudInfoNW
    let dayInfo: DayTimeInfoNW
    let timeZone: Double
    let cityID: Int
    let cityName: String
    let order: Int?
    
    
    private enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather = "weather"
        case climateInfo = "main"
        case visibility = "visibility"
        case windInfo = "wind"
        case timeStamp = "dt"
        case clouds = "clouds"
        case dayInfo = "sys"
        case timeZone = "timezone"
        case cityID = "id"
        case cityName = "name"
        case order = "order"
    }
}


struct WeatherCoordinatesNW: Decodable {
    let longitude: Double
    let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}


struct WeatherDescriptionNW: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


struct WeatherMainNW: Decodable {
    let temperature: Double
    let precipitation: Double
    let minTemperature: Double
    let maxTemperature: Double
    let airPressure: Double
    let humidity: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case precipitation = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case airPressure = "pressure"
        case humidity = "humidity"
    }
    
}

struct WindInfoNW: Decodable {
    let speed: Double
    let degree: Double?
    
    private enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case degree = "deg"
    }
}


struct DayTimeInfoNW: Decodable {
    let countryCode: String
    let sunriseTime: Double
    let sunsetTime: Double
    
    private enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
    }
}

struct CloudInfoNW: Decodable {
    let cloudPercentage: Double
    
    private enum CodingKeys: String, CodingKey {
        case cloudPercentage = "all"
    }
}

//Hourly Data
struct WeatherHourlyNW: Decodable {
    let latitude: Double
    let longitude: Double
    let hourlyData: [WeatherHourNW]
    let dailyData: [WeatherDailyNW]
    let timeZoneOffset: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case hourlyData = "hourly"
        case dailyData = "daily"
        case timeZoneOffset = "timezone_offset"
    }
}

struct WeatherHourNW: Decodable {
    let timestamp: Double
    let temperature: Double
    let pressure: Double
    let humidity: Int
    let dewPoint: Double
    let clouds: Int
    let windSpeed: Double
    let windDegree: Double
    let weather: [WeatherDescriptionNW]
    let timeZoneOffset: Double?
    
    lazy var timeZoneDifference: Double? = {
        guard let timeZoneOffset = timeZoneOffset else { return 0 }
        return timestamp + timeZoneOffset
    }()
    
    private enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case temperature = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case dewPoint = "dew_point"
        case clouds = "clouds"
        case windSpeed = "wind_speed"
        case windDegree = "wind_deg"
        case weather = "weather"
        case timeZoneOffset = "timezone_offset"
    }
}


struct WeatherDailyNW: Decodable {
    let timestamp: Double
    let sunrise: Double
    let sunset: Double
    let weather: [WeatherDescriptionNW]
    let clouds: Int
    
    private enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case weather = "weather"
        case clouds = "clouds"
    }
}
