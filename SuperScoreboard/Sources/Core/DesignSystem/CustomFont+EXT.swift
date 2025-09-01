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
            .foregroundStyle(color)
    }
    
    func customFontStyle(_ font: CustomFont, color: Color = .textIconDefaultBlack) -> some View {
        self
            .modifier(CustomFontModifier(customFont: font, color: color))
    }
}

extension Text {
    
    func customFont(_ font: CustomFont, color: Color = .textIconDefaultBlack) -> Text {
        var text = self
            .font(font.font)
            .foregroundStyle(color)
        
        if let letterSpacing = font.letterSpacing {
            text = text.tracking(letterSpacing)
        }
        
        return text
    }
}
