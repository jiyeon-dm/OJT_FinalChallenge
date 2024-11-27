//
//  LocationData.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import CoreLocation

struct LocationData {
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp
    }
}

extension LocationData {
    func toCellViewModel(at index: Int) -> LocationCellViewModel {
        return LocationCellViewModel(
            index: index,
            date: timestamp.formatAsFullDate(),
            time: timestamp.formatAsTime(),
            latitude: String(format: "%.2f", latitude),
            longtitude: String(format: "%.2f", longitude)
        )
    }
}
