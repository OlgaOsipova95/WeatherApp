//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Olga on 26.12.2023.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import SnapKit

class WeatherViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = .leastNonzeroMagnitude
        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
        tableView.register(WeatherDaylyCell.self, forCellReuseIdentifier: WeatherDaylyCell.identifier)
        return tableView
    }()
    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let searchCityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()
    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    var coordinates = PublishRelay<CoordinatesData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        bind()
    }
    
    func bind() {
        viewModel.weatherDataObservable
            .bind(to: tableView.rx.items) { tableView, row, element  in
                if row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.identifier) as! CurrentWeatherCell
                    
                    cell.configureUI(nameCity: self.viewModel.cityName, currentTemp: String(element.main.temp))
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDaylyCell.identifier) as! WeatherDaylyCell
                    cell.configureUI(date: element.date, clouds: String(element.clouds.all), temp: String(element.main.temp))
                    return cell
                }
            }.disposed(by: disposeBag)
        
        searchCityButton.rx.tap.bind {
            let searchCityVC = SearchCityViewController()
            searchCityVC.didFoundCoordinates.subscribe { event in
                guard let element = event.element else { return }
                self.viewModel.showWeather(lat: element.lat, lon: element.lon)
            }.disposed(by: self.disposeBag)
            self.navigationController?.pushViewController(searchCityVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
}


extension WeatherViewController {
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(searchCityButton)
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
        }
        footerView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(footerView.snp.width).multipliedBy(0.2)
        }
        searchCityButton.snp.makeConstraints { make in
            make.trailing.equalTo(footerView.snp.trailing).inset(Constants.offset16)
            make.top.equalTo(footerView.snp.top).offset(Constants.offset16)
            make.bottom.equalTo(footerView.snp.bottom).inset(Constants.offset16)
            make.width.equalTo(searchCityButton.snp.height)
        }
    }
}
