//
//  HealthDataView.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

final class HealthDataView: UIView {
    // MARK: - Components
    
    let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    let descriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    let tableView = {
        let tableView = UITableView()
        tableView.register(cellType: HealthDataCell.self)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 44.0
        return tableView
    }()
    
    let emptyLabel = {
        let label = UILabel()
        label.text = "데이터가 없습니다"
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().inset(20)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(dateLabel)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
