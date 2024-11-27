//
//  CalenderView.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

import SnapKit

final class CalendarView: UIView {
    // MARK: - Components
    
    let yearMonthLabelView = YearMonthLabelView()
    
    let calendarButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var todayButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(
            string: "오늘",
            attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .bold)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(image(with: .systemTeal), for: .normal)
        button.setBackgroundImage(image(with: .systemGray4), for: .disabled)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let dateCollectionView = {
        let layout = CalendarLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: DateCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let selectedDateIndicator = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15.0
    }
    
    private func setupLayout() {
        addSubview(yearMonthLabelView)
        yearMonthLabelView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview().inset(30)
            make.leading.equalToSuperview().inset(40)
        }
        
        addSubview(calendarButton)
        calendarButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.leading.equalTo(yearMonthLabelView.snp.trailing)
            make.centerY.equalTo(yearMonthLabelView)
        }
        
        addSubview(todayButton)
        todayButton.snp.makeConstraints { make in
            make.width.equalTo(Constants.cellWidth)
            make.height.equalTo(40)
            make.trailing.equalToSuperview().inset(40)
            make.centerY.equalTo(yearMonthLabelView)
        }
        
        addSubview(selectedDateIndicator)
        selectedDateIndicator.snp.makeConstraints { make in
            make.width.equalTo(Constants.cellWidth)
            make.height.equalTo(65)
            make.bottom.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(40)
        }
        
        addSubview(dateCollectionView)
        dateCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(65)
            make.bottom.trailing.equalTo(selectedDateIndicator)
        }
    }
    
    // MARK: - Configure Methods
    
    func updateSelectedDate(_ date: Date) {
        yearMonthLabelView.configure(with: date)
    }
}

private final class CalendarLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }
        
        let cellWidth: CGFloat = Constants.cellWidth
        // 가장 가까운 셀
        let currentCell = proposedContentOffset.x / cellWidth
        // 정확한 셀을 찾기 위해 올림 또는 내림
        var targetCell: CGFloat
        if abs(velocity.x) > 0.3 {
            targetCell = velocity.x < 0 ? floor(currentCell) - 1 : ceil(currentCell)
        } else {
            targetCell = round(currentCell)
        }
        // 최종 x 위치 계산
        let targetX = targetCell * cellWidth
        // bounds를 벗어나지 않도록 제한
        let minX: CGFloat = 0
        let maxX = collectionView.contentSize.width - collectionView.bounds.width
        let boundedX = max(minX, min(maxX, targetX))
        
        return CGPoint(x: boundedX, y: proposedContentOffset.y)
    }
}
