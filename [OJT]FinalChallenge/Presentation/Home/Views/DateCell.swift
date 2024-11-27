//
//  DateCell.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

final class DateCell: UICollectionViewCell, Reusable {
    // MARK: - Components
    
    private let dayOfTheWeekLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .init(25.0), weight: .heavy)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        contentView.addSubview(dayOfTheWeekLabel)
        dayOfTheWeekLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Configure Methods
    
    func configure(with viewModel: DateCellViewModel) {
        dayOfTheWeekLabel.text = viewModel.dayOfTheWeek
        dateLabel.text = viewModel.date
        updateTextColor(viewModel.isSelected ? .white : .systemGray3)
    }
    
    private func updateTextColor(_ color: UIColor) {
        dayOfTheWeekLabel.textColor = color
        dateLabel.textColor = color
    }
}
