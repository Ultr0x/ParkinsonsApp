//
//  Theme.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

enum Theme {
    // Core Stigma identity
    static let background = Color(hex: 0xFAF5EB) // Cream
    static let text = Color(hex: 0x8B6914)       // Brown
    static let accent = Color(hex: 0xF28DB2)     // Pink asterisk
    
    static let cardBackground = Color(hex: 0xF0E8D8) // Darker cream for surfaces
    
    // Status/Tag colors
    static let green = Color(hex: 0xA8D84E)
    static let cyan  = Color(hex: 0x7DD3E8)
    static let orange = Color(hex: 0xF5A623)

    // Glass/Surface helpers
    static var glassBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(cardBackground)
            .shadow(color: text.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    static func pill(tint: Color) -> some View {
        Capsule(style: .continuous)
            .fill(tint.opacity(0.2))
            .overlay(
                Capsule(style: .continuous)
                    .stroke(tint.opacity(0.3), lineWidth: 1)
            )
    }
}

// Hex initializer convenience
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// Stigma standardized card style
struct StigmaCard<Content: View>: View {
    @ViewBuilder var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.glassBackground)
    }
}

// Colorful pill badge
struct PillBadge: View {
    let text: String
    let tint: Color
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.footnote.weight(.semibold))
            }
            Text(text)
                .font(.footnote.weight(.semibold))
                .fontDesign(.rounded)
        }
        .foregroundStyle(Theme.text)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Theme.pill(tint: tint))
    }
}
