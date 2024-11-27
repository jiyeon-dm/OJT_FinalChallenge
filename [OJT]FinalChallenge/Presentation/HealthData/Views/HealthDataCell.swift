//
//  HealthDataCell.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

import SnapKit

final class HealthDataCell: UITableViewCell, Reusable {
    // MARK: - Components
    
    private let timeLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let dataLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .systemTeal
        return label
    }()
    
    private let unitLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.0, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupLayout() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(timeLabel)
        }
        
        contentView.addSubview(dataLabel)
        dataLabel.snp.makeConstraints { make in
            make.trailing.equalTo(unitLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure Methods
    
    func configure(with viewModel: HealthDataCellViewModel) {
        timeLabel.text = "\(viewModel.startDate.formatAsTime()) ~ \(viewModel.endDate.formatAsTime())"
        switch viewModel.data {
        case .category(let sleepAnalysis):
            dataLabel.text = sleepAnalysis.description
        case .quantity(let value):
            dataLabel.text = String(Int(value))
            unitLabel.text = viewModel.type.unitDescription
        }
    }
}

