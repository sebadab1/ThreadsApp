//
//  ContentViewModel.swift
//  ThreadsApp
//
//  Created by Sebastian Dąbrowski on 15/09/2024.
//

import Foundation

final class ContentViewModel: ObservableObject {
    @Published var isRunning = false

    private let locationInterval: TimeInterval = 5
    private let batteryInterval: TimeInterval = 10
    private let dataLimit = 5
    private let serverURL = "https://example.com/data"

    private var locationThread: LocationThread?
    private var batteryThread: BatteryThread?
    private var aggregationThread: AggregationThread?

    func startOperations() {
        isRunning = true

        aggregationThread = AggregationThread(dataLimit: dataLimit, serverURL: serverURL)
        aggregationThread?.start()

        locationThread = LocationThread(interval: locationInterval)
        locationThread?.setCompletion { [weak self] data in
            self?.aggregationThread?.addData(data)
        }
        locationThread?.start()

        batteryThread = BatteryThread(interval: batteryInterval)
        batteryThread?.setCompletion{ [weak self] data in
            self?.aggregationThread?.addData(data)
        }
        batteryThread?.start()
    }

    func stopOperation() {
        isRunning = false

        locationThread?.stopCollecting()
        batteryThread?.stop()
        aggregationThread?.stop()
        locationThread = nil
        batteryThread = nil
        aggregationThread = nil
    }
}
