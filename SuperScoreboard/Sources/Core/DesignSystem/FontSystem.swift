//
//  FontSystem.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

/// Defines the custom font styles used throughout the app.
enum CustomFont: CaseIterable {
    
    case headingsExtraLarge
    case headingsLarge
    case headingTitle2
    case headingTitle3
    case bodyMedium
    case calloutBold
    case bodySmall
    case caption1Regular
    case captionMedium
    case clubBadgeFallback
    
    /// The name of the font file.
    private var fontName: String {
        switch self {
        case .headingsExtraLarge, .headingsLarge, .headingTitle2:
            "DrukWide-Bold-Trial"
        case .bodyMedium, .captionMedium:
            "SelectaTrialUnlicensed-Medium"
        case .calloutBold, .headingTitle3:
            "SelectaTrialUnlicensed-Bold"
        case .bodySmall, .caption1Regular, .clubBadgeFallback:
            "SelectaTrialUnlicensed-Regular"
        }
    }
    
    /// The point size of the font.
    private var size: CGFloat {
        switch self {
        case .headingsExtraLarge:
            48
        case .headingsLarge:
            70
        case .headingTitle2:
            20
        case .headingTitle3:
            20
        case .calloutBold, .bodyMedium:
            16
        case .bodySmall, .caption1Regular, .captionMedium:
            12
        case .clubBadgeFallback:
            10
        }
    }
        
    /// The letter spacing (tracking) for the font style.
   var letterSpacing: CGFloat? {
        switch self {
        case .headingsLarge:
            0.4
        case .headingTitle2:
            -0.45
        case .calloutBold:
            -0.43
        case .headingsExtraLarge, .headingTitle3, .bodyMedium, .bodySmall, .caption1Regular, .captionMedium, .clubBadgeFallback:
            nil
        }
    }
    
    /// The fallback font weight.
    private var weight: Font.Weight {
        switch self {
        case .headingsExtraLarge, .headingsLarge, .headingTitle2, .headingTitle3, .calloutBold:
                .bold
        case .bodyMedium, .captionMedium, .clubBadgeFallback:
                .medium
        case .bodySmall, .caption1Regular:
                .regular
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
