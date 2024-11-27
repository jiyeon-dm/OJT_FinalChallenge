//
//  HealthDataType.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Foundation
import HealthKit

enum HealthDataType: CaseIterable {
    case stepCount
    case distance
    case sleepAnalysis
    case heartRate
    
    var hkObjectType: HKObjectType {
        switch self {
        case .stepCount:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)!
        case .distance:
            return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        case .sleepAnalysis:
            return HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        case .heartRate:
            return HKQuantityType.quantityType(forIdentifier: .heartRate)!
        }
    }
    
    var description: String {
        switch self {
        case .stepCount:
            return "걸음 수"
        case .distance:
            return "이동 거리"
        case .sleepAnalysis:
            return "수면 시간"
        case .heartRate:
            return "심박수"
        }
    }
    
    var unit: HKUnit {
        switch self {
        case .stepCount:
            return .count()
        case .distance:
            return .meter()
        case .sleepAnalysis:
            return .hour()
        case .heartRate:
            return .count().unitDivided(by: .minute())
        }
    }
    
    var option: HKStatisticsOptions {
        switch self {
        case .stepCount, .distance:
            return .cumulativeSum
        case .sleepAnalysis, .heartRate:
            return .discreteAverage
        }
    }
    
    var unitDescription: String {
        switch self {
        case .stepCount:
            return "걸음"
        case .distance:
            return "m"
        case .sleepAnalysis:
            return "분"
        case .heartRate:
            return "BPM"
        }
    }
    
    var device: String {
        switch self {
        case .stepCount, .distance:
            return "iPhone"
        case .sleepAnalysis, .heartRate:
            return "Apple Watch"
        }
    }
}
