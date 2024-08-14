//
//  City.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation

struct CityData: Decodable {
    let data: [CityInfoNW]
}

struct CityInfoNW: Decodable, Hashable {    
    let city: String
    let name: String
    let country: String
    let countryCode: String
    let region: String
    let regionCode: String
    let latitude: Double
    let longitude: Double
}
