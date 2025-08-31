//
//  CustomFontModifier.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

struct CustomFontModifier: ViewModifier {
    let customFont: CustomFont
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(customFont.font)
            .foregroundStyle(color)
    }
}
