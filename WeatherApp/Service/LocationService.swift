//
//  LocationService.swift
//  WeatherApp
//
//  Created by Olga on 27.12.2023.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

final class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    let location = PublishRelay<CLLocation>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location.accept(location)
    }
}
