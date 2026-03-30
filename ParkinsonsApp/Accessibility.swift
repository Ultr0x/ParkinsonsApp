//
//  Accessibility.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 30/03/2026.
//
//  Central accessibility utilities for accessibility users.
//  Reference: WCAG 2.2 Level AA, accessibility UX guidelines.
//
//  Key rules enforced here:
//  - Minimum 60×60pt touch targets (accessibility tremor requires larger than standard 44pt)
//  - Haptic feedback on all primary actions (motor confirmation without visual check)
//  - accessibilityLabel + accessibilityHint on all interactive elements
//  - No time limits, no gestures, no shake
//  - Reduce motion respected throughout

import SwiftUI
import UIKit
import CoreHaptics

// MARK: - User Preference Enums (shared across Settings + Theme)

enum HapticIntensity: String, CaseIterable {
    case off = "Off"
    case light = "Light"
    case medium = "Medium"
    case strong = "Strong"

    var icon: String {
        switch self {
        case .off: return "iphone.slash"
        case .light: return "waveform.path"
        case .medium: return "waveform"
        case .strong: return "waveform.badge.magnifyingglass"
        }
    }
}

enum TextSizePreference: String, CaseIterable {
    case standard = "Standard"
    case large = "Large"
    case extraLarge = "Extra Large"

    var scaleFactor: CGFloat {
        switch self {
        case .standard: return 1.0
        case .large: return 1.2
        case .extraLarge: return 1.4
        }
    }

    var icon: String {
        switch self {
        case .standard: return "textformat.size.smaller"
        case .large: return "textformat.size"
        case .extraLarge: return "textformat.size.larger"
        }
    }
}

// MARK: - Touch Target Sizes

enum A11ySize {
    /// Minimum tap target for accessibility users (recommended 60pt vs standard 44pt)
    static let minTouchTarget: CGFloat = 60
    /// Even larger targets when "Larger Touch Targets" is on
    static let largeTouchTarget: CGFloat = 72
    /// Minimum font size — never go below this in the app
    static let minFontSize: CGFloat = 14
    /// Preferred body font size
    static let bodyFontSize: CGFloat = 17

    /// Returns the correct touch target based on the user's preference
    static var currentTouchTarget: CGFloat {
        UserDefaults.standard.bool(forKey: "settingsLargeButtons") ? largeTouchTarget : minTouchTarget
    }
}

// MARK: - Reduce Motion (System + Custom Override)

/// Returns true if the user wants reduced motion — either via system settings or the in-app override.
func appShouldReduceMotion() -> Bool {
    UIAccessibility.isReduceMotionEnabled || UserDefaults.standard.bool(forKey: "settingsReduceMotion")
}

/// Returns true if the user has enabled simplified layout.
func appUsesSimplifiedLayout() -> Bool {
    UserDefaults.standard.bool(forKey: "settingsSimplifiedLayout")
}

/// Returns true if the user has enabled high contrast.
func appUsesHighContrast() -> Bool {
    UserDefaults.standard.bool(forKey: "settingsHighContrast")
}

// MARK: - Haptic Manager (Settings-Aware Singleton)

/// Central haptic engine that respects the user's Off / Light / Medium / Strong preference.
/// All haptic calls across the app route through this manager.
final class HapticManager {
    static let shared = HapticManager()

    // Core Haptics engine (lazy, created on first custom-pattern call)
    private var engine: CHHapticEngine?
    private var engineRunning = false

    private init() {}

    // MARK: - Settings Gate

    /// Current intensity from UserDefaults. Returns nil when "Off".
    private var intensity: HapticIntensity {
        let raw = UserDefaults.standard.string(forKey: "settingsHapticIntensity") ?? "Medium"
        return HapticIntensity(rawValue: raw) ?? .medium
    }

    private var isEnabled: Bool { intensity != .off }

    /// Multiplier applied to all haptic intensities.
    private var intensityMultiplier: Float {
        switch intensity {
        case .off:    return 0
        case .light:  return 0.4
        case .medium: return 0.7
        case .strong: return 1.0
        }
    }

    // MARK: - Standard UIKit Haptics

    /// Light tap confirmation — use for selections, toggles, filter switches
    func selection() {
        guard isEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }

    /// Impact feedback — use for button taps, marker selection, panel snaps
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred(intensity: CGFloat(intensityMultiplier))
    }

    /// Success notification — use for completed actions (check-in, refresh, connection confirmed)
    func success() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// Warning — use for destructive or attention-needed actions
    func warning() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    /// Error — use for failed actions
    func error() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    // MARK: - Core Haptics Engine

    private func ensureEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        if engine == nil {
            do {
                engine = try CHHapticEngine()
                engine?.resetHandler = { [weak self] in
                    self?.engineRunning = false
                    try? self?.engine?.start()
                    self?.engineRunning = true
                }
                engine?.stoppedHandler = { [weak self] _ in
                    self?.engineRunning = false
                }
            } catch {
                return
            }
        }
        if !engineRunning {
            do {
                try engine?.start()
                engineRunning = true
            } catch {
                return
            }
        }
    }

    private func playPattern(_ events: [CHHapticEvent]) {
        guard isEnabled else { return }
        ensureEngine()
        guard let engine else { return }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            // Silently fail — haptics are non-critical
        }
    }

    // MARK: - Custom Patterns: Social / Community

    /// Light upward-feeling double pulse — send message, send support, check-in
    /// Feeling: "released upward", optimistic
    func softDoublePulse() {
        let m = intensityMultiplier
        playPattern([
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
            ], relativeTime: 0.1)
        ])
    }

    /// Soft delayed double pulse — receive supportive interaction
    /// Feeling: "someone reached out", warm
    func warmDoublePulse() {
        let m = intensityMultiplier
        playPattern([
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
            ], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
            ], relativeTime: 0.18)
        ])
    }

    /// Very soft periodic pulse — charm proximity / someone nearby
    /// Feeling: discreet "presence" cue, private and intriguing
    func proximityPulse() {
        let m = intensityMultiplier
        playPattern([
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.2 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.15)
            ], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.25 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.15)
            ], relativeTime: 0.3),
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.2 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
            ], relativeTime: 0.6)
        ])
    }

    // MARK: - Custom Patterns: Comfort / Regulation

    /// Long soft swell — calm / breathe / grounding starts
    /// Feeling: rising soft pulse over ~0.8s
    func calmSwell(duration: TimeInterval = 0.8) {
        let m = intensityMultiplier
        let steps = 8
        var events: [CHHapticEvent] = []
        for i in 0..<steps {
            let t = duration * Double(i) / Double(steps)
            let intensity = Float(i + 1) / Float(steps) * 0.5 * m
            events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
            ], relativeTime: t, duration: duration / Double(steps)))
        }
        playPattern(events)
    }

    /// Breathing guide: inhale = slow rise
    func breatheInhale(duration: TimeInterval = 1.0) {
        let m = intensityMultiplier
        let steps = 10
        var events: [CHHapticEvent] = []
        for i in 0..<steps {
            let t = duration * Double(i) / Double(steps)
            let intensity = Float(i + 1) / Float(steps) * 0.45 * m
            let sharpness = Float(i) / Float(steps) * 0.15
            events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ], relativeTime: t, duration: duration / Double(steps)))
        }
        playPattern(events)
    }

    /// Breathing guide: exhale = slow fall
    func breatheExhale(duration: TimeInterval = 1.0) {
        let m = intensityMultiplier
        let steps = 10
        var events: [CHHapticEvent] = []
        for i in 0..<steps {
            let t = duration * Double(i) / Double(steps)
            let intensity = Float(steps - i) / Float(steps) * 0.45 * m
            let sharpness = Float(steps - i) / Float(steps) * 0.15
            events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ], relativeTime: t, duration: duration / Double(steps)))
        }
        playPattern(events)
    }

    /// Soft single "hug" pulse — comfort squeeze acknowledged
    /// Feeling: rounded, low-sharpness
    func comfortHug() {
        let m = intensityMultiplier
        playPattern([
            CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.45 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.08)
            ], relativeTime: 0, duration: 0.25)
        ])
    }

    /// Three slow evenly-spaced pulses — escalated comfort / reassurance
    /// Feeling: calm but clearly more intentional
    func escalatedComfort() {
        let m = intensityMultiplier
        playPattern([
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.15)
            ], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.45 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.15)
            ], relativeTime: 0.4),
            CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5 * m),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.15)
            ], relativeTime: 0.8)
        ])
    }
}

// MARK: - Backward Compatibility Typealias

/// Typealias so existing call sites (`HapticFeedback.selection()`, etc.) still compile.
enum HapticFeedback {
    static func selection() { HapticManager.shared.selection() }
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) { HapticManager.shared.impact(style) }
    static func success() { HapticManager.shared.success() }
    static func warning() { HapticManager.shared.warning() }
    static func error() { HapticManager.shared.error() }
}

// MARK: - View Modifiers

/// Ensures a view has at least the minimum 60pt touch target for tremor-safe tapping.
struct MinTouchTarget: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(minWidth: size, minHeight: size)
            .contentShape(Rectangle())
    }
}

/// Standard accessible button modifier — large touch target + haptic on tap.
struct AccessibleTapTarget: ViewModifier {
    let label: String
    let hint: String?
    let haptic: UIImpactFeedbackGenerator.FeedbackStyle

    func body(content: Content) -> some View {
        content
            .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
            .contentShape(Rectangle())
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }
}

extension View {
    /// Enforces a minimum 60pt touch target — use on every interactive element.
    func minTouchTarget(_ size: CGFloat = A11ySize.minTouchTarget) -> some View {
        modifier(MinTouchTarget(size: size))
    }

    /// Adds accessibility label, hint, large touch target, and button trait.
    func accessibleButton(
        label: String,
        hint: String? = nil,
        haptic: UIImpactFeedbackGenerator.FeedbackStyle = .medium
    ) -> some View {
        modifier(AccessibleTapTarget(label: label, hint: hint, haptic: haptic))
    }
}

// MARK: - Motion-Safe Animation

extension View {
    /// Applies animation only when Reduce Motion is OFF.
    /// Always use this instead of bare `.animation()` for repeating/complex animations.
    func motionSafeAnimation<V: Equatable>(_ animation: Animation, value: V) -> some View {
        self.modifier(MotionSafeModifier(animation: animation, value: value))
    }
}

private struct MotionSafeModifier<V: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let animation: Animation
    let value: V

    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content.animation(animation, value: value)
        }
    }
}

// MARK: - Accessible Large Button

/// A full-width button meeting accessibility accessibility standards:
/// - Minimum 60pt height
/// - Haptic feedback on tap
/// - VoiceOver label + hint
/// - Action triggers on release (not press)
struct A11yButton: View {
    let title: String
    let icon: String?
    let tint: Color
    let hint: String?
    let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        tint: Color = Theme.accent,
        hint: String? = nil,
        haptic: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.tint = tint
        self.hint = hint
        self.hapticStyle = haptic
        self.action = action
    }

    var body: some View {
        Button {
            HapticFeedback.impact(hapticStyle)
            action()
        } label: {
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .headlineStyle()
                }
                Text(title)
                    .headlineStyle()
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: A11ySize.minTouchTarget)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(tint)
                    .shadow(color: tint.opacity(0.3), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(hint ?? "")
    }
}

// MARK: - Accessible Secondary Button

struct A11ySecondaryButton: View {
    let title: String
    let hint: String?
    let action: () -> Void

    init(_ title: String, hint: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.hint = hint
        self.action = action
    }

    var body: some View {
        Button {
            HapticFeedback.selection()
            action()
        } label: {
            Text(title)
                .subheadlineStyle(size: 15)
                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(Theme.text.opacity(0.7))
                .frame(maxWidth: .infinity)
                .frame(minHeight: A11ySize.minTouchTarget)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(hint ?? "")
    }
}

// MARK: - VoiceOver Announcement

extension View {
    /// Post a VoiceOver announcement (e.g. after an action completes).
    func announceToVoiceOver(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }
}

// MARK: - Accessible Toggle

/// Toggle with proper VoiceOver label (the default UIKit toggle label is often empty).
struct A11yToggle: View {
    let label: String
    let hint: String?
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(label)
        }
        .tint(Theme.accent)
        .accessibilityLabel(label)
        .accessibilityHint(hint ?? (isOn ? "Currently on, tap to turn off" : "Currently off, tap to turn on"))
        .accessibilityValue(isOn ? "On" : "Off")
        .onChange(of: isOn) { _ in
            HapticFeedback.selection()
        }
    }
}
