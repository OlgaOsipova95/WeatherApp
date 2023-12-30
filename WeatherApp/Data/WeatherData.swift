//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Olga on 26.12.2023.
//

import Foundation

struct WeatherData: Codable {
    let list: [WeatherAtTime]
    let city: City
}
struct City: Codable {
    let name: String
}
struct WeatherAtTime: Codable {
    let main: Main
    let clouds: Clouds
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case main, clouds
        case date = "dt_txt"
    }
}

struct Clouds: Codable {
    let all: Int
}
struct Main: Codable {
    let temp: Double
}

extension WeatherData: Sequence {
    func makeIterator() -> WeatherIterator {
        return WeatherIterator(weather: self)
    }
}

struct WeatherIterator: IteratorProtocol {
    let weather: WeatherData
    var currentIndex = 0
    
    mutating func next() -> WeatherAtTime? {
        guard currentIndex < weather.list.count else {
            return nil
        }
        
        let nextItem = weather.list[currentIndex]
        currentIndex += 1
        return nextItem
    }
}
