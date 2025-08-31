//
//  View+Background.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

extension View {
    
    /// Fill space and add background color for
    /// - Parameter color: Background color
    /// - Parameter ignoreSafeArea: If background should cover the whole screen
    /// - Returns: View with background
    func addFullscreenBackground(_ color: Color = .primaryBackground) -> some View {
        self
            .ignoresSafeArea(edges: .all)
            .fillSpace()
            .background(color)
    }
    
    func addBackground(_ color: Color = .primaryBackground) -> some View {
        self
            .background(color)
    }
    
    /// Fill the space around the views area
    private func fillSpace() -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                self
                Spacer()
            }
            Spacer()
        }
    }
}
