//
//  YearMonthLabelView.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

import SnapKit

final class YearMonthLabelView: UIView {
    // MARK: - Components
    
    private lazy var yearLabel = createLargeLabel()
    
    private lazy var yearSuffixLabel = createLabel(with: "년")
    
    private lazy var monthLabel = createLargeLabel()
    
    private lazy var monthSuffixLabel = createLabel(with: "월")
    
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
        addSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        addSubview(yearSuffixLabel)
        yearSuffixLabel.snp.makeConstraints { make in
            make.leading.equalTo(yearLabel.snp.trailing)
            make.bottom.equalTo(yearLabel).offset(-3)
        }
        
        addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(yearSuffixLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        addSubview(monthSuffixLabel)
        monthSuffixLabel.snp.makeConstraints { make in
            make.leading.equalTo(monthLabel.snp.trailing)
            make.bottom.equalTo(monthLabel).offset(-3)
            make.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Configure Methods
    
    func configure(with date: Date) {
        yearLabel.text = date.formatAsYear()
        monthLabel.text = date.formatAsMonth()
    }
}

private extension YearMonthLabelView {
    func createLargeLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25.0, weight: .heavy)
        label.textColor = .label
        return label
    }
    
    func createLabel(with text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .label
        return label
    }
}
