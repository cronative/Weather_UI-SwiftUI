//
//  WeatherInfoUI.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation

struct WeatherInfoUI: Identifiable {
    let id: UUID = UUID()
    
    let coordinates: WeatherCoordinatesUI
    let weather: [WeatherDescriptionUI]
    let climateInfo: WeatherMainUI
    let visibility: Int?
    let windInfo: WindInfoUI
    let timeStamp: Double
    let clouds: CloudInfoUI
    let dayInfo: DayTimeInfoUI
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
    
    init(coordinates: WeatherCoordinatesUI, weather: [WeatherDescriptionUI], climateInfo: WeatherMainUI, visibility: Int?, windInfo: WindInfoUI, timeStamp: Double, clouds: CloudInfoUI, dayInfo: DayTimeInfoUI, timeZone: Double, cityID: Int, cityName: String, order: Int?) {
        self.coordinates = coordinates
        self.weather = weather
        self.climateInfo = climateInfo
        self.visibility = visibility
        self.windInfo = windInfo
        self.timeStamp = timeStamp
        self.clouds = clouds
        self.dayInfo = dayInfo
        self.timeZone = timeZone
        self.cityID = cityID
        self.cityName = cityName
        self.order = order
    }
    
    init(weatherInfo: WeatherInfoDB) {
        self.coordinates = WeatherCoordinatesUI(weatherCoordinates: weatherInfo.coordinates ?? WeatherCoordinatesDB())
                
        weather = weatherInfo.weather.map { WeatherDescriptionUI(weatherDescription: $0) }
        
        self.climateInfo = WeatherMainUI(weatherMain: weatherInfo.climateInfo ?? WeatherMainDB())
        self.visibility = weatherInfo.visibility
        self.windInfo = WindInfoUI(windInfo: weatherInfo.windInfo ?? WindInfoDB())
        self.timeStamp = weatherInfo.timeStamp
        self.clouds = CloudInfoUI(cloudInfo: weatherInfo.clouds ?? CloudInfoDB())
        self.dayInfo = DayTimeInfoUI(dayTimeInfo: DayTimeInfoDB())
        self.timeZone = weatherInfo.timeZone
        self.cityID = weatherInfo.cityID
        self.cityName = weatherInfo.cityName
        self.order = weatherInfo.order
    }
}


struct WeatherCoordinatesUI {
    let longitude: Double
    let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(weatherCoordinates: WeatherCoordinatesDB) {
        self.longitude = weatherCoordinates.longitude
        self.latitude = weatherCoordinates.latitude
    }
}


struct WeatherDescriptionUI {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    init(id: Int, main: String, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
    
    init(weatherDescription: WeatherDescriptionDB) {
        self.id = weatherDescription.id
        self.main = weatherDescription.main
        self.description = weatherDescription.description
        self.icon = weatherDescription.icon
    }
}


struct WeatherMainUI {
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
    
    
    init(temperature: Double, precipitation: Double, minTemperature: Double, maxTemperature: Double, airPressure: Double, humidity: Double) {
        self.temperature = temperature
        self.precipitation = precipitation
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.airPressure = airPressure
        self.humidity = humidity
    }
    
    init(weatherMain: WeatherMainDB) {
        self.temperature = weatherMain.temperature
        self.precipitation = weatherMain.precipitation
        self.minTemperature = weatherMain.minTemperature
        self.maxTemperature = weatherMain.maxTemperature
        self.airPressure = weatherMain.airPressure
        self.humidity = weatherMain.humidity
    }
}

struct WindInfoUI {
    let speed: Double
    let degree: Double?
    
    private enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case degree = "deg"
    }
    
    init(speed: Double, degree: Double?) {
        self.speed = speed
        self.degree = degree
    }
    
    init(windInfo: WindInfoDB) {
        self.speed = windInfo.speed
        self.degree = windInfo.degree
    }
}


struct DayTimeInfoUI {
    let countryCode: String
    let sunriseTime: Double
    let sunsetTime: Double
    
    private enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
    }
    
    init(countryCode: String, sunriseTime: Double, sunsetTime: Double) {
        self.countryCode = countryCode
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
    
    init(dayTimeInfo: DayTimeInfoDB) {
        self.countryCode = dayTimeInfo.countryCode
        self.sunsetTime = dayTimeInfo.sunsetTime
        self.sunriseTime = dayTimeInfo.sunriseTime
    }
}

struct CloudInfoUI {
    let cloudPercentage: Double
    
    private enum CodingKeys: String, CodingKey {
        case cloudPercentage = "all"
    }
    
    init(cloudPercentage: Double) {
        self.cloudPercentage = cloudPercentage
    }
    
    init(cloudInfo: CloudInfoDB) {
        self.cloudPercentage = cloudInfo.cloudPercentage
    }
}

//Hourly Data
struct WeatherHourlyUI {
    let latitude: Double
    let longitude: Double
    let hourlyData: [WeatherHourUI]
    let dailyData: [WeatherDailyUI]
    let timeZoneOffset: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case hourlyData = "hourly"
        case dailyData = "daily"
        case timeZoneOffset = "timezone_offset"
    }
    
    init(latitude: Double, longitude: Double, hourlyData: [WeatherHourUI], dailyData: [WeatherDailyUI], timeZoneOffset: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.hourlyData = hourlyData
        self.dailyData = dailyData
        self.timeZoneOffset = timeZoneOffset
    }
    
    init(weatherHourly: WeatherHourlyDB) {
        self.latitude = weatherHourly.latitude
        self.longitude = weatherHourly.longitude
        self.hourlyData = weatherHourly.hourlyData.toArray().map { WeatherHourUI(weatherHour: $0) }
        self.dailyData = weatherHourly.dailyData.toArray().map { WeatherDailyUI(weatherDaily: $0) }
        self.timeZoneOffset = weatherHourly.timeZoneOffset
    }
}

struct WeatherHourUI {
    let timestamp: Double
    let temperature: Double
    let pressure: Double
    let humidity: Int
    let dewPoint: Double
    let clouds: Int
    let windSpeed: Double
    let windDegree: Double
    let weather: [WeatherDescriptionUI]
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
    
    init(timestamp: Double, temperature: Double, pressure: Double, humidity: Int, dewPoint: Double, clouds: Int, windSpeed: Double, windDegree: Double, weather: [WeatherDescriptionUI], timeZoneOffset: Double?) {
        self.timestamp = timestamp
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.clouds = clouds
        self.windSpeed = windSpeed
        self.windDegree = windDegree
        self.weather = weather
        self.timeZoneOffset = timeZoneOffset
    }
    
    init(weatherHour: WeatherHourDB) {
        self.timestamp = weatherHour.timestamp
        self.temperature = weatherHour.temperature
        self.pressure = weatherHour.pressure
        self.humidity = weatherHour.humidity
        self.dewPoint = weatherHour.dewPoint
        self.clouds = weatherHour.clouds
        self.windSpeed = weatherHour.windSpeed
        self.windDegree = weatherHour.windDegree
        
        self.weather = weatherHour.weather.toArray().map { WeatherDescriptionUI(weatherDescription: $0) }
        self.timeZoneOffset = weatherHour.timeZoneOffset
    }
}


struct WeatherDailyUI {
    let timestamp: Double
    let sunrise: Double
    let sunset: Double
    let weather: [WeatherDescriptionUI]
    let clouds: Int
    
    private enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case weather = "weather"
        case clouds = "clouds"
    }
    
    init(timestamp: Double, sunrise: Double, sunset: Double, weather: [WeatherDescriptionUI], clouds: Int) {
        self.timestamp = timestamp
        self.sunrise = sunrise
        self.sunset = sunset
        self.weather = weather
        self.clouds = clouds
    }
    
    init(weatherDaily: WeatherDailyDB) {
        self.timestamp = weatherDaily.timestamp
        self.sunrise = weatherDaily.sunrise
        self.sunset = weatherDaily.sunset
        
        self.weather = weatherDaily.weather.toArray().map { WeatherDescriptionUI(weatherDescription: $0) }
        self.clouds = weatherDaily.clouds
    }
}
