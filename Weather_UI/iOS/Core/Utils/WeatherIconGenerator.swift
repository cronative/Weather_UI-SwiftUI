//
//  Weather.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation
import UIKit


struct WeatherIconGenerator {
    
    let weatherIcons: [String: String] = ["01d" : "sun.max.fill", "01n" : "moon.circle", "02d" : "cloud.sun.fill", "02n" : "cloud.moon.fill", "03d" : "cloud.fill", "03n" : "cloud.fill", "04d" : "smoke.fill", "04n" : "smoke.fill", "09d" : "cloud.drizzle.fill", "09n" : "cloud.drizzle.fill", "10d" : "cloud.sun.rain.fill", "10n" : "cloud.moon.rain.fill", "11d" : "cloud.sun.bolt.fill", "11n" : "cloud.moon.bolt.fill", "13d" : "snow", "13n" : "snow", "50d": "sun.haze.fill", "50n" : "wind"]
    
    static func imageContrastCheck(backgroundImage: UIImage) -> Bool{
        if (backgroundImage.description.contains("evening") || backgroundImage.description.contains("night")){
            return false
        } else {
            return true
        }
    }
    
    static func configurationForCity(weatherIcon: String) -> (String,String) {
        if (weatherIcon == "01d") {
            return ("sunnyMorning","sun.max.fill")
        } else if (weatherIcon == "01n") {
            return ("nightClear", "moon.circle")
        } else if (weatherIcon == "02d") {
            return ("sunnyCloudy", "cloud.sun.fill")
        } else if (weatherIcon == "02n") {
            return ("nightCloudy", "cloud.moon.fill")
        } else if (weatherIcon == "03d") {
            return ("sunnyCloudy", "cloud.fill")
        }  else if (weatherIcon == "03n") {
            return ("nightLate", "cloud.fill")
        }  else if (weatherIcon == "04d") {
            return ("sunnyCloudy", "smoke.fill")
        } else if (weatherIcon == "04n") {
            return ("nightLate", "smoke.fill")
        } else if (weatherIcon == "09d") {
            return ("rainCloudy", "cloud.drizzle.fill")
        } else if (weatherIcon == "09n") {
            return ("nightCloudy", "cloud.drizzle.fill")
        } else if (weatherIcon == "10d") {
            return ("rainCloudy", "cloud.sun.rain.fill")
        } else if (weatherIcon == "10n") {
            return ("nightClear", "cloud.moon.rain.fill")
        } else if (weatherIcon == "11d") {
            return ("sunnyCloudy", "cloud.sun.bolt.fill")
        } else if (weatherIcon == "11n") {
            return ("nightCloudy", "cloud.moon.bolt.fill")
        } else if (weatherIcon == "13d" || weatherIcon == "13n") {
            return ("sunnyClear", "snow")
        } else if (weatherIcon == "50d") {
            return ("sunnyClear", "sun.haze.fill")
        } else {
            return ("eveningClear", "wind")
        }
    }
    
    static func convertToFahrenheit(celcius: Double) -> Double {
        return round((celcius * 9/5) + 32)
    }
    
}
