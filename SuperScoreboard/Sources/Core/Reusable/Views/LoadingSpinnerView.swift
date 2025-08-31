//
//  LoadingSpinnerView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//
// https://medium.com/@ganeshrajugalla/creating-beautiful-custom-loaders-with-swiftui-4ca99f3591b4

import SwiftUI

struct LoadingSpinnerView: View {
    @State private var showSpinner: Bool = false
    @State private var degree: Int = 270
    @State private var spinnerLength: CGFloat = 0.6

    var body: some View {
        Circle()
            .trim(from: 0.0, to: spinnerLength)
            .stroke(
                LinearGradient(
                    colors: [.blue, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round)
            )
            .frame(width: 60, height: 60)
            .rotationEffect(Angle(degrees: Double(degree)))
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    degree = 270 + 360
                }
                withAnimation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true)) {
                    spinnerLength = 0
                }
            }
    }
}

#Preview {
    LoadingSpinnerView()
}
