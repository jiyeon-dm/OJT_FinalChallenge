//
//  HealthDataCellViewModel.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Foundation
import HealthKit

enum HealthData: Hashable {
    case quantity(Double)
    case category(HKCategoryValueSleepAnalysis)
}

struct HealthDataCellViewModel: Hashable {
    let id: UUID = .init()
    let type: HealthDataType
    let startDate: Date
    let endDate: Date
    var data: HealthData
}
