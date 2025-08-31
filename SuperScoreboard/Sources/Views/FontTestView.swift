//
//  FontTestView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

struct FontTestView: View {
    private let colors: [String: Color] = [
        "FillPrimary": .fillPrimary,
        "PrimaryBackground": .primaryBackground,
        "Red75": .red75,
        "SurfaceBase": .surfaceBase,
        "TextIconDefaultBlack": .textIconDefaultBlack,
        "TextIconDefaultWhite": .textIconDefaultWhite
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("font_system_test")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ForEach(CustomFont.allCases, id: \.self) { font in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(describing: font))
                            .foregroundColor(.blue)
                        
                        ForEach(colors.sorted(by: { $0.key < $1.key }), id: \.key) { colorName, color in
                            Text("two_circles_awesome")
                                .customFont(font, color: color)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(color == .textIconDefaultWhite ? .black : .white)
                                .cornerRadius(8)
                        }
                    }
                    Divider()
                }
            }
            .padding()
        }
        .navigationTitle("Font Test")
        .background(.primaryBackground)
    }
}

#Preview {
    FontTestView()
}
