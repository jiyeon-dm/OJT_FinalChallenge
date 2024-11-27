//
//  Date+.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Foundation

extension Date {
    /// e.g. 2024-11-20
    func formatAsFullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// e.g. 14:44:20
    func formatAsTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    /// e.g. 2024
    func formatAsYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy" // 🌟 일 기준 연도
        return dateFormatter.string(from: self)
    }
    
    /// e.g. 09
    func formatAsMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    /// e.g. 9
    func formatAsDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    /// e.g. 월
    func formatAsDayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: self)
    }
}
