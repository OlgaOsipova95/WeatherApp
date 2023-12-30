//
//  SearchCityViewModel.swift
//  WeatherApp
//
//  Created by Olga on 29.12.2023.
//

import Foundation
import RxCocoa
import RxSwift

class SearchCityViewModel {
    let disposeBag = DisposeBag()
    let networkService = NetworkService()
    let coordinatesData = PublishRelay<CoordinatesData>()
    
    init() {
        networkService.coordinatesData.subscribe { event in
            self.coordinatesData.accept(event)
        }
    }
    
    func searchCoordinates(nameCity: String) {
        networkService.searchCoordinates(nameCity: nameCity)
    }
    
    
}
