//
//  AggregationThread.swift
//  ThreadsApp
//
//  Created by Sebastian Dąbrowski on 15/09/2024.
//

import Foundation

final class AggregationThread {
    private var dataBuffer: [String] = []
    private let dataLimit: Int
    private let serverURL: String
    private let dataQueue = DispatchQueue(label: "com.threadsApp.dataQueue")
    private var aggregationThread: Thread?

    init(dataLimit: Int, serverURL: String) {
        self.dataLimit = dataLimit
        self.serverURL = serverURL
    }

    func addData(_ data: String) {
        dataQueue.async { [weak self] in
            guard let self else { return }
            
            dataBuffer.append(data)
            if dataBuffer.count >= dataLimit {
                sendData()
                dataBuffer.removeAll()
            }
        }
    }

    func start() {
        aggregationThread = Thread {
            RunLoop.current.run()
        }
        aggregationThread?.start()
    }

    func stop() {
        aggregationThread?.cancel()
        aggregationThread = nil
    }

    private func sendData() {
        guard let url = URL(string: serverURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let bodyData = dataBuffer.joined(separator: "\n")
        print(bodyData)
        request.httpBody = bodyData.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error {
                print("Error sending data: \(error.localizedDescription)")
            } else {
                print("Successfully sent data")
            }
        }
        task.resume()
    }
}
