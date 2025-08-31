//
//  FontSystem.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

/// Defines the custom font styles used throughout the app.
enum CustomFont: CaseIterable {
    
    case headingsLarge
    case headingTitle3
    case bodyMedium
    case calloutBold
    case bodySmall
    case caption1Regular
    case clubBadgeFallback
    
    /// The name of the font file.
    private var fontName: String {
        switch self {
        case .headingsLarge, .headingTitle3:
            "DrukWide-Bold-Trial"
        case .bodyMedium:
            "SelectaTrialUnlicensed-Medium"
        case .calloutBold:
            "SelectaTrialUnlicensed-Bold"
        case .bodySmall, .caption1Regular, .clubBadgeFallback:
            "SelectaTrialUnlicensed-Regular"
        }
    }
    
    /// The point size of the font.
    private var size: CGFloat {
        switch self {
        case .headingsLarge:
            40
        case .headingTitle3, .bodyMedium, .calloutBold:
            16
        case .bodySmall, .caption1Regular:
            12
        case .clubBadgeFallback:
            10
        }
    }
    
    /// The fallback font weight.
    private var weight: Font.Weight {
        switch self {
        case .headingsLarge, .headingTitle3, .calloutBold:
                .bold
        case .bodyMedium, .clubBadgeFallback:
                .medium
        case .bodySmall, .caption1Regular:
                .regular
        }
    }
    
    /// The line height for the font style.
    private var lineHeight: CGFloat {
        switch self {
        case .headingsLarge:
            100
        case .headingTitle3:
            22
        case .bodyMedium, .calloutBold:
            22
        case .bodySmall, .caption1Regular:
            16
        case .clubBadgeFallback:
            14
        }
    }
    
    /// Provides the `Font` object, with a system font fallback.
    var font: Font {
        if UIFont(name: fontName, size: size) != nil {
            Font.custom(fontName, size: size)
        } else {
            Font.system(size: size, weight: weight, design: .default)
        }
    }
}

extension Text {
    
    func customFont(_ font: CustomFont, color: Color = .textIconDefaultBlack) -> Text {
        self
            .font(font.font)
            .foregroundColor(color)
    }
}
