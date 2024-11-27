//
//  HomeViewModel.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Combine
import CoreLocation
import Foundation

final class HomeViewModel {
    
    // MARK: - Enum, State
    
    enum Action {
        case viewDidLoad
        case didSelectDateCollectionViewCell(Int)
        case didSelectFSCalendarCell(Date)
        case didTapTodayButton
        case didTapCalendarButton
    }
    
    struct State {
        let selectedDate = CurrentValueSubject<Date, Never>(Date())
        let isTodayButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        let dateCellViewModels = CurrentValueSubject<[DateCellViewModel], Never>([])
        let selectedDateIndex = CurrentValueSubject<Int, Never>(0)
        let isCalendarHidden = CurrentValueSubject<Bool, Never>(true)
        let secondsElapsed = CurrentValueSubject<Int, Never>(0)
        let locationCellViewModels = PassthroughSubject<[LocationCellViewModel], Never>()
        let locationErrorMessage = PassthroughSubject<String, Never>()
    }
    
    // MARK: - Properties
    
    private let calendar = Calendar.current
    private var generatedDates: [Date] = []
    private var timer: Timer?
    
    private var actionPublisher = PassthroughSubject<Action, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let calendarDateGenerator: CalendarDateGenerator
    private let healthKitManager: HealthKitManager
    private let backgroundTaskManager: BackgroundTaskManager
    private let locationManager: LocationManager
    
    var state: State
    
    // MARK: - Init
    
    init(
        calendarDateGenerator: CalendarDateGenerator,
        healthKitManager: HealthKitManager,
        backgroundTaskManager: BackgroundTaskManager,
        locationManager: LocationManager
    ) {
        self.calendarDateGenerator = calendarDateGenerator
        self.healthKitManager = healthKitManager
        self.backgroundTaskManager = backgroundTaskManager
        self.locationManager = locationManager
        self.state = State()
        
        setupBindings()
        bindAction()
    }
    
    deinit {
        stopTracking()
    }
    
    // MARK: - Setup Bindings
    
    private func setupBindings() {
        state.selectedDate
            .sink { [weak self] _ in
                self?.updateDateCellViewModels()
                self?.updateTodayButtonState()
            }
            .store(in: &cancellables)
    }
    
    private func bindAction() {
        actionPublisher.sink { [weak self] action in
            self?.handleAction(action)
        }
        .store(in: &cancellables)
    }
    
    private func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            initialize()
        case .didSelectDateCollectionViewCell(let index):
            didSelectCell(index)
        case .didSelectFSCalendarCell(let date):
            didSelectDate(date)
        case .didTapTodayButton:
            didTapTodayButton()
        case .didTapCalendarButton:
            didTapCalendarButton()
        }
    }
    
    // MARK: - Helper Methods
    
    private func initialize() {
        updateDateCellViewModels()
        updateTodayButtonState()
        updateSelectedDateIndex(date: Date())
        healthKitManager.requestAuthorization()
        setupLocationManager()
        checkLocationAuthorizationStatus()
    }
    
    private func updateDateCellViewModels() {
        let selectedDate = state.selectedDate.value
        generatedDates = calendarDateGenerator.generateDates(basedOn: selectedDate)
        state.dateCellViewModels.send(generateDateCellViewModels(
            from: generatedDates,
            selectedDate: selectedDate
        ))
    }
    
    private func generateDateCellViewModels(from dates: [Date], selectedDate: Date) -> [DateCellViewModel] {
        return dates.map { date in
            DateCellViewModel(
                dayOfTheWeek: date.formatAsDayOfTheWeek(),
                date: date.formatAsDay(),
                isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
            )
        }
    }
    
    private func updateTodayButtonState() {
        let isEnabled = !calendar.isDate(Date(), inSameDayAs: state.selectedDate.value)
        state.isTodayButtonEnabled.send(isEnabled)
    }
    
    private func updateSelectedDateIndex(date: Date) {
        if let index = generatedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) }) {
            state.selectedDateIndex.send(index)
        }
    }
    
    // MARK: - Action Handlers
    
    private func didSelectCell(_ index: Int) {
        guard index < generatedDates.count else { return }
        let date = generatedDates[index]
        state.selectedDate.send(date)
        updateSelectedDateIndex(date: date)
    }
    
    private func didSelectDate(_ date: Date) {
        state.selectedDate.send(date)
        state.isCalendarHidden.send(true)
        updateSelectedDateIndex(date: date)
    }
    
    private func didTapTodayButton() {
        let today = Date()
        state.selectedDate.send(today)
        updateSelectedDateIndex(date: today)
    }
    
    private func didTapCalendarButton() {
        state.isCalendarHidden.send(!state.isCalendarHidden.value)
    }
    
    // MARK: - Location Management
    
    private func setupLocationManager() {
        locationManager.onLocationsUpdated = { [weak self] locations in
            self?.state.locationCellViewModels.send(locations.enumerated()
                .map { index, locationData in
                    locationData.toCellViewModel(at: index + 1)
                })
        }
        
        locationManager.onError = { [weak self] error in
            self?.state.locationErrorMessage.send(error)
        }
        
        locationManager.onAuthorizationChanged = { [weak self] status in
            self?.handleLocationAuthorizationStatus(status)
        }
    }
    
    private func handleLocationAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            startTracking()
        case .denied, .restricted:
            stopTracking()
        default:
            break
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        if locationManager.authorizationStatus == .authorizedAlways {
            startTracking()
        }
    }
    
    private func startTracking() {
        startTimer()
        locationManager.requestLocationUpdates()
        backgroundTaskManager.beginBackgroundTask()
    }
    
    private func stopTracking() {
        stopTimer()
        locationManager.stopUpdatingLocation()
        backgroundTaskManager.endBackgroundTask()
    }
    
    // MARK: - Timer Management
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            state.secondsElapsed.send(state.secondsElapsed.value + 1)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Public Methods
    
    func send(_ action: Action) {
        actionPublisher.send(action)
    }
}
