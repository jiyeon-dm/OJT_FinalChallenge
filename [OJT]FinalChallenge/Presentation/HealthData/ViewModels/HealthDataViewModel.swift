//
//  HealthDataViewModel.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Combine
import Foundation
import HealthKit

final class HealthDataViewModel {
    struct State {
        let navigationTitle: CurrentValueSubject<String, Never>
        let date: CurrentValueSubject<Date, Never>
        let cellViewModels: CurrentValueSubject<[HealthDataCellViewModel], Never>
        let description: CurrentValueSubject<String, Never>
        
        init(navigationTitle: String, date: Date) {
            self.navigationTitle = .init(navigationTitle)
            self.date = .init(date)
            self.cellViewModels = .init([])
            self.description = .init("")
        }
    }
    
    // MARK: - Properties
    
    private let healthKitManager: HealthKitManager
    private let dataType: HealthDataType
    private let date: Date
    
    private var cancellables = Set<AnyCancellable>()
    
    var state: State
    
    // MARK: - Init
    
    init(healthKitManager: HealthKitManager, dataType: HealthDataType, date: Date) {
        self.healthKitManager = healthKitManager
        self.dataType = dataType
        self.date = date
        self.state = State(navigationTitle: dataType.description, date: date)
        
        fetchHealthData()
    }
    
    // MARK: - Setup Methods
    
    private func fetchHealthData() {
        healthKitManager.getHealthData(for: dataType, at: date)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    Logger.shared.log("\(dataType.description) 데이터 패치 완료", object: self)
                case .failure(let error):
                    Logger.shared.log("\(dataType.description) 데이터 패치 실패: \(error.localizedDescription)", object: self)
                }
            } receiveValue: { [weak self] samples in
                guard let self = self else { return }
                updateHealthData(with: samples)
            }
            .store(in: &cancellables)
    }
    
    private func updateHealthData(with samples: [HKSample]) {
        var cellViewModels: [HealthDataCellViewModel] = []
        
        if dataType == .sleepAnalysis { // sleep: HKCategorySample
            guard let samples = samples as? [HKCategorySample] else {
                return
            }
            for sample in samples {
                cellViewModels.append(HealthDataCellViewModel(
                    type: dataType,
                    startDate: sample.startDate,
                    endDate: sample.endDate,
                    data: .category(HKCategoryValueSleepAnalysis(rawValue: sample.value)!))
                )
            }
        } else { // HKQuantitySample
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            for sample in samples {
                cellViewModels.append(HealthDataCellViewModel(
                    type: dataType,
                    startDate: sample.startDate,
                    endDate: sample.endDate,
                    data: .quantity(sample.quantity.doubleValue(for: dataType.unit)))
                )
            }
        }
        
        state.cellViewModels.send(cellViewModels.reversed())
        updateDescription()
    }
    
    private func updateDescription() {
        let cellViewModels = state.cellViewModels.value
        
        guard !cellViewModels.isEmpty else {
            state.description.send("")
            return
        }
        
        var total: Double = 0.0
        
        for cellViewModel in cellViewModels {
            switch cellViewModel.data {
            case .quantity(let value):
                total += value
            case .category(let sleepAnalysis):
                guard sleepAnalysis.rawValue > 1 else { continue }
                total += calculateSleepDuration(
                    start: cellViewModel.startDate,
                    end: cellViewModel.endDate
                )
            }
        }
        
        if dataType == .heartRate { // 평균 데이터
            total /= Double(cellViewModels.count)
        } else if dataType == .sleepAnalysis { // 초 -> 분
            total /= 60.0
        }
        
        state.description.send("\(Int(total))\(dataType.unitDescription)")
    }
    
    // MARK: - Util Methods
    
    // 시간이 겹치는 데이터 필터링
    private func filterOverlappingSamples(samples: [HKQuantitySample]) -> [HKQuantitySample] {
        var filteredSamples: [HKQuantitySample] = []
        
        // 시간순으로 정렬
        let sortedSamples = samples.sorted { $0.startDate < $1.startDate }
        
        var lastEndDate: Date? = nil
        for sample in sortedSamples {
            if let lastEndDate = lastEndDate, sample.startDate < lastEndDate { continue }
            // 시간이 겹치지 않으면 결과 배열에 추가
            filteredSamples.append(sample)
            lastEndDate = sample.endDate
        }
        
        return filteredSamples
    }
    
    // 시간 차이를 구하는 함수 (시작 시간과 끝 시간의 차이를 계산)
    private func calculateSleepDuration(start: Date, end: Date) -> TimeInterval {
        return end.timeIntervalSince(start)
    }
}
