//
//  MatchmakingOverlay.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

enum MatchmakingPhase {
    case scanning
    case found
    case revealed
}

struct MatchmakingOverlay: View {
    @Binding var isVisible: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var phase: MatchmakingPhase = .scanning
    @State private var radarScale: CGFloat = 0.5
    @State private var asteriskScale: CGFloat = 1.0
    @State private var isRevealed: Bool = false

    // Animate radar rings
    @State private var ring1Scale: CGFloat = 0.8
    @State private var ring1Opacity: Double = 0.8
    @State private var ring2Scale: CGFloat = 0.8
    @State private var ring2Opacity: Double = 0.8
    
    var body: some View {
        ZStack {
            // Darken background
            Color.black.opacity(0.4)
                .ignoresSafeArea()  	
                .onTapGesture {
                    if phase == .found { dismiss() }
                }
            
            if phase == .scanning {
                scanningPhaseView
            } else {
                VStack {
                    Spacer()
                    foundAndRevealCard
                        .padding(.bottom, 80)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            startScanning()
        }
    }
    
    // MARK: - Subviews
    
    private var scanningPhaseView: some View {
        VStack(spacing: 32) {
            ZStack {
                // Radar rings
                Circle()
                    .stroke(Theme.accent.opacity(0.4), lineWidth: 2)
                    .scaleEffect(ring2Scale)
                    .opacity(ring2Opacity)
                
                Circle()
                    .stroke(Theme.accent.opacity(0.6), lineWidth: 3)
                    .scaleEffect(ring1Scale)
                    .opacity(ring1Opacity)
                
                // Central Asterisk
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 80, height: 80)
                    .scaleEffect(asteriskScale)
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(asteriskScale > 1.05 ? 15 : 0))
            }
            .frame(width: 250, height: 250)
            
            Text("Looking for community members nearby...")
                .headlineStyle()

                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var foundAndRevealCard: some View {
        VStack(spacing: 0) {
            if phase == .found {
                // Found (Anonymized) Content
                VStack(spacing: 16) {
                    Text("Someone from the community is nearby")
                        .headlineStyle()
                        .foregroundStyle(Theme.text)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Theme.accent.opacity(0.2))
                                .frame(width: 50, height: 50)
                            Text(sampleMatch.initial)
                                .titleStyle(size: 22)
                                .foregroundStyle(Theme.accent)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Diagnosed \(sampleMatch.yearsSinceDiagnosis) years ago")
                                .subheadlineStyle()
                            Text(sampleMatch.stage.rawValue)
                                .footnoteStyle()
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Theme.pill(tint: Theme.accent))
                            
                            Text("Shared interests: \(sampleMatch.sharedInterests.joined(separator: ", "))")
                                .footnoteStyle()
                                .foregroundStyle(Theme.text.opacity(0.8))
                                .padding(.top, 4)
                        }
                        .foregroundStyle(Theme.text)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button {
                            HapticFeedback.impact(.heavy)
                            acceptMatch()
                        } label: {
                            Text("Say hello")
                                .headlineStyle()
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: A11ySize.minTouchTarget)
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .accessibilityLabel("Say hello")
                        .accessibilityHint("Reveals who this community member is")

                        Button {
                            HapticFeedback.selection()
                            dismiss()
                        } label: {
                            Text("Not now")
                                .subheadlineStyle()
                                .foregroundStyle(Theme.text.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: A11ySize.minTouchTarget)
                        }
                        .accessibilityLabel("Not now")
                        .accessibilityHint("Dismisses this match")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .padding(.top, 24)
            } else if phase == .revealed {
                // Revealed Content
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .titleStyle(size: 34)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 8)
                    
                    Text(sampleMatch.fullName)
                        .titleStyle()
                        .foregroundStyle(Theme.text)
                    
                    Text("Diagnosed 2024 · \(sampleMatch.stage.rawValue)")
                        .subheadlineStyle()
                        .foregroundStyle(Theme.text.opacity(0.8))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Theme.accent)
                            Text("Likes: \(sampleMatch.sharedInterests.joined(separator: ", ")), Coffee")
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "figure.walk")
                                .foregroundStyle(Theme.green)
                            Text("Attends: \(sampleMatch.groups.first ?? "Community events")")
                            Spacer()
                        }
                    }
                    .footnoteStyle(size: 13)
                    .stigmaFont(size: 13, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(Theme.text)
                    .padding(16)
                    .background(Theme.glassBackground)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            HapticManager.shared.softDoublePulse()
                            dismiss()
                        } label: {
                            Text("Send a message")
                                .headlineStyle()
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: A11ySize.minTouchTarget)
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .accessibilityLabel("Send a message to \(sampleMatch.fullName)")
                        .accessibilityHint("Opens a message conversation")

                        Button {
                            HapticFeedback.selection()
                            dismiss()
                        } label: {
                            Text("Maybe later")
                                .subheadlineStyle()
                                .foregroundStyle(Theme.text.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: A11ySize.minTouchTarget)
                        }
                        .accessibilityLabel("Maybe later")
                        .accessibilityHint("Dismisses without messaging")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .padding(.top, 16)
            }
        }
        .frame(height: phase == .revealed ? 440 : 340)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Theme.background)
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - Logic
    
    private func startScanning() {
        if reduceMotion {
            // Skip animation, go straight to found state
            phase = .found
            return
        }

        // Pulse asterisk
        withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
            asteriskScale = 1.1
        }

        // Radar ring 1
        withAnimation(.easeOut(duration: 2.0).repeatForever(autoreverses: false)) {
            ring1Scale = 2.5
            ring1Opacity = 0.0
        }

        // Radar ring 2 (delayed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 2.0).repeatForever(autoreverses: false)) {
                ring2Scale = 2.5
                ring2Opacity = 0.0
            }
        }

        // Simulate finding someone after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            HapticManager.shared.warmDoublePulse()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                phase = .found
            }
        }
    }
    
    private func acceptMatch() {
        HapticManager.shared.success()
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            phase = .revealed
        }
    }
    
    private func dismiss() {
        withAnimation(.easeIn(duration: 0.2)) {
            isVisible = false
            // Reset state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                phase = .scanning
            }
        }
    }
}

#Preview {
    MatchmakingOverlay(isVisible: .constant(true))
}

