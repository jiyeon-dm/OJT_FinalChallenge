//
//  UIButton+Combine.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Combine
import UIKit

extension UIButton {
    public var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
