//
//  Reusable.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
