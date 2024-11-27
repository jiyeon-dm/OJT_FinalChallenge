//
//  LocationManager.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import CoreLocation

final class LocationManager: NSObject {
    private(set) var locations: [LocationData] = []
    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private(set) var lastError: String?
    
    var onLocationsUpdated: (([LocationData]) -> Void)?
    var onAuthorizationChanged: ((CLAuthorizationStatus) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Constants
    
    private enum Constants {
        static let locationTimeout: TimeInterval = 30
        static let updateInterval: TimeInterval = 300  // 5분
    }
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    private var locationTimer: Timer?
    private var lastLocationUpdate: Date?
    
    // MARK: - Init
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Public Methods
    
    func requestLocationUpdates() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        } else if authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
            startLocationTimeout()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationTimer?.invalidate()
        locationTimer = nil
    }
    
    // MARK: - Private Methods
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .other
    }
    
    private func startLocationTimeout() {
        locationTimer?.invalidate()
        locationTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.locationTimeout,
            repeats: false
        ) { [weak self] _ in
            self?.handleLocationTimeout()
        }
    }
    
    private func handleLocationTimeout() {
        Logger.shared.log("위치 업데이트 타임 아웃", object: self)
        lastError = "타임아웃, 재시도합니다."
        stopUpdatingLocation()
        requestLocationUpdates() // 다시 시도
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        onAuthorizationChanged?(authorizationStatus)
        
        switch authorizationStatus {
        case .authorizedAlways:
            Logger.shared.log("위치 권한 항상 허용", object: self)
            locationManager.startUpdatingLocation()
            startLocationTimeout()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            Logger.shared.log("위치 권한 거부", object: self)
            lastError = "위치 권한이 필요합니다."
            onError?(lastError!)
            stopUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        startLocationTimeout()
        // 마지막 업데이트로부터 5분이 지났는지 확인
        if let lastUpdate = lastLocationUpdate,
           lastUpdate.timeIntervalSinceNow > -Constants.updateInterval {
            return
        }
        // 새로운 위치 저장
        Logger.shared.log("새로운 위치 저장", object: self)
        lastLocationUpdate = Date()
        let locationData = LocationData(location: location)
        DispatchQueue.main.async {
            self.locations.append(locationData)
            self.onLocationsUpdated?(self.locations)
        }
        locationTimer?.invalidate()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .denied:
                stopUpdatingLocation()
            case .locationUnknown:
                // 일시적인 오류이므로 계속 시도
                break
            default:
                break
            }
        }
    }
}
