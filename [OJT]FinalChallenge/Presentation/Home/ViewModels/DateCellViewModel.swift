//
//  DateCellViewModel.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//
import Foundation

struct DateCellViewModel: Hashable {
    let id: UUID
    let dayOfTheWeek: String  // 요일
    let date: String          // 날짜
    let isSelected: Bool      // 선택된 날짜 여부
    
    init(id: UUID = .init(), dayOfTheWeek: String, date: String, isSelected: Bool) {
        self.id = id
        self.dayOfTheWeek = dayOfTheWeek
        self.date = date
        self.isSelected = isSelected
    }
}
