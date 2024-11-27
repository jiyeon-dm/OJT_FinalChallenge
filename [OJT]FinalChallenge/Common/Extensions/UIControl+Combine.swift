//
//  UIControl+Combine.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Combine
import UIKit

extension UIControl {
    func controlPublisher(for events: UIControl.Event) -> AnyPublisher<UIControl, Never> {
        ControlEvent(control: self, events: events)
            .eraseToAnyPublisher()
    }
}
