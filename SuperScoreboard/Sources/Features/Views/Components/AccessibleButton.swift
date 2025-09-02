//
//  AccessibleButton.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 02/09/2025.
//

import SwiftUI

/// A wrapper view that provides consistent accessibility button behavior.
/// This view automatically applies proper accessibility traits and can be used
/// to wrap any content that should behave as a button.
struct AccessibleButton<Content: View>: View {
    
    let label: LocalizedStringKey
    let hint: LocalizedStringKey?
    let action: () -> Void
    let content: () -> Content
    
    init(
        label: LocalizedStringKey,
        hint: LocalizedStringKey? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.hint = hint
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button(action: action) {
            content()
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text(label))
        .accessibilityHint(hint != nil ? Text(hint!) : Text(""))
    }
}

#Preview {
    VStack(spacing: 20) {
        AccessibleButton(
            label: "Save Document",
            hint: "Double tap to save the current document"
        ) {
            print("Save tapped")
        } content: {
            HStack {
                Image(systemName: "square.and.arrow.down")
                Text("Save")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        
        AccessibleButton(
            label: "Delete Item",
            hint: "This action cannot be undone"
        ) {
            print("Delete tapped")
        } content: {
            Text("Delete")
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        AccessibleButton(label: "Simple Button") {
            print("Simple tapped")
        } content: {
            Text("Tap me")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
    .padding()
}