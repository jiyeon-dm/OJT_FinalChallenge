//
//  HKCategoryValueSleepAnalysis+.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import HealthKit

extension HKCategoryValueSleepAnalysis {
    var description: String {
        switch self {
        case .inBed:                "inBed"
        case .asleepUnspecified:    "asleepUnspecified"
        case .asleep:               "asleep"
        case .awake:                "awake"
        case .asleepCore:           "asleepCore"
        case .asleepDeep:           "asleepDeep"
        case .asleepREM:            "asleepREM"
        @unknown default:           "unknown"
        }
    }
}
