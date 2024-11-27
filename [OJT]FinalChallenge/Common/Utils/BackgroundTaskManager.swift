//
//  BackgroundTaskManager.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

final class BackgroundTaskManager {
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var timer: Timer?
    
    func beginBackgroundTask() {
        guard backgroundTask == .invalid else { return }
        Logger.shared.log("백그라운드 작업 요청 예약", object: self)
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        if backgroundTask != .invalid {
            Logger.shared.log("백그라운드 작업 종료", object: self)
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}
