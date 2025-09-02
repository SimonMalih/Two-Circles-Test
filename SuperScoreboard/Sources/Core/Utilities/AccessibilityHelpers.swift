//
//  AccessibilityHelpers.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 02/09/2025.
//

import SwiftUI

// MARK: - Accessibility Helper Extensions

extension View {
    
    /// Makes a view accessible as a button with localized label and optional hint
    func accessibleButton(
        label: LocalizedStringKey,
        hint: LocalizedStringKey? = nil
    ) -> some View {
        self
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(Text(label))
            .accessibilityHint(hint != nil ? Text(hint!) : Text(""))
    }
    
    /// Makes an image accessible with proper labeling or hides decorative images
    func accessibleImage(
        label: LocalizedStringKey? = nil,
        isDecorative: Bool = false
    ) -> some View {
        self
            .accessibilityAddTraits(.isImage)
            .accessibilityLabel(isDecorative ? Text("") : (label != nil ? Text(label!) : Text("")))
            .accessibilityHidden(isDecorative)
    }
    
    /// Marks text as a heading with specified heading level
    func accessibleHeading(_ level: AccessibilityHeadingLevel = .h1) -> some View {
        self
            .accessibilityHeading(level)
    }
    
    /// Combines child accessibility elements with a custom label
    func accessibleGroup(
        label: LocalizedStringKey,
        hint: LocalizedStringKey? = nil
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(label))
            .accessibilityHint(hint != nil ? Text(hint!) : Text(""))
    }
    
    /// Marks content that updates frequently (like live scores)
    func accessibleLiveContent(
        label: LocalizedStringKey,
        value: String? = nil
    ) -> some View {
        self
            .accessibilityLabel(Text(label))
            .accessibilityValue(value ?? "")
            .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Dynamic Type Support

extension View {
    
    /// Adds support for accessibility text sizes with layout adaptation
    func adaptiveLayout() -> some View {
        self.modifier(AdaptiveLayoutModifier())
    }
}

struct AdaptiveLayoutModifier: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    
    var isAccessibilitySize: Bool {
        sizeCategory >= .accessibilityMedium
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.isAccessibilitySize, isAccessibilitySize)
    }
}

// MARK: - Environment Values

private struct IsAccessibilitySizeKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isAccessibilitySize: Bool {
        get { self[IsAccessibilitySizeKey.self] }
        set { self[IsAccessibilitySizeKey.self] = newValue }
    }
}
