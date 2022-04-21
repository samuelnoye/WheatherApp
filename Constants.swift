//
//  Constants.swift
//  WheatherApp
//
//  Created by Samuel Noye on 21/04/2022.
//

import Foundation

struct WeatherUrl {
    private let baseUrl = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
    private let key = "&key=9ff3d6d434ca4c9d8fb120254222104"
    private let numDaysForecast = "&num_of_days=1"
    private let format  = "&format=json"
    
    private var coorStr = ""
    
    init (lat: String, long: String) {
        self.coorStr = "?q=\(lat),\(long)"
    }
    
    func getFullUrl () -> String {
        return baseUrl + coorStr + key + numDaysForecast + format
    }
     
}
struct SkinType {
    let type1 = "Type 1 - Pale / Light"
    let type2 = "Type 2 - White / Fair"
    let type3 = "Type 3 - Mdeium / Light"
    let type4 = "Type 4 - Olive Brown"
    let type5 = "Type 5 - Dark Brown"
    let type6 = "Type 6 - Very Dark / Black"
}
struct defualtkeys {
    static let skinType = "skinType"
}
