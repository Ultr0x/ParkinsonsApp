//
//  CharmSettingsView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 30/03/2026.
//

import SwiftUI

// MARK: - Squeeze Signal Customisation

enum SqueezeAction: String, CaseIterable {
    case imOkay = "I'm okay"
    case comeFind = "Come find me"
    case letsLeave = "Let's leave"
    case needHelp = "I need help"
    case thinking = "Thinking of you"
    case custom = "Custom…"
    
    var icon: String {
        switch self {
        case .imOkay: return "hand.thumbsup.fill"
        case .comeFind: return "location.fill"
        case .letsLeave: return "arrow.right.circle.fill"
        case .needHelp: return "exclamationmark.circle.fill"
        case .thinking: return "heart.fill"
        case .custom: return "pencil.circle.fill"
        }
    }
}

// MARK: - Charm Settings View

struct CharmSettingsView: View {
    @AppStorage("charmQuickSqueeze") private var quickSqueezeRaw: String = SqueezeAction.imOkay.rawValue
    @AppStorage("charmLongSqueeze") private var longSqueezeRaw: String = SqueezeAction.comeFind.rawValue
    @AppStorage("charmDoubleSqueeze") private var doubleSqueezeRaw: String = SqueezeAction.letsLeave.rawValue
    @AppStorage("charmComfortHaptic") private var comfortHapticEnabled: Bool = true
    @AppStorage("charmBreathingHaptic") private var breathingHapticEnabled: Bool = true
    @AppStorage("charmProximityHaptic") private var proximityHapticEnabled: Bool = true
    @AppStorage("settingsHapticIntensity") private var hapticIntensityRaw: String = HapticIntensity.medium.rawValue
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        connectionStatusSection
                        squeezeSignalsSection
                        hapticPatternsSection
                        comfortSection
                        previewSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Charm Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        HapticFeedback.selection()
                        dismiss()
                    }
                    .headlineStyle(size: 16)
                    .foregroundStyle(Theme.accent)
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Connection Status
    
    private var connectionStatusSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Connection", icon: "antenna.radiowaves.left.and.right", subtitle: "Your charm device")
            
            StigmaCard {
                VStack(spacing: 14) {
                    // Status row
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Theme.accent.opacity(0.15))
                                .frame(width: 56, height: 56)
                            Image(systemName: "hand.tap.fill")
                                .titleStyle(size: 24)
                                .foregroundStyle(Theme.accent)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Theme.green)
                                    .frame(width: 8, height: 8)
                                Text("Connected")
                                    .subheadlineStyle(size: 15)
                                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text)
                            }
                            Text("Linked to \(sampleUser.companionName ?? "companion")")
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.5))
                            Text("Last signal: 2h ago")
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.4))
                        }
                        
                        Spacer()
                        
                        // Battery indicator
                        VStack(spacing: 2) {
                            Image(systemName: "battery.75")
                                .titleStyle(size: 20)
                                .foregroundStyle(Theme.green)
                            Text("75%")
                                .captionStyle(size: 11)
                                .foregroundStyle(Theme.text.opacity(0.5))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Squeeze Signals
    
    private var squeezeSignalsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Squeeze Signals", icon: "hand.point.up.fill", subtitle: "What each squeeze means")
            
            StigmaCard {
                VStack(spacing: 0) {
                    squeezeRow(
                        gesture: "Quick squeeze",
                        gestureIcon: "1.circle.fill",
                        description: "A short single press",
                        selection: $quickSqueezeRaw,
                        hapticPreview: { HapticManager.shared.comfortHug() }
                    )
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    squeezeRow(
                        gesture: "Long squeeze",
                        gestureIcon: "ellipsis.circle.fill",
                        description: "Press and hold for 2 seconds",
                        selection: $longSqueezeRaw,
                        hapticPreview: { HapticManager.shared.calmSwell() }
                    )
                    .padding(.vertical, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    squeezeRow(
                        gesture: "Double squeeze",
                        gestureIcon: "2.circle.fill",
                        description: "Two quick presses",
                        selection: $doubleSqueezeRaw,
                        hapticPreview: { HapticManager.shared.softDoublePulse() }
                    )
                    .padding(.top, 14)
                }
            }
        }
    }
    
    // MARK: - Haptic Patterns
    
    private var hapticPatternsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Haptic Patterns", icon: "waveform.path", subtitle: "What you feel")
            
            StigmaCard {
                VStack(spacing: 0) {
                    hapticToggle(
                        icon: "person.wave.2.fill",
                        tint: Theme.accent,
                        title: "Proximity Detection",
                        subtitle: "Soft pulse when a community member is nearby",
                        isOn: $proximityHapticEnabled,
                        preview: { HapticManager.shared.proximityPulse() }
                    )
                    .padding(.bottom, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    hapticToggle(
                        icon: "heart.fill",
                        tint: Color(hex: 0xE85D75),
                        title: "Comfort Squeeze",
                        subtitle: "Warm hug pulse when you squeeze for comfort",
                        isOn: $comfortHapticEnabled,
                        preview: { HapticManager.shared.comfortHug() }
                    )
                    .padding(.vertical, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    hapticToggle(
                        icon: "wind",
                        tint: Theme.cyan,
                        title: "Breathing Guide",
                        subtitle: "Rising and falling waves to guide your breathing",
                        isOn: $breathingHapticEnabled,
                        preview: {
                            HapticManager.shared.breatheInhale(duration: 0.6)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                HapticManager.shared.breatheExhale(duration: 0.6)
                            }
                        }
                    )
                    .padding(.top, 14)
                }
            }
        }
    }
    
    // MARK: - Comfort Section
    
    private var comfortSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Comfort & Calm", icon: "leaf.fill", subtitle: "Grounding interactions")
            
            StigmaCard {
                VStack(alignment: .leading, spacing: 14) {
                    Text("When you need a moment of calm, your charm responds with gentle, soothing haptics designed to ground you.")
                        .captionStyle()
                        .foregroundStyle(Theme.text.opacity(0.6))
                        .lineSpacing(3)
                    
                    // Calm swell preview
                    Button {
                        HapticManager.shared.calmSwell(duration: 1.0)
                    } label: {
                        HStack(spacing: 12) {
                            settingIcon("sparkles", tint: Theme.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Try Calm Swell")
                                    .subheadlineStyle(size: 15)
                                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text)
                                Text("A slow, soft wave that rises gently")
                                    .captionStyle()
                                    .foregroundStyle(Theme.text.opacity(0.5))
                            }
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .titleStyle(size: 22)
                                .foregroundStyle(Theme.accent)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // Escalated comfort preview
                    Button {
                        HapticManager.shared.escalatedComfort()
                    } label: {
                        HStack(spacing: 12) {
                            settingIcon("hand.raised.fill", tint: Theme.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Try Reassurance Mode")
                                    .subheadlineStyle(size: 15)
                                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text)
                                Text("Three slow, intentional pulses")
                                    .captionStyle()
                                    .foregroundStyle(Theme.text.opacity(0.5))
                            }
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .titleStyle(size: 22)
                                .foregroundStyle(Theme.orange)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Preview All Section
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Preview", icon: "hand.tap", subtitle: "Test all patterns")
            
            StigmaCard {
                VStack(spacing: 10) {
                    previewButton("Selection Tick", icon: "checkmark.circle", color: Theme.text) {
                        HapticManager.shared.selection()
                    }
                    previewButton("Soft Impact", icon: "circle.circle", color: Theme.cyan) {
                        HapticManager.shared.impact(.soft)
                    }
                    previewButton("Medium Impact", icon: "circle.circle.fill", color: Theme.accent) {
                        HapticManager.shared.impact(.medium)
                    }
                    previewButton("Success", icon: "checkmark.seal.fill", color: Theme.green) {
                        HapticManager.shared.success()
                    }
                    previewButton("Social Send", icon: "arrow.up.circle.fill", color: Theme.accent) {
                        HapticManager.shared.softDoublePulse()
                    }
                    previewButton("Someone Nearby", icon: "person.wave.2.fill", color: Theme.orange) {
                        HapticManager.shared.proximityPulse()
                    }
                    previewButton("Warm Receive", icon: "arrow.down.heart.fill", color: Color(hex: 0xE85D75)) {
                        HapticManager.shared.warmDoublePulse()
                    }
                    previewButton("Comfort Hug", icon: "heart.circle.fill", color: Color(hex: 0xE85D75)) {
                        HapticManager.shared.comfortHug()
                    }
                    previewButton("Breathe In", icon: "arrow.up", color: Theme.cyan) {
                        HapticManager.shared.breatheInhale(duration: 0.8)
                    }
                    previewButton("Breathe Out", icon: "arrow.down", color: Theme.cyan) {
                        HapticManager.shared.breatheExhale(duration: 0.8)
                    }
                }
            }
        }
    }
    
    // MARK: - Shared Components
    
    private func sectionHeader(title: String, icon: String, subtitle: String?) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .captionStyle()
                .foregroundStyle(Theme.text.opacity(0.4))
            Text(title)
                .labelStyle()
                .foregroundStyle(Theme.text.opacity(0.5))
            if let subtitle {
                Text("· \(subtitle)")
                    .captionStyle()
                    .foregroundStyle(Theme.text.opacity(0.3))
            }
            Spacer()
        }
        .padding(.bottom, 8)
        .padding(.leading, 4)
    }
    
    private func settingIcon(_ name: String, tint: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(tint.opacity(0.12))
                .frame(width: 34, height: 34)
            Image(systemName: name)
                .captionStyle()
                .foregroundStyle(tint)
        }
    }
    
    private func squeezeRow(
        gesture: String,
        gestureIcon: String,
        description: String,
        selection: Binding<String>,
        hapticPreview: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                settingIcon(gestureIcon, tint: Theme.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text(gesture)
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text)
                    Text(description)
                        .captionStyle()
                        .foregroundStyle(Theme.text.opacity(0.4))
                }
                
                Spacer()
                
                // Preview button
                Button {
                    hapticPreview()
                } label: {
                    Image(systemName: "play.circle.fill")
                        .titleStyle(size: 20)
                        .foregroundStyle(Theme.accent.opacity(0.6))
                }
            }
            
            Picker(gesture, selection: selection) {
                ForEach(SqueezeAction.allCases, id: \.rawValue) { action in
                    Text(action.rawValue).tag(action.rawValue)
                }
            }
            .pickerStyle(.menu)
            .tint(Theme.accent)
            .onChange(of: selection.wrappedValue) { _ in
                HapticFeedback.selection()
            }
        }
    }
    
    private func hapticToggle(
        icon: String,
        tint: Color,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>,
        preview: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 12) {
            settingIcon(icon, tint: tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .subheadlineStyle(size: 15)
                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(Theme.text)
                Text(subtitle)
                    .captionStyle()
                    .foregroundStyle(Theme.text.opacity(0.5))
            }
            
            Spacer()
            
            // Preview
            Button {
                preview()
            } label: {
                Image(systemName: "play.circle")
                    .footnoteStyle()
                    .foregroundStyle(tint.opacity(0.6))
            }
            .frame(minWidth: 34, minHeight: 34)
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(tint)
                .onChange(of: isOn.wrappedValue) { _ in
                    HapticFeedback.selection()
                }
        }
    }
    
    private func previewButton(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .footnoteStyle()
                    .foregroundStyle(color)
                    .frame(width: 24)
                Text(title)
                    .labelStyle()
                    .foregroundStyle(Theme.text)
                Spacer()
                Image(systemName: "play.fill")
                    .caption2Style()
                    .foregroundStyle(Theme.text.opacity(0.3))
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CharmSettingsView()
}
