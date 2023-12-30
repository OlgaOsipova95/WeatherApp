//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Olga on 28.12.2023.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class SearchCityViewController: UIViewController {
    private let viewModel = SearchCityViewModel()
    private let disposeBag = DisposeBag()
    private let searchCityTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.textColor = .black
        view.placeholder = "Введите название города"
        view.layer.masksToBounds = true
        return view
    }()
    let didFoundCoordinates = PublishRelay<CoordinatesData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupObservers()
    }
    
    func setupObservers() {
        searchCityTextField.rx.controlEvent(.editingDidEndOnExit).asObservable().subscribe { _ in
            guard let text = self.searchCityTextField.text else { return }
            self.viewModel.searchCoordinates(nameCity: text)
        }.disposed(by: disposeBag)
        
        viewModel.coordinatesData.subscribe { event in
            DispatchQueue.main.async {
                guard let element = event.element else { return }
                self.didFoundCoordinates.accept(element)
                self.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: disposeBag)
    }
}

extension SearchCityViewController {
    func setupConstraints() {
        view.addSubview(searchCityTextField)
        searchCityTextField.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(Constants.offset16)
            make.trailing.equalTo(view.snp.trailing).inset(Constants.offset16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.offset16)
            make.height.equalTo(searchCityTextField.snp.width).multipliedBy(0.2)
            
        }
    }
}
