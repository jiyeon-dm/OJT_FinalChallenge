//
//  HealthKitError.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Combine
import Foundation
import HealthKit

enum HealthKitError: Error {
    case noData
    case unauthorized
    case unknown
}

final class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() {
        let readTypes = Set(HealthDataType.allCases.map { $0.hkObjectType })
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
                if success {
                    Logger.shared.log("권한 요청 완료", object: self)
                } else {
                    if let error = error {
                        Logger.shared.log("권한 요청 실패: \(error.localizedDescription)", object: self)
                    } else {
                        Logger.shared.log("권한 요청 실패: 알 수 없음", object: self)
                    }
                }
            }
        } else {
            Logger.shared.log("HealthKit 사용할 수 없음", object: self)
        }
    }
    
    func isAuthorized(for dataType: HealthDataType) -> AnyPublisher<Bool, Never> {
        return Future<Bool, Never> { [weak self] promise in
            let query = HKSampleQuery(
                sampleType: dataType.hkObjectType as! HKSampleType,
                predicate: nil,
                limit: 1,
                sortDescriptors: nil) { _, _, error in
                    if error != nil {
                        promise(.success(false))
                    } else {
                        promise(.success(true))
                    }
                }
            self?.healthStore.execute(query)
        }
        .eraseToAnyPublisher()
    }
    
    func getHealthData(
        for dataType: HealthDataType,
        at date: Date
    ) -> AnyPublisher<[HKSample], HealthKitError> {
        
        return Future<[HKSample], HealthKitError> { [weak self] promise in
            guard let self = self else { return }
            
            let query = HKSampleQuery(
                sampleType: dataType.hkObjectType as! HKSampleType,
                predicate: getPredicate(for: dataType, at: date),
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil) { _, samples, error in
                    if error != nil {
                        promise(.failure(.unknown))
                    }
                    guard let samples = samples else {
                        promise(.failure(.noData))
                        return
                    }
                    promise(.success(samples))
                }
            healthStore.execute(query)
        }
        .eraseToAnyPublisher()
    }
    
    private func getPredicate(for dataType: HealthDataType, at date: Date) -> NSPredicate? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // 날짜 제한 (date 기준 하루)
        let datePredicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )
        
        if dataType == .sleepAnalysis {
            return datePredicate
        } else {
            // 기기 제한
            let devicePredicate = HKQuery.predicateForObjects(
                withDeviceProperty: HKDevicePropertyKeyName,
                allowedValues: Set([dataType.device])
            )
            // 두 조건을 더한다
            return NSCompoundPredicate(
                andPredicateWithSubpredicates: [datePredicate, devicePredicate]
            )
        }
    }
}
