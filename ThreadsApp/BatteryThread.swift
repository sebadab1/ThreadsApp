//
//  BatteryThread.swift
//  ThreadsApp
//
//  Created by Sebastian Dąbrowski on 15/09/2024.
//

import UIKit

final class BatteryThread {
    private let interval: TimeInterval
    private var batteryCompletion: ((String) -> Void)?
    private var timer: DispatchSourceTimer?
    private var batteryThread: Thread?

    init(interval: TimeInterval) {
        self.interval = interval
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    func start() {
        batteryThread = Thread {
            self.createTimer()
            RunLoop.current.run()
        }
        batteryThread?.start()
    }

    func setCompletion(completion: @escaping (String) -> Void) {
        batteryCompletion = completion
    }

    func stop() {
        batteryThread?.cancel()
        batteryThread = nil
        stopTimer()
    }

    private func createTimer() {
        let queue = DispatchQueue(label: "com.example.batteryThread", attributes: .concurrent)
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: interval)

        timer?.setEventHandler { [weak self] in
            let batteryLevel = UIDevice.current.batteryLevel * 100
            let batteryLevelString = "Battery: \(Int(batteryLevel))%"
            self?.batteryCompletion?(batteryLevelString)
        }
        timer?.resume()
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}
