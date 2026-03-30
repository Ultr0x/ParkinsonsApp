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

    // Atkinson Hyperlegible Accessibility Typography System
    struct Fonts {
        static func logo(size: CGFloat = 48) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Bold", tracking: -1.0)
        }
        
        static func title(size: CGFloat = 28) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Bold", tracking: -0.5)
        }
        
        static func headline(size: CGFloat = 18) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Bold", tracking: 0)
        }

        static func body(size: CGFloat = 16) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Regular", tracking: 0)
        }
        
        static func subheadline(size: CGFloat = 15) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Regular", tracking: 0)
        }

        static func caption(size: CGFloat = 13) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Regular", tracking: 0)
        }

        static func caption2(size: CGFloat = 11) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Regular", tracking: 0)
        }

        static func footnote(size: CGFloat = 13) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Italic", tracking: 0)
        }

        static func label(size: CGFloat = 14) -> StigmaFont {
            StigmaFont(size: size, name: "AtkinsonHyperlegible-Bold", tracking: 0.2)
        }
    }
}

// Reusable font modifier for Atkinson Hyperlegible
// Reads the user's text-size preference and scales all text accordingly.
struct StigmaFont: ViewModifier {
    let size: CGFloat
    let name: String
    let tracking: CGFloat

    @AppStorage("settingsTextSize") private var textSizeRaw: String = "Standard"
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false

    private var scale: CGFloat {
        (TextSizePreference(rawValue: textSizeRaw) ?? .standard).scaleFactor
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(highContrast && name.contains("Regular") ? name.replacingOccurrences(of: "Regular", with: "Bold") : name, size: size * scale))
            .kerning(tracking)
    }
}

extension View {
    func stigmaFont(size: CGFloat, name: String = "AtkinsonHyperlegible-Regular", tracking: CGFloat = 0) -> some View {
        self.modifier(StigmaFont(size: size, name: name, tracking: tracking))
    }
    
    func logoStyle(size: CGFloat = 48) -> some View {
        self.modifier(Theme.Fonts.logo(size: size))
    }
    
    func titleStyle(size: CGFloat = 28) -> some View {
        self.modifier(Theme.Fonts.title(size: size))
    }
    
    func headlineStyle(size: CGFloat = 18) -> some View {
        self.modifier(Theme.Fonts.headline(size: size))
    }

    func subheadlineStyle(size: CGFloat = 15) -> some View {
        self.modifier(Theme.Fonts.subheadline(size: size))
    }

    func captionStyle(size: CGFloat = 13) -> some View {
        self.modifier(Theme.Fonts.caption(size: size))
    }

    func caption2Style(size: CGFloat = 11) -> some View {
        self.modifier(Theme.Fonts.caption2(size: size))
    }

    func footnoteStyle(size: CGFloat = 13) -> some View {
        self.modifier(Theme.Fonts.footnote(size: size))
    }

    func labelStyle(size: CGFloat = 14) -> some View {
        self.modifier(Theme.Fonts.label(size: size))
    }

    func bodyStyle(size: CGFloat = 16) -> some View {
        self.modifier(Theme.Fonts.body(size: size))
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
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false

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
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.text.opacity(highContrast ? 0.25 : 0), lineWidth: 1.5)
        )
    }
}

// Colorful pill badge — decorative, hidden from VoiceOver by default.
// If used standalone as a label (not inside a button/row), set accessibilityHidden(false) at call site.
struct PillBadge: View {
    let text: String
    let tint: Color
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .stigmaFont(size: 13, name: "AtkinsonHyperlegible-Bold")
                    .accessibilityHidden(true)
            }
            Text(text)
                .stigmaFont(size: 13, name: "AtkinsonHyperlegible-Bold")
                .lineLimit(1)
        }
        .foregroundStyle(Theme.text)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .fixedSize(horizontal: true, vertical: true)
        .background(Theme.pill(tint: tint))
        // Pills inside list rows are announced via the row's accessibilityLabel.
        // Remove this if a pill is the only label on screen.
        .accessibilityHidden(true)
    }
}
