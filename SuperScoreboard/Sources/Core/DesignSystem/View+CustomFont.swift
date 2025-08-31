//
//  View+CustomFont.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

extension View {
    
    /// Applies a custom font and color to a view.
    func customFont(_ font: CustomFont, color: Color = .textIconDefaultBlack) -> some View {
        self
            .font(font.font)
            .foregroundColor(color)
    }
    
    /// Applies a custom font and color using a `ViewModifier` for robust styling.
    func customFontStyle(_ font: CustomFont, color: Color = .textIconDefaultBlack) -> some View {
        self
            .modifier(CustomFontModifier(customFont: font, color: color))
    }
}
