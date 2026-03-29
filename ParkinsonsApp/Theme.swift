//
//  Theme.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

enum Theme {
    // Core brand colors
    static let background = Color(hex: 0xFFF5E4) // #fff5e4
    static let text = Color(hex: 0x794100)       // #794100

    // Tulip palette
    static let tulipGreen = Color(hex: 0xB4FF48) // #b4ff48
    static let tulipCyan  = Color(hex: 0x5CE1E6) // #5ce1e6
    static let tulipPink  = Color(hex: 0xFF64B8) // #ff64b8
    static let tulipOrange = Color(hex: 0xFFAE42) // #ffae42
    static let tulipPurple = Color(hex: 0x8C52FF) // #8c52ff

    // Common card styling
    static func cardBackground(for color: Color) -> some View {
        color.opacity(0.18)
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

// A reusable card style
struct TulipCard<Content: View>: View {
    let accent: Color
    let title: String
    @ViewBuilder var content: Content

    init(title: String, accent: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.accent = accent
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(accent)
                    .frame(width: 10, height: 10)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.text)
            }
            content
                .foregroundStyle(Theme.text.opacity(0.9))
                .font(.subheadline)
        }
        .padding(14)
        .background(Theme.cardBackground(for: accent))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(accent.opacity(0.25), lineWidth: 1)
        )
    }
}
