//
//  View+CustomFont.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

extension View {
    func customFont(_ font: CustomFont, color: Color = .textIconDefaultBlack) -> some View {
        self
            .font(font.font)
            .foregroundColor(color)
    }
}

extension View {
    func customFontStyle(_ font: CustomFont, color: Color = .textIconDefaultBlack) -> some View {
        self
            .modifier(CustomFontModifier(customFont: font, color: color))
    }
}
