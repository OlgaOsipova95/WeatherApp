//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Olga on 26.12.2023.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class WeatherViewModel {
    var locationDisposable: Disposable? = nil
    let disposeBag = DisposeBag()
    let networkService = NetworkService()
    var locationService = LocationService()
    var weatherData = PublishRelay<[WeatherAtTime]>()
    var weatherDataObservable: Observable<[WeatherAtTime]> {
        return weatherData.asObservable()
    }
    var currentLocation = PublishRelay<CLLocation>()
    var cityName = ""
    
    init() {
        locationDisposable = locationService.location.subscribe { event in
            guard let location = event.element else { return }
            self.showWeather(location: location)
        }
        networkService.weatherData.subscribe { event in
            self.cityName = event.element?.city.name ?? ""
            let weatherByDay = event.element?.list.filter({ $0.date.contains("12:00")})
            self.weatherData.accept(weatherByDay ?? [])
        }.disposed(by: disposeBag)
    }
    func showWeather(location: CLLocation) {
        networkService.loadCurrentWeather(location: location, completion: nil)
    }
    func showWeather(lat: Double, lon: Double) {
        locationDisposable?.dispose()
        networkService.loadCurrentWeather(location: CLLocation(latitude: lat, longitude: lon), completion: nil)
    }
}
