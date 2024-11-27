//
//  Logger.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import Foundation

final class Logger {
    static let shared = Logger()
    
    private init() {}
    
    func log(_ message: String, object: AnyObject) {
        print("[\(String(describing: type(of: object)))] \(message) | \(Date().formatAsTime())")
    }
}
