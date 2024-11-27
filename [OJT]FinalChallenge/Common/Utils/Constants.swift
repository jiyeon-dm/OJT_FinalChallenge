//
//  Constants.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Foundation

struct Constants {
    static var width: CGFloat = .zero {
        didSet {
            cellWidth = (width - 80) / 6.8
        }
    }
    
    static var cellWidth: CGFloat = .zero
}
