//
//  ContentView.swift
//  ThreadsApp
//
//  Created by Sebastian Dąbrowski on 15/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Button("START") {
                if !viewModel.isRunning {
                    viewModel.startOperations()
                }
            }
                .padding(15)
                .disabled(viewModel.isRunning)
                .background(
                    Color(
                        red: 253 / 255,
                        green: 198 / 255,
                        blue: 5 / 255
                    )
                )
                .clipShape(.rect(cornerRadius: 8))

            Button("STOP") {
                if viewModel.isRunning {
                    viewModel.stopOperation()
                }
            }
                .padding(15)
                .disabled(!viewModel.isRunning)
                .background(
                    Color(
                        red: 253 / 255,
                        green: 198 / 255,
                        blue: 5 / 255
                    )
                )
                .clipShape(.rect(cornerRadius: 8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 20 / 255, green: 40 / 255, blue: 58 / 255))
    }
}

#Preview {
    ContentView()
}
