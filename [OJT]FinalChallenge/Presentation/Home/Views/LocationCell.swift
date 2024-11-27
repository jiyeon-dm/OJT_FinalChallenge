//
//  LocationCell.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

import SnapKit

final class LocationCell: UICollectionViewCell, Reusable {
    // MARK: - Components
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        return stackView
    }()
    
    private lazy var indexLabel = createLabel(
        with: .systemFont(ofSize: 12.0, weight: .bold),
        color: .systemGray3
    )
    
    private lazy var dateLabel = createLabel(
        with: .systemFont(ofSize: 12.0, weight: .bold),
        color: .systemGray3
    )
    
    private lazy var timeLabel = createLabel(
        with: .systemFont(ofSize: 12.0, weight: .heavy),
        color: .systemTeal
    )
    
    private lazy var locationLabel = createLabel(
        with: .systemFont(ofSize: 12.0, weight: .bold),
        color: .systemGray3
    )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupCell() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8.0
    }
    
    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        [indexLabel, dateLabel, timeLabel, locationLabel, UIView()].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - Configure Methods
    
    func configure(with viewModel: LocationCellViewModel) {
        indexLabel.text = "(\(viewModel.index))"
        dateLabel.text = viewModel.date
        timeLabel.text = viewModel.time
        locationLabel.text = "(\(viewModel.latitude), \(viewModel.longtitude))"
    }
}

private extension LocationCell {
    func createLabel(with font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        return label
    }
}
