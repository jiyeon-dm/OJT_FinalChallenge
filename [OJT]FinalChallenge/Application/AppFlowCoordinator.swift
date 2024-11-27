//
//  AppFlowCoordinator.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

final class AppFlowCoordinator {
    private let window: UIWindow
    private let appDIContainer: AppDIContainer
    private let navigationController: UINavigationController
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        self.appDIContainer = AppDIContainer()
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        showHomeViewController()
    }
    
    // MARK: - Private Methods
    
    private func showHomeViewController() {
        let viewController = appDIContainer.makeHomeViewController()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showHealthDataViewController(dataType: HealthDataType, date: Date) {
        let viewController = appDIContainer.makeHealthDataViewController(
            dataType: dataType,
            date: date
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppFlowCoordinator: HomeViewControllerDelegate {
    func didTapHealthDataButton(dataType: HealthDataType, date: Date) {
        showHealthDataViewController(dataType: dataType, date: date)
    }
}
