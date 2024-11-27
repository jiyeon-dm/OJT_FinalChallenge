//
//  HomeViewController.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Combine
import UIKit

import FSCalendar

protocol HomeViewControllerDelegate: AnyObject {
    func didTapHealthDataButton(dataType: HealthDataType, date: Date)
}

final class HomeViewController: UIViewController {
    weak var delegate: HomeViewControllerDelegate?
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dateDataSource: UICollectionViewDiffableDataSource<Int, DateCellViewModel>!
    private var locationDataSource: UICollectionViewDiffableDataSource<Int, LocationCellViewModel>!
    
    // MARK: - Components
    
    private let homeView = HomeView()
    
    // MARK: - Init
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateCollectionView()
        setupLocationCollectionView()
        setupCalendar()
        setupBindings()
        viewModel.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Setup Methods
    
    private func setupDateCollectionView() {
        dateCollectionView.delegate = self
        
        dateDataSource = .init(
            collectionView: dateCollectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: DateCell.self
                )
                cell.configure(with: cellViewModel)
                return cell
        })
    }
    
    private func setupLocationCollectionView() {
        locationCollectionView.delegate = self
        
        locationDataSource = .init(
            collectionView: locationCollectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: LocationCell.self
                )
                cell.configure(with: cellViewModel)
                return cell
            })
    }
    
    private func setupCalendar() {
        calendar.delegate = self
    }
    
    private func setupBindings() {
        // action
        calendarButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.send(.didTapCalendarButton)
            }.store(in: &cancellables)
        
        todayButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.send(.didTapTodayButton)
            }
            .store(in: &cancellables)
        
        stepCountButton.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                delegate?.didTapHealthDataButton(
                    dataType: .stepCount,
                    date: viewModel.state.selectedDate.value
                )
            }
            .store(in: &cancellables)
        
        distanceButton.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                delegate?.didTapHealthDataButton(
                    dataType: .distance,
                    date: viewModel.state.selectedDate.value
                )
            }
            .store(in: &cancellables)
        
        sleepAnalysisButton.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                delegate?.didTapHealthDataButton(
                    dataType: .sleepAnalysis,
                    date: viewModel.state.selectedDate.value
                )
            }
            .store(in: &cancellables)
        
        heartRateButton.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                delegate?.didTapHealthDataButton(
                    dataType: .heartRate,
                    date: viewModel.state.selectedDate.value
                )
            }
            .store(in: &cancellables)
        
        // State
        viewModel.state.selectedDate
            .sink { [weak self] selectedDate in
                guard let self = self else { return }
                calendarView.updateSelectedDate(selectedDate)
                calendar.select(selectedDate)
            }
            .store(in: &cancellables)
        
        viewModel.state.isTodayButtonEnabled
            .sink { [weak self] isEnabled in
                self?.todayButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        viewModel.state.dateCellViewModels
            .sink { [weak self] cellViewModels in
                self?.applySanpshot(with: cellViewModels)
            }
            .store(in: &cancellables)
        
        viewModel.state.selectedDateIndex
            .sink { [weak self] index in
                self?.moveToItem(at: index)
            }
            .store(in: &cancellables)
        
        viewModel.state.isCalendarHidden
            .sink { [weak self] isHidden in
                self?.calendar.isHidden = isHidden
            }
            .store(in: &cancellables)
        
        viewModel.state.locationCellViewModels
            .sink { [weak self] cellViewModels in
                self?.applySanpshot(with: cellViewModels)
            }
            .store(in: &cancellables)
        
        viewModel.state.secondsElapsed
            .sink { [weak self] seconds in
                self?.timerLabel.text = String(seconds)
            }
            .store(in: &cancellables)
        
        viewModel.state.locationErrorMessage
            .sink { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func applySanpshot(with dateCellViewModels: [DateCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DateCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(dateCellViewModels, toSection: 0)
        dateDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySanpshot(with locationCellViewModels: [LocationCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, LocationCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(locationCellViewModels, toSection: 0)
        locationDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func moveToItem(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.dateCollectionView.scrollToItem(
                at: indexPath,
                at: .right,
                animated: false
            )
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // 뷰 터치 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: view) // 터치 발생 위치
        let touchedView = view.hitTest(touchLocation, with: event) // 터치가 발생한 뷰
        
        if touchedView != calendarView {
            calendar.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == dateCollectionView {
            return CGSize(width: Constants.cellWidth, height: 65.0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 55.0)
        }
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == dateCollectionView else {
            return
        }
        viewModel.send(.didSelectDateCollectionViewCell(indexPath.row))
    }
    
    // 스크롤이 끝났을 때(감속이 완전히 멈췄을 때) 선택된 셀 업데이트
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView,
              collectionView == dateCollectionView else {
            return
        }
        let rightEdgeX = scrollView.contentOffset.x + scrollView.bounds.width
        print(rightEdgeX / Constants.cellWidth)
        let estimatedIndex = Int(ceil(rightEdgeX / Constants.cellWidth)) - 1
        print(estimatedIndex)
        viewModel.send(.didSelectDateCollectionViewCell(estimatedIndex))
    }
}

// MARK: - FSCalendarDelegate

extension HomeViewController: FSCalendarDelegate, FSCalendarDelegateAppearance {
    // 날짜 선택
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        viewModel.send(.didSelectFSCalendarCell(date))
    }
    
    // 주말 색상 변경
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        let currentPage = calendar.currentPage
        let calendar = Calendar.current
        
        // 이번 달인지 확인
        if calendar.isDate(date, equalTo: currentPage, toGranularity: .month) {
            let components = calendar.component(.weekday, from: date)
            // 토요일 또는 일요일일 경우 색상 변경
            if components == 7 || components == 1 {
                return UIColor.red
            }
        }
        return nil // 평일은 기본 색상 유지
    }
}

private extension HomeViewController {
    var calendarView: CalendarView {
        homeView.calendarView
    }
    
    var calendarButton: UIButton {
        homeView.calendarView.calendarButton
    }
    
    var todayButton: UIButton {
        homeView.calendarView.todayButton
    }
    
    var dateCollectionView: UICollectionView {
        homeView.calendarView.dateCollectionView
    }
    
    var calendar: FSCalendar {
        homeView.calendar
    }
    
    var stepCountButton: UIButton {
        homeView.healthDataButtonStackView.stepCountButton
    }
    
    var distanceButton: UIButton {
        homeView.healthDataButtonStackView.distanceButton
    }
    
    var sleepAnalysisButton: UIButton {
        homeView.healthDataButtonStackView.sleepAnalysisButton
    }
    
    var heartRateButton: UIButton {
        homeView.healthDataButtonStackView.heartRateButton
    }
    
    var locationCollectionView: UICollectionView {
        homeView.locationCollectionView
    }
    
    var timerLabel: UILabel {
        homeView.timerLabel
    }
}
