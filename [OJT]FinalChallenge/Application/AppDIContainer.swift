//
//  AppDIContainer.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

final class AppDIContainer {
    private let calendarDateGenerator: CalendarDateGenerator
    private let healthKitManager: HealthKitManager
    private let backgroundTaskManager: BackgroundTaskManager
    private let locationManager: LocationManager
    
    // MARK: - Init
    
    init() {
        calendarDateGenerator = CalendarDateGenerator()
        healthKitManager = HealthKitManager()
        backgroundTaskManager = BackgroundTaskManager()
        locationManager = LocationManager()
    }
    
    // MARK: - View Models
    
    private func makeHomeViewModel() -> HomeViewModel {
        let viewModel = HomeViewModel(
            calendarDateGenerator: calendarDateGenerator,
            healthKitManager: healthKitManager,
            backgroundTaskManager: backgroundTaskManager,
            locationManager: locationManager
        )
        return viewModel
    }
    
    private func makeHealthDataViewModel(
        dataType: HealthDataType,
        date: Date
    ) -> HealthDataViewModel {
        let viewModel = HealthDataViewModel(
            healthKitManager: healthKitManager,
            dataType: dataType,
            date: date
        )
        return viewModel
    }
    
    // MARK: - View Controllers
    
    func makeHomeViewController() -> HomeViewController {
        let viewController = HomeViewController(viewModel: makeHomeViewModel())
        return viewController
    }
    
    func makeHealthDataViewController(
        dataType: HealthDataType,
        date: Date
    ) -> HealthDataViewController {
        let viewController = HealthDataViewController(
            viewModel: makeHealthDataViewModel(dataType: dataType, date: date)
        )
        return viewController
    }
}
