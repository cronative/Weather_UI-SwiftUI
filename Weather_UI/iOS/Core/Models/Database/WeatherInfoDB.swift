//
//  WeatherInfoDB.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation
import RealmSwift

class WeatherInfoDB: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var coordinates: WeatherCoordinatesDB?
    @Persisted var weather: List<WeatherDescriptionDB>
    
    @Persisted var climateInfo: WeatherMainDB?
    @Persisted var visibility: Int?
    @Persisted var windInfo: WindInfoDB?
    @Persisted var timeStamp: Double
    @Persisted var clouds: CloudInfoDB?
    @Persisted var dayInfo: DayTimeInfoDB?
    @Persisted var timeZone: Double
    @Persisted var cityID: Int
    @Persisted var cityName: String
    @Persisted var order: Int?
    
    
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
    
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(coordinates: WeatherCoordinatesDB, weather: List<WeatherDescriptionDB>, climateInfo: WeatherMainDB, visibility: Int? = nil, windInfo: WindInfoDB, timeStamp: Double, clouds: CloudInfoDB, dayInfo: DayTimeInfoDB, timeZone: Double, cityID: Int, cityName: String, order: Int? = nil) {
        super.init()
        
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
    
    init(weatherInfoNW: WeatherInfoNW) {
        super.init()
        
        self.coordinates = WeatherCoordinatesDB(weatherCoordinatesNW: weatherInfoNW.coordinates)
        
        let weather = weatherInfoNW.weather.map({WeatherDescriptionDB(weatherDescriptionNW: $0)})
        weather.forEach { self.weather.append($0) }
        
        self.climateInfo = WeatherMainDB(weatherMainNW: weatherInfoNW.climateInfo)
        self.visibility = weatherInfoNW.visibility
        self.windInfo = WindInfoDB(windInfoNW: weatherInfoNW.windInfo)
        self.timeStamp = weatherInfoNW.timeStamp
        self.clouds = CloudInfoDB(cloudInfoNW: weatherInfoNW.clouds)
        self.dayInfo = DayTimeInfoDB(dayTimeInfoNW: weatherInfoNW.dayInfo)
        self.timeZone = weatherInfoNW.timeZone
        self.cityID = weatherInfoNW.cityID
        self.cityName = weatherInfoNW.cityName
        self.order = weatherInfoNW.order
    }
}


class WeatherCoordinatesDB: Object {
    @Persisted var longitude: Double
    @Persisted var latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(longitude: Double, latitude: Double) {
        super.init()
        
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(weatherCoordinatesNW: WeatherCoordinatesNW) {
        super.init()
        
        self.latitude = weatherCoordinatesNW.latitude
        self.longitude = weatherCoordinatesNW.longitude
    }
}


class WeatherDescriptionDB: Object {
    @Persisted var id: Int
    
    @Persisted var main: String
    @Persisted var weatherDescription: String
    @Persisted var icon: String
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(id: Int, main: String, weatherDescription: String, icon: String) {
        super.init()
        
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
    
    init(weatherDescriptionNW: WeatherDescriptionNW) {
        super.init()
        
        self.id = weatherDescriptionNW.id
        self.main = weatherDescriptionNW.main
        self.weatherDescription = weatherDescriptionNW.description
        self.icon = weatherDescriptionNW.icon
    }
}


class WeatherMainDB: Object {
    @Persisted var temperature: Double
    @Persisted var precipitation: Double
    @Persisted var minTemperature: Double
    @Persisted var maxTemperature: Double
    @Persisted var airPressure: Double
    @Persisted var humidity: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case precipitation = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case airPressure = "pressure"
        case humidity = "humidity"
    }
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(temperature: Double, precipitation: Double, minTemperature: Double, maxTemperature: Double, airPressure: Double, humidity: Double) {
        super.init()
        
        self.temperature = temperature
        self.precipitation = precipitation
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.airPressure = airPressure
        self.humidity = humidity
    }
    
    init(weatherMainNW: WeatherMainNW) {
        super.init()
        
        self.temperature = weatherMainNW.temperature
        self.precipitation = weatherMainNW.precipitation
        self.minTemperature = weatherMainNW.minTemperature
        self.maxTemperature = weatherMainNW.maxTemperature
        self.airPressure = weatherMainNW.airPressure
        self.humidity = weatherMainNW.humidity
    }
}

class WindInfoDB: Object {
    @Persisted var speed: Double
    @Persisted var degree: Double?
    
    private enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case degree = "deg"
    }
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(speed: Double, degree: Double? = nil) {
        super.init()
        
        self.speed = speed
        self.degree = degree
    }
    
    init(windInfoNW: WindInfoNW) {
        super.init()
        
        self.speed = windInfoNW.speed
        self.degree = windInfoNW.degree
    }
}


class DayTimeInfoDB: Object {
    @Persisted var countryCode: String
    @Persisted var sunriseTime: Double
    @Persisted var sunsetTime: Double
    
    private enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
    }
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(countryCode: String, sunriseTime: Double, sunsetTime: Double) {
        super.init()
        
        self.countryCode = countryCode
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
    
    init(dayTimeInfoNW: DayTimeInfoNW) {
        super.init()
        
        self.countryCode = dayTimeInfoNW.countryCode
        self.sunriseTime = dayTimeInfoNW.sunriseTime
        self.sunsetTime = dayTimeInfoNW.sunsetTime
    }
}

class CloudInfoDB: Object {
    @Persisted var cloudPercentage: Double
    
    private enum CodingKeys: String, CodingKey {
        case cloudPercentage = "all"
    }
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(cloudPercentage: Double) {
        super.init()
        
        self.cloudPercentage = cloudPercentage
    }
    
    init(cloudInfoNW: CloudInfoNW) {
        super.init()
        
        self.cloudPercentage = cloudInfoNW.cloudPercentage
    }
}

////Hourly Data
class WeatherHourlyDB: Object {
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var hourlyData: List<WeatherHourDB>
    @Persisted var dailyData: List<WeatherDailyDB>
    @Persisted var timeZoneOffset: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case hourlyData = "hourly"
        case dailyData = "daily"
        case timeZoneOffset = "timezone_offset"
    }
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(latitude: Double, longitude: Double, hourlyData: List<WeatherHourDB>, dailyData: List<WeatherDailyDB>, timeZoneOffset: Double) {
        super.init()
        
        self.latitude = latitude
        self.longitude = longitude
        self.hourlyData = hourlyData
        self.dailyData = dailyData
        self.timeZoneOffset = timeZoneOffset
    }
    
    init(weatherHourlyNW: WeatherHourlyNW) {
        super.init()
        
        self.latitude = weatherHourlyNW.latitude
        self.longitude = weatherHourlyNW.longitude

        
        let hourlyData = weatherHourlyNW.hourlyData.map({WeatherHourDB(weatherHourNW: $0)})
        hourlyData.forEach { self.hourlyData.append($0) }

        let dailyData = weatherHourlyNW.dailyData.map({WeatherDailyDB(weatherDailyNW: $0)})
        dailyData.forEach { self.dailyData.append($0) }
        
        self.timeZoneOffset = weatherHourlyNW.timeZoneOffset
    }
}

class WeatherHourDB: Object {
    @Persisted var timestamp: Double
    @Persisted var temperature: Double
    @Persisted var pressure: Double
    @Persisted var humidity: Int
    @Persisted var dewPoint: Double
    @Persisted var clouds: Int
    @Persisted var windSpeed: Double
    @Persisted var windDegree: Double
    
    @Persisted var weather: List<WeatherDescriptionDB>
    @Persisted var timeZoneOffset: Double?
    
    lazy var timeZoneDifference: Double? = {
        guard var timeZoneOffset = timeZoneOffset else { return 0 }
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
    
    // MARK: - Inits
    override required init() {
        super.init()
    }
    
    init(timestamp: Double, temperature: Double, pressure: Double, humidity: Int, dewPoint: Double, clouds: Int, windSpeed: Double, windDegree: Double, weather: List<WeatherDescriptionDB>, timeZoneOffset: Double? = nil) {
        super.init()
        
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
    
    init(weatherHourNW: WeatherHourNW) {
        super.init()
        
        self.timestamp = weatherHourNW.timestamp
        self.temperature = weatherHourNW.temperature
        self.pressure = weatherHourNW.pressure
        self.humidity = weatherHourNW.humidity
        self.dewPoint = weatherHourNW.dewPoint
        self.clouds = weatherHourNW.clouds
        self.windSpeed = weatherHourNW.windSpeed
        self.windDegree = weatherHourNW.windDegree
        
        let weather = weatherHourNW.weather.map({WeatherDescriptionDB(weatherDescriptionNW: $0)})
        weather.forEach { self.weather.append($0) }

        self.timeZoneOffset = weatherHourNW.timeZoneOffset
    }
}


class WeatherDailyDB: Object {
    @Persisted var timestamp: Double
    @Persisted var sunrise: Double
    @Persisted var sunset: Double
    @Persisted var weather: List<WeatherDescriptionDB>
    @Persisted var clouds: Int
    
    private enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case weather = "weather"
        case clouds = "clouds"
    }
    
    override required init() {
        super.init()
    }
    
    init(timestamp: Double, sunrise: Double, sunset: Double, weather: List<WeatherDescriptionDB>, clouds: Int) {
        super.init()

        self.timestamp = timestamp
        self.sunrise = sunrise
        self.sunset = sunset
        self.weather = weather
        self.clouds = clouds
    }
    
    
    init(weatherDailyNW: WeatherDailyNW) {
        super.init()
        
        self.timestamp = weatherDailyNW.timestamp
        self.sunrise = weatherDailyNW.sunrise
        self.sunset = weatherDailyNW.sunset
        
        let weather = weatherDailyNW.weather.map({WeatherDescriptionDB(weatherDescriptionNW: $0)})
        weather.forEach { self.weather.append($0) }
        
        self.clouds = weatherDailyNW.clouds
    }
}

