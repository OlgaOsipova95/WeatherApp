
//
//  CurrentWeatherCell.swift
//  WeatherApp
//
//  Created by Olga on 27.12.2023.
//

import Foundation
import SnapKit
import UIKit

class CurrentWeatherCell: UITableViewCell {
    static var identifier: String {"\(Self.self)"}

    private let nameCityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "City"
        return label
    }()
    private let currentTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "- -"
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(nameCity: String, currentTemp: String) {
        nameCityLabel.text = nameCity
        currentTempLabel.text = String(currentTemp)
    }
}

extension CurrentWeatherCell {
    func setupConstraints() {
        contentView.addSubview(nameCityLabel)
        contentView.addSubview(currentTempLabel)
        nameCityLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(Constants.offset16)
            make.top.equalTo(contentView.snp.top).offset(Constants.offset16)
            make.bottom.equalTo(contentView.snp.bottom).inset(Constants.offset16)
        }
        currentTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameCityLabel.snp.trailing).offset(Constants.offset32)
            make.top.equalTo(nameCityLabel.snp.top)
            make.bottom.equalTo(nameCityLabel.snp.bottom)
        }
    }
}
