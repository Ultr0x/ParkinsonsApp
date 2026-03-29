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
                        .padding(.bottom, 32)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
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
                
                Image(systemName: "asterisk")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(asteriskScale > 1.05 ? 15 : 0))
            }
            .frame(width: 250, height: 250)
            
            Text("Looking for community members nearby...")
                .font(.headline.weight(.medium))
                .fontDesign(.rounded)
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
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Theme.text)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Theme.accent.opacity(0.2))
                                .frame(width: 50, height: 50)
                            Text(sampleMatch.initial)
                                .font(.title2.weight(.bold))
                                .foregroundStyle(Theme.accent)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Diagnosed \(sampleMatch.yearsSinceDiagnosis) years ago")
                                .font(.subheadline.weight(.medium))
                            Text(sampleMatch.stage.rawValue)
                                .font(.footnote)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Theme.pill(tint: Theme.accent))
                            
                            Text("Shared interests: \(sampleMatch.sharedInterests.joined(separator: ", "))")
                                .font(.footnote.weight(.medium))
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
                            acceptMatch()
                        } label: {
                            Text("Say hello")
                                .font(.headline.weight(.bold))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Not now")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.text.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .padding(.top, 24)
            } else if phase == .revealed {
                // Revealed Content
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 8)
                    
                    Text(sampleMatch.fullName)
                        .font(.title.weight(.heavy))
                        .foregroundStyle(Theme.text)
                    
                    Text("Diagnosed 2024 · \(sampleMatch.stage.rawValue)")
                        .font(.subheadline.weight(.medium))
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
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.text)
                    .padding(16)
                    .background(Theme.glassBackground)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Send a message")
                                .font(.headline.weight(.bold))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Maybe later")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.text.opacity(0.6))
                        }
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
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                phase = .found
            }
        }
    }
    
    private func acceptMatch() {
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
