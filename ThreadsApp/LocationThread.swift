//
//  LocationThread.swift
//  ThreadsApp
//
//  Created by Sebastian Dąbrowski on 15/09/2024.
//

import CoreLocation

final class LocationThread: NSObject {
    private let locationManager = CLLocationManager()
    private let interval: TimeInterval
    private var timer: DispatchSourceTimer?
    private var locationThread: Thread?
    private var locationCompletion: ((String) -> Void)?
    private var isUpdatingLocation = false

    init(interval: TimeInterval) {
        self.interval = interval
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func start() {
        locationThread = Thread { [weak self] in
            guard let self else { return }
            
            createTimer()
            RunLoop.current.run()
        }

        locationThread?.start()
    }

    func setCompletion(completion: @escaping (String) -> Void) {
        self.locationCompletion = completion
    }

    func stopCollecting() {
        locationThread?.cancel()
        locationThread = nil
        stopLocationUpdates()
        timer?.cancel()
        timer = nil
    }

    private func createTimer() {
        let queue = DispatchQueue(label: "com.example.locationThread", attributes: .concurrent)
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: interval)

        timer?.setEventHandler { [weak self] in
            self?.startLocationUpdates()
        }
        timer?.resume()
    }

    private func startLocationUpdates() {
        if !isUpdatingLocation {
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }

    private func stopLocationUpdates() {
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            isUpdatingLocation = false
        }
    }
}

extension LocationThread: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        let locationString = "Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)"
        locationCompletion?(locationString)
        stopLocationUpdates()
    }
}
