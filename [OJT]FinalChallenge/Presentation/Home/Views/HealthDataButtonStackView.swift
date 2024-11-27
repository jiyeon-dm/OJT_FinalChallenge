//
//  HealthDataButtonStackView.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

final class HealthDataButtonStackView: UIStackView {
    // MARK: - Components
    
    lazy var stepCountButton = createButton(with: .stepCount)
    
    lazy var distanceButton = createButton(with: .distance)
    
    lazy var sleepAnalysisButton = createButton(with: .sleepAnalysis)
    
    lazy var heartRateButton = createButton(with: .heartRate)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        axis = .horizontal
        spacing = 10.0
        distribution = .fillEqually
    }
    
    private func setupLayout() {
        [stepCountButton, distanceButton, sleepAnalysisButton, heartRateButton].forEach {
            addArrangedSubview($0)
        }
    }
}

private extension HealthDataButtonStackView {
    func createButton(with dateType: HealthDataType) -> UIButton {
        let button = UIButton()
        let attributedTitle = NSAttributedString(
            string: dateType.description,
            attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 8
        return button
    }
}
