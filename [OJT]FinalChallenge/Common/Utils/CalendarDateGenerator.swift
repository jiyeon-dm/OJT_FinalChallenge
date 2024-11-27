//
//  CalendarDateGenerator.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Foundation

struct CalendarDateGenerator {
    private let calendar: Calendar
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    /// date 기준 ± 1개월 데이터 로드 (e.g. date: 11월 19일 -> 리턴값: 10월 1일 ~ 12월 31일)
    func generateDates(basedOn date: Date) -> [Date] {
        guard let baseDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let previousMonth = calendar.date(byAdding: .month, value: -1, to: baseDate),
              let nextMonth = calendar.date(byAdding: .month, value: 1, to: baseDate) else {
            return []
        }
        
        return generateDatesForMonths(previousMonth, baseDate, nextMonth)
    }
    
    private func generateDatesForMonths(_ months: Date...) -> [Date] {
        var dates: [Date] = []
        
        for month in months {
            if let monthDates = generateDatesForMonth(month) {
                dates.append(contentsOf: monthDates)
            }
        }
        
        return dates
    }
    
    private func generateDatesForMonth(_ date: Date) -> [Date]? {
        var components = DateComponents()
        components.year = calendar.component(.year, from: date)
        components.month = calendar.component(.month, from: date)
        components.day = 1
        
        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return nil
        }
        
        return (1...range.count).compactMap { day -> Date? in
            components.day = day
            return calendar.date(from: components)
        }
    }
}
