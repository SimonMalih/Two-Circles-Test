//
//  FontSystem.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

enum CustomFont: CaseIterable {
    case headingsLarge
    case headingTitle3
    case bodyMedium
    case calloutBold
    case bodySmall
    case caption
    case timeNumber
    
    private var fontName: String {
        switch self {
        case .headingsLarge, .headingTitle3:
            "DrukWide-Bold-Trial"
        case .bodyMedium, .caption:
            "SelectaTrialUnlicensed-Medium"
        case .calloutBold:
            "SelectaTrialUnlicensed-Bold"
        case .bodySmall, .timeNumber:
            "SelectaTrialUnlicensed-Regular"
        }
    }
    
    private var size: CGFloat {
        switch self {
        case .headingsLarge:
            34
        case .headingTitle3, .bodyMedium, .calloutBold:
            16
        case .bodySmall, .timeNumber:
            12
        case .caption:
            12.94
        }
    }
    
    private var weight: Font.Weight {
        switch self {
        case .headingsLarge, .headingTitle3, .calloutBold:
            .bold
        case .bodyMedium, .caption:
            .medium
        case .bodySmall, .timeNumber:
            .regular
        }
    }
    
    private var lineHeight: CGFloat {
        switch self {
        case .headingsLarge:
            42
        case .headingTitle3:
            22
        case .bodyMedium, .calloutBold:
            22
        case .bodySmall, .timeNumber:
            16
        case .caption:
            16
        }
    }
    
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
