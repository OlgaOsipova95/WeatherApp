//
//  WeatherDaylyCell.swift
//  WeatherApp
//
//  Created by Olga on 27.12.2023.
//

import Foundation
import SnapKit
import UIKit

class WeatherDaylyCell: UITableViewCell {
    static var identifier: String {"\(Self.self)"}

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize16)
        return label
    }()
    private let cloudsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: Constants.fontSize16)
        return label
    }()
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize16)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUI(date: String, clouds: String, temp: String) {
        dateLabel.text = date
        cloudsLabel.text = clouds
        tempLabel.text = temp
    }
}

extension WeatherDaylyCell {
    func setupConstraints() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(cloudsLabel)
        contentView.addSubview(tempLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(Constants.offset16)
            make.top.equalTo(contentView.snp.top).offset(Constants.offset16)
            make.bottom.equalTo(contentView.snp.bottom).inset(Constants.offset16)
        }
        cloudsLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(Constants.offset16)
            make.top.equalTo(contentView.snp.top).offset(Constants.offset16)
            make.bottom.equalTo(dateLabel.snp.bottom)
        }
        tempLabel.snp.makeConstraints { make in
            make.leading.equalTo(cloudsLabel.snp.trailing).offset(Constants.offset16)
            make.top.equalTo(contentView.snp.top).offset(Constants.offset16)
            make.bottom.equalTo(dateLabel.snp.bottom)
        }

        
    }
}
