//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Olga on 26.12.2023.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

class NetworkService {
    let weatherData = PublishRelay<WeatherData>()
    let coordinatesData = PublishRelay<CoordinatesData>()
    
    private let apiKey = "396812dbadf97f25c53db5a9b3202a16"
    var units = "metric"
    var part = "daily"
    
    func loadCurrentWeather(location: CLLocation, completion: (()->Void)?) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "appid", value: apiKey)
            
        ]
        guard let url = components.url else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error == nil {
                guard let data = data else { return }
                let json = try! JSONDecoder().decode(WeatherData.self, from: data)
                self.weatherData.accept(json)
                completion?()
            }
        }.resume()
    }
    
    func searchCoordinates(nameCity: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/geo/1.0/direct"
        components.queryItems = [
            URLQueryItem(name: "q", value: nameCity),
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "appid", value: apiKey)
            
        ]
        guard let url = components.url else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error == nil {
                guard let data = data else { return }
                guard let cities = try? JSONDecoder().decode([CoordinatesData].self, from: data) else { return }
                guard let city = cities.first else { return }
                self.coordinatesData.accept(city)
            }
        }.resume()
    }
}

