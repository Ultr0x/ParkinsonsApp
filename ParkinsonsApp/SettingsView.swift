//
//  SettingsView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 30/03/2026.
//

import SwiftUI

// HapticIntensity and TextSizePreference enums are in Accessibility.swift

// MARK: - Settings View

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("onboardingJourneyStage") private var journeyStageRaw: String = ""
    @AppStorage("onboardingExperiences") private var experiencesRaw: String = ""
    @AppStorage("onboardingBodyDistribution") private var bodyDistributionRaw: String = ""
    @AppStorage("onboardingBestTime") private var bestTimeRaw: String = ""
    @AppStorage("onboardingInterests") private var interestsRaw: String = ""
    @AppStorage("detailedSymptomProfile") private var profileData: String = ""
    
    // Accessibility preferences
    @AppStorage("settingsTextSize") private var textSizeRaw: String = TextSizePreference.standard.rawValue
    @AppStorage("settingsHapticIntensity") private var hapticIntensityRaw: String = HapticIntensity.medium.rawValue
    @AppStorage("settingsReduceMotion") private var reduceMotionOverride: Bool = false
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false
    @AppStorage("settingsLargeButtons") private var largeButtons: Bool = false
    @AppStorage("settingsPreventAutoLock") private var preventAutoLock: Bool = false
    @AppStorage("settingsSimplifiedLayout") private var simplifiedLayout: Bool = false
    @AppStorage("settingsVoiceOverHints") private var voiceOverHints: Bool = true
    
    @State private var isDiscoverable = sampleUser.isDiscoverable
    @State private var showSignOutAlert = false
    @State private var showDeleteAlert = false
    @State private var showResetSettingsAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    private var textSize: TextSizePreference {
        TextSizePreference(rawValue: textSizeRaw) ?? .standard
    }
    
    private var hapticIntensity: HapticIntensity {
        HapticIntensity(rawValue: hapticIntensityRaw) ?? .medium
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        accessibilitySection
                        displaySection
                        interactionSection
                        privacySection
                        generalSection
                        dangerZone
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .headlineStyle(size: 16)
                        .foregroundStyle(Theme.accent)
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) { resetProfile() }
            } message: {
                Text("You'll return to the welcome screen and can set up your profile again.")
            }
            .alert("Delete Account", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete Everything", role: .destructive) { resetProfile() }
            } message: {
                Text("This will remove all your data and return you to the start. This cannot be undone.")
            }
            .alert("Reset Settings", isPresented: $showResetSettingsAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) { resetAccessibilitySettings() }
            } message: {
                Text("This will return all accessibility and display settings to their defaults.")
            }
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Accessibility Section
    
    private var accessibilitySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Accessibility", icon: "accessibility", subtitle: "Tailored for your needs")
            
            StigmaCard {
                VStack(spacing: 0) {
                    // Text Size
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            settingIcon("textformat.size", tint: Theme.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Text Size")
                                    .subheadlineStyle(size: 15)
                                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text)
                                Text(textSize.rawValue)
                                    .captionStyle()
                                    .foregroundStyle(Theme.text.opacity(0.5))
                            }
                        }
                        
                        Picker("Text Size", selection: $textSizeRaw) {
                            ForEach(TextSizePreference.allCases, id: \.rawValue) { size in
                                Text(size.rawValue).tag(size.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityLabel("Text size")
                        .accessibilityHint("Choose between standard, large, or extra large text")

                        // Live preview
                        HStack(spacing: 8) {
                            Image(systemName: "eye")
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.4))
                            Text("Preview: This is how text will look")
                                .subheadlineStyle()
                                .foregroundStyle(Theme.text.opacity(0.7))
                        }
                        .padding(.top, 6)
                        .animation(.easeInOut(duration: 0.2), value: textSizeRaw)
                    }
                    .padding(.bottom, 16)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // Large Buttons
                    settingToggle(
                        icon: "hand.tap.fill",
                        tint: Theme.accent,
                        title: "Larger Touch Targets",
                        subtitle: "Extra-large buttons for easier tapping",
                        isOn: $largeButtons
                    )
                    .padding(.vertical, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // Simplified Layout
                    settingToggle(
                        icon: "square.grid.2x2",
                        tint: Theme.cyan,
                        title: "Simplified Layout",
                        subtitle: "Hides photos, avatars & extra cards for clarity",
                        isOn: $simplifiedLayout
                    )
                    .padding(.vertical, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // VoiceOver Hints
                    settingToggle(
                        icon: "speaker.wave.3.fill",
                        tint: Theme.green,
                        title: "VoiceOver Hints",
                        subtitle: "Extra spoken guidance on buttons and controls",
                        isOn: $voiceOverHints
                    )
                    .padding(.top, 14)
                }
            }
        }
    }
    
    // MARK: - Display Section
    
    private var displaySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Display", icon: "eye.fill", subtitle: "Visual comfort")
            
            StigmaCard {
                VStack(spacing: 0) {
                    // Reduce Motion
                    settingToggle(
                        icon: "figure.walk.motion",
                        tint: Theme.orange,
                        title: "Reduce Motion",
                        subtitle: "Fewer animations and transitions",
                        isOn: $reduceMotionOverride
                    )
                    .padding(.bottom, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // High Contrast
                    settingToggle(
                        icon: "circle.lefthalf.filled",
                        tint: Theme.text,
                        title: "High Contrast",
                        subtitle: "Stronger outlines and bolder text",
                        isOn: $highContrast
                    )
                    .padding(.top, 14)
                }
            }
        }
    }
    
    // MARK: - Interaction Section
    
    private var interactionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Touch & Feedback", icon: "hand.raised.fill", subtitle: "How the app responds to you")
            
            StigmaCard {
                VStack(spacing: 0) {
                    // Haptic Intensity
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            settingIcon("waveform", tint: Theme.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Haptic Feedback")
                                    .subheadlineStyle(size: 15)
                                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text)
                                Text(hapticIntensity.rawValue)
                                    .captionStyle()
                                    .foregroundStyle(Theme.text.opacity(0.5))
                            }
                        }
                        
                        Picker("Haptic Intensity", selection: $hapticIntensityRaw) {
                            ForEach(HapticIntensity.allCases, id: \.rawValue) { intensity in
                                Text(intensity.rawValue).tag(intensity.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityLabel("Haptic feedback intensity")
                        .accessibilityHint("Choose between off, light, medium, or strong vibration feedback")
                        .onChange(of: hapticIntensityRaw) { newValue in
                            // Preview the selected haptic
                            switch HapticIntensity(rawValue: newValue) {
                            case .light: HapticFeedback.impact(.light)
                            case .medium: HapticFeedback.impact(.medium)
                            case .strong: HapticFeedback.impact(.heavy)
                            default: break
                            }
                        }
                    }
                    .padding(.bottom, 16)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // Prevent Auto Lock
                    settingToggle(
                        icon: "lock.open.fill",
                        tint: Theme.orange,
                        title: "Keep Screen On",
                        subtitle: "Prevents screen from locking during use",
                        isOn: $preventAutoLock
                    )
                    .padding(.top, 14)
                    .onChange(of: preventAutoLock) { newValue in
                        UIApplication.shared.isIdleTimerDisabled = newValue
                    }
                }
            }
        }
    }
    
    // MARK: - Privacy Section
    
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Privacy", icon: "lock.shield.fill", subtitle: "Control your visibility")
            
            StigmaCard {
                VStack(spacing: 0) {
                    // Discoverable
                    settingToggle(
                        icon: "eye",
                        tint: Theme.accent,
                        title: "Discoverable to Members",
                        subtitle: "Let nearby Stigma members find you",
                        isOn: $isDiscoverable
                    )
                    .padding(.bottom, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // Notifications
                    settingNavRow(
                        icon: "bell.badge.fill",
                        tint: Theme.cyan,
                        title: "Notifications",
                        subtitle: "Manage alerts and reminders"
                    )
                    .padding(.vertical, 14)
                }
            }
        }
    }
    
    // MARK: - General Section
    
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "General", icon: "gearshape.fill", subtitle: nil)
            
            StigmaCard {
                VStack(spacing: 0) {
                    settingNavRow(
                        icon: "info.circle.fill",
                        tint: Theme.text.opacity(0.6),
                        title: "About Stigma",
                        subtitle: "Version 1.0 · Built with care"
                    )
                    .padding(.bottom, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // Reset accessibility settings
                    Button {
                        showResetSettingsAlert = true
                    } label: {
                        HStack(spacing: 12) {
                            settingIcon("arrow.counterclockwise", tint: Theme.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Reset Accessibility Settings")
                                    .subheadlineStyle(size: 15)
                                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text)
                                Text("Return all settings to defaults")
                                    .captionStyle()
                                    .foregroundStyle(Theme.text.opacity(0.5))
                            }
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 14)
                }
            }
        }
    }
    
    // MARK: - Danger Zone
    
    private var dangerZone: some View {
        VStack(alignment: .leading, spacing: 0) {
            StigmaCard {
                VStack(spacing: 0) {
                    // Sign Out
                    Button {
                        showSignOutAlert = true
                    } label: {
                        HStack(spacing: 12) {
                            settingIcon("rectangle.portrait.and.arrow.right", tint: .orange)
                            Text("Sign Out")
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(.orange)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.2))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 14)
                    
                    Divider().background(Theme.text.opacity(0.08))
                    
                    // Delete Account
                    Button {
                        showDeleteAlert = true
                    } label: {
                        HStack(spacing: 12) {
                            settingIcon("trash.fill", tint: .red)
                            Text("Delete Account")
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(.red)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.2))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 14)
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
    
    private func settingToggle(
        icon: String,
        tint: Color,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>
    ) -> some View {
        Toggle(isOn: isOn) {
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
            }
        }
        .tint(Theme.accent)
        .accessibilityLabel(title)
        .accessibilityHint(subtitle)
        .onChange(of: isOn.wrappedValue) { _ in
            HapticFeedback.selection()
        }
    }
    
    private func settingNavRow(icon: String, tint: Color, title: String, subtitle: String) -> some View {
        Button {
            // Navigate
        } label: {
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
                Image(systemName: "chevron.right")
                    .captionStyle()
                    .foregroundStyle(Theme.text.opacity(0.2))
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Actions
    
    private func resetProfile() {
        userName = ""
        journeyStageRaw = ""
        experiencesRaw = ""
        bodyDistributionRaw = ""
        bestTimeRaw = ""
        interestsRaw = ""
        profileData = ""
        hasCompletedOnboarding = false
    }
    
    private func resetAccessibilitySettings() {
        textSizeRaw = TextSizePreference.standard.rawValue
        hapticIntensityRaw = HapticIntensity.medium.rawValue
        reduceMotionOverride = false
        highContrast = false
        largeButtons = false
        preventAutoLock = false
        simplifiedLayout = false
        voiceOverHints = true
        HapticFeedback.success()
    }
}

#Preview {
    SettingsView()
}
