//
//  HomeView.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

import FSCalendar

final class HomeView: UIView {
    // MARK: Components
    
    let calendarView = CalendarView()
    
    let calendar = {
        let view = FSCalendar()
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.headerDateFormat = "YYYY년 MM월"
        view.appearance.headerTitleColor = .systemTeal
        view.appearance.headerTitleFont = .systemFont(ofSize: 15.0, weight: .bold)
        view.appearance.weekdayTextColor = .black
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let healthDataButtonStackView = HealthDataButtonStackView()
    
    private let containerView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let timerImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        imageView.image = UIImage(systemName: "timer", withConfiguration: configuration)
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let timerLabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    let locationCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: LocationCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
        
        addSubview(healthDataButtonStackView)
        healthDataButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(healthDataButtonStackView.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(3)
            make.center.equalToSuperview()
        }
        
        containerView.addSubview(timerImageView)
        timerImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.leading.equalTo(timerImageView.snp.trailing).offset(5)
            make.centerY.equalTo(timerImageView)
        }
        
        containerView.addSubview(locationCollectionView)
        locationCollectionView.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}
