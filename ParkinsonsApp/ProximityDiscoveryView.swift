//
//  ProximityDiscoveryView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

// MARK: - Discovery Types

enum DiscoveryType {
    case person(CommunityFolk)
    case venue(CommunityPlace)
}

// MARK: - Fullscreen Discovery Overlay

struct ProximityDiscoveryOverlay: View {
    let discovery: DiscoveryType
    let onDismiss: () -> Void
    let onOpen: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Animation state
    @State private var phase: Int = 0
    @State private var pulseScale: CGFloat = 0.5
    @State private var pulseOpacity: Double = 0
    @State private var iconScale: CGFloat = 0.0
    @State private var iconOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var subtitleOpacity: Double = 0
    @State private var detailOpacity: Double = 0
    @State private var detailOffset: CGFloat = 15
    @State private var ctaOpacity: Double = 0
    @State private var ctaScale: CGFloat = 0.8
    @State private var gradientRotation: Double = 0
    @State private var bgOpacity: Double = 0
    @State private var ringScale1: CGFloat = 0.3
    @State private var ringScale2: CGFloat = 0.3
    @State private var ringScale3: CGFloat = 0.3
    
    private var accentColor: Color {
        switch discovery {
        case .person: return Theme.accent
        case .venue(let place): return place.category.color
        }
    }
    
    var body: some View {
        ZStack {
            // Animated dark gradient background
            Color.black.opacity(bgOpacity * 0.6)
                .ignoresSafeArea()
            
            // Rotating radial accent glow
            AngularGradient(
                colors: [
                    accentColor.opacity(0.2),
                    accentColor.opacity(0.05),
                    accentColor.opacity(0.15),
                    accentColor.opacity(0.05),
                    accentColor.opacity(0.2),
                ],
                center: .center,
                angle: .degrees(gradientRotation)
            )
            .ignoresSafeArea()
            .opacity(bgOpacity)
            .blur(radius: 60)
            
            // Bottom gradient for text readability
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, .black.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 400)
            }
            .ignoresSafeArea()
            .opacity(bgOpacity)
            
            VStack(spacing: 0) {
                // Close button
                HStack {
                    Spacer()
                    Button {
                        dismissOverlay()
                    } label: {
                        Image(systemName: "xmark")
                            .headlineStyle()
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
                            .background(Circle().fill(.white.opacity(0.15)).frame(width: 44, height: 44))
                    }
                    .accessibilityLabel("Dismiss")
                    .accessibilityHint("Close this discovery notification")
                    .opacity(ctaOpacity)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // MARK: - Pulsing Rings
                ZStack {
                    // Ring 1 (outermost)
                    Circle()
                        .stroke(accentColor.opacity(0.1), lineWidth: 1.5)
                        .frame(width: 280, height: 280)
                        .scaleEffect(ringScale1)
                        .opacity(pulseOpacity * 0.3)
                    
                    // Ring 2
                    Circle()
                        .stroke(accentColor.opacity(0.2), lineWidth: 2)
                        .frame(width: 200, height: 200)
                        .scaleEffect(ringScale2)
                        .opacity(pulseOpacity * 0.5)
                    
                    // Ring 3 (inner)
                    Circle()
                        .stroke(accentColor.opacity(0.3), lineWidth: 2.5)
                        .frame(width: 130, height: 130)
                        .scaleEffect(ringScale3)
                        .opacity(pulseOpacity * 0.7)
                    
                    // Center icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [accentColor.opacity(0.3), accentColor.opacity(0.1)],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 50
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        discoveryIcon
                    }
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
                }
                
                Spacer().frame(height: 40)
                
                // MARK: - Discovery label
                Text(discoveryLabel)
                    .labelStyle()
                    .tracking(3)
                    .foregroundStyle(accentColor)
                    .textCase(.uppercase)
                    .opacity(subtitleOpacity)
                
                Spacer().frame(height: 12)
                
                // MARK: - Title
                Text(discoveryTitle)
                    .titleStyle()
                    .stigmaFont(size: 28, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)
                    .padding(.horizontal, 32)
                
                Spacer().frame(height: 16)
                
                // MARK: - Detail card
                discoveryDetailCard
                    .opacity(detailOpacity)
                    .offset(y: detailOffset)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                // MARK: - CTA Button
                Button {
                    HapticFeedback.impact(.heavy)
                    onOpen()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: ctaIcon)
                            .subheadlineStyle(size: 15)
                            .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        Text(ctaText)
                            .headlineStyle()
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: A11ySize.minTouchTarget)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(accentColor)
                            .shadow(color: accentColor.opacity(0.4), radius: 20, y: 6)
                    )
                }
                .accessibilityLabel(ctaText)
                .accessibilityHint("Opens the full \(ctaText.lowercased()) page")
                .padding(.horizontal, 32)
                .opacity(ctaOpacity)
                .scaleEffect(ctaScale)

                Spacer().frame(height: 12)

                // Visible dismiss button (replaces swipe-only gesture for accessibility)
                Button {
                    dismissOverlay()
                } label: {
                    Text("Dismiss")
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: A11ySize.minTouchTarget)
                }
                .accessibilityLabel("Dismiss")
                .accessibilityHint("Close this notification")
                .padding(.horizontal, 32)
                .opacity(ctaOpacity)

                Spacer().frame(height: 32)
            }
        }
        // Swipe-down kept as optional convenience; tap "Dismiss" button is the primary path
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.height > 100 { dismissOverlay() }
                }
        )
        .onAppear { runAnimation() }
    }
    
    // MARK: - Computed Properties
    
    @ViewBuilder
    private var discoveryIcon: some View {
        switch discovery {
        case .person(let folk):
            ZStack {
                Circle()
                    .fill(folk.avatarColor.opacity(0.3))
                    .frame(width: 64, height: 64)
                Text(folk.initials)
                    .titleStyle()
                    .stigmaFont(size: 28, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(.white)
            }
        case .venue(let place):
            Image(systemName: place.category.icon)
                .stigmaFont(size: 36, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(.white)
        }
    }
    
    private var discoveryLabel: String {
        switch discovery {
        case .person: return "Person Nearby"
        case .venue: return "Venue Nearby"
        }
    }
    
    private var discoveryTitle: String {
        switch discovery {
        case .person(let folk): return "\(folk.firstName) \(folk.lastName)"
        case .venue(let place): return place.name
        }
    }
    
    private var ctaIcon: String {
        switch discovery {
        case .person: return "person.circle.fill"
        case .venue: return "mappin.circle.fill"
        }
    }
    
    private var ctaText: String {
        switch discovery {
        case .person: return "View Profile"
        case .venue: return "View Place"
        }
    }
    
    @ViewBuilder
    private var discoveryDetailCard: some View {
        switch discovery {
        case .person(let folk):
            personCard(folk)
        case .venue(let place):
            venueCard(place)
        }
    }
    
    private func personCard(_ folk: CommunityFolk) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(folk.avatarColor.opacity(0.3))
                        .frame(width: 44, height: 44)
                    Text(folk.initials)
                        .headlineStyle()
                        .foregroundStyle(folk.avatarColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(folk.journeyStage.rawValue)
                        .labelStyle()
                        .foregroundStyle(accentColor)
                    Text("\(folk.interests.prefix(2).map(\.rawValue).joined(separator: " · "))")
                        .caption2Style()
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
            }
            
            Text(folk.bio)
                .captionStyle()
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Shared interests indicator
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .caption2Style()
                Text("Shares your interests")
                    .caption2Style()
                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
            }
            .foregroundStyle(accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(LinearGradient(
                            colors: [accentColor.opacity(0.1), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
    }
    
    private func venueCard(_ place: CommunityPlace) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(place.category.color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: place.category.icon)
                        .headlineStyle()
                        .foregroundStyle(place.category.color)
                }
                
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Category")
                                .labelStyle()
                                .foregroundStyle(.white.opacity(0.6))
                            Text(place.category.rawValue)
                                .labelStyle()
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Highlights")
                                .labelStyle()
                                .foregroundStyle(.white.opacity(0.6))
                            Text(place.highlights.prefix(2).joined(separator: ", "))
                                .caption2Style()
                                .foregroundStyle(.white)
                        }
                Spacer()
            }
            
            if place.isTulipCertified {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .caption2Style()
                    Text("Tulip Certified")
                        .caption2Style()
                        .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                }
                .foregroundStyle(Theme.green)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if place.communityVerified {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .caption2Style()
                    Text("Verified by the community")
                        .caption2Style()
                        .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                }
                .foregroundStyle(Theme.green)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Activity match
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .caption2Style()
                Text("Matches your activity preferences")
                    .caption2Style()
                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
            }
            .foregroundStyle(accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(LinearGradient(
                            colors: [accentColor.opacity(0.1), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
    }
    
    // MARK: - Dismiss helper

    private func dismissOverlay() {
        HapticFeedback.selection()
        withAnimation(.easeOut(duration: 0.3)) { bgOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onDismiss() }
    }

    // MARK: - Animation

    private func runAnimation() {
        if reduceMotion {
            // Reduce Motion: show everything immediately, no animation
            bgOpacity = 1.0
            pulseOpacity = 1.0
            ringScale1 = 1.0; ringScale2 = 1.0; ringScale3 = 1.0
            iconScale = 1.0; iconOpacity = 1.0
            subtitleOpacity = 1.0
            titleOpacity = 1.0; titleOffset = 0
            detailOpacity = 1.0; detailOffset = 0
            ctaOpacity = 1.0; ctaScale = 1.0
            return
        }

        // Phase 1: Background fades in (0.0s)
        withAnimation(.easeIn(duration: 0.4)) {
            bgOpacity = 1.0
        }

        // Start gradient rotation
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            gradientRotation = 360
        }

        // Phase 2: Rings pulse outward (0.2s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 1.0)) {
                ringScale1 = 1.0
                pulseOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) { ringScale2 = 1.0 }
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) { ringScale3 = 1.0 }
        }

        // Phase 3: Icon appears (0.4s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            HapticManager.shared.proximityPulse()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                iconScale = 1.0; iconOpacity = 1.0
            }
        }

        // Phase 4: Label (0.8s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.4)) { subtitleOpacity = 1.0 }
        }

        // Phase 5: Title (1.0s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                titleOpacity = 1.0; titleOffset = 0
            }
        }

        // Phase 6: Detail card (1.3s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                detailOpacity = 1.0; detailOffset = 0
            }
        }

        // Phase 7: CTA (1.6s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                ctaOpacity = 1.0; ctaScale = 1.0
            }
        }

        // Continuous ring pulsing (1.2s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                ringScale1 = 1.1; ringScale2 = 1.08; ringScale3 = 1.05
            }
        }
    }
}

// MARK: - Shake Gesture Detection

struct ShakeDetector: UIViewControllerRepresentable {
    let onShake: () -> Void
    
    func makeUIViewController(context: Context) -> ShakeDetectorViewController {
        let vc = ShakeDetectorViewController()
        vc.onShake = onShake
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ShakeDetectorViewController, context: Context) {
        uiViewController.onShake = onShake
    }
}

class ShakeDetectorViewController: UIViewController {
    var onShake: (() -> Void)?
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            onShake?()
        }
    }
    
    override var canBecomeFirstResponder: Bool { true }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
}
