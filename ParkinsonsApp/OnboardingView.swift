//
//  OnboardingView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("onboardingJourneyStage") private var journeyStageRaw: String = ""
    @AppStorage("onboardingExperiences") private var experiencesRaw: String = ""
    @AppStorage("onboardingBodyDistribution") private var bodyDistributionRaw: String = ""
    @AppStorage("onboardingBestTime") private var bestTimeRaw: String = ""
    @AppStorage("onboardingInterests") private var interestsRaw: String = ""
    
    @State private var step = 0
    @State private var name: String = ""
    @State private var selectedJourneyStage: JourneyStage? = nil
    @State private var selectedExperiences: Set<OutAndAboutExperience> = []
    @State private var selectedBodyDistribution: BodyDistribution? = nil
    @State private var selectedBestTime: BestTimeOfDay? = nil
    @State private var selectedInterests: Set<Interest> = []
    @State private var isAnimatingAsterisk = false
    
    // Welcome Animations
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var logoRotation: Double = -120
    @State private var brandOpacity: Double = 0
    @State private var brandOffset: CGFloat = 20
    @State private var welcomeTextOpacity: Double = 0
    @State private var welcomeTextOffset: CGFloat = 10
    @State private var buttonOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.9
    @State private var bgGlowOpacity: Double = 0
    @State private var bgGradientShift: Double = 0
    
    private let totalSteps = 13
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar (shown only during profile setup steps 6–11)
                if step > 5 && step < totalSteps - 1 {
                    progressBar
                        .padding(.top, 8)
                        .padding(.horizontal, 24)
                }
                
                TabView(selection: $step) {
                    welcomeScreen.tag(0)
                    storyMovementScreen.tag(1)
                    storyCharmScreen.tag(2)
                    storyTulipSpacesScreen.tag(3)
                    storyAppScreen.tag(4)
                    storyJourneyScreen.tag(5)
                    nameScreen.tag(6)
                    journeyStageScreen.tag(7)
                    experiencesScreen.tag(8)
                    bodyDistributionScreen.tag(9)
                    bestTimeScreen.tag(10)
                    interestsScreen.tag(11)
                    readyScreen.tag(12)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.35), value: step)
            }
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Progress Bar
    
    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Theme.text.opacity(0.1))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(Theme.accent)
                    .frame(width: geo.size.width * CGFloat(step - 5) / CGFloat(totalSteps - 7), height: 6)
                    .animation(.easeInOut(duration: 0.35), value: step)
            }
        }
        .frame(height: 6)
    }
    
    // MARK: - Screen 0: Welcome
    
    private var welcomeScreen: some View {
        ZStack {
            // Background glow
            RadialGradient(
                colors: [Theme.accent.opacity(0.1 * bgGlowOpacity), .clear],
                center: .center,
                startRadius: 0,
                endRadius: 300
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // SVG Logo — responds to device motion (tilt/shake)
                MotionResponsiveLogoView(size: 160)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                VStack(spacing: 16) {
                    // Character cascade for "Stigma"
                    HStack(spacing: 0) {
                        ForEach(Array("Stigma".enumerated()), id: \.offset) { index, char in
                            Text(String(char))
                                .logoStyle(size: 64)
                                .foregroundStyle(Theme.text)
                                .opacity(brandOpacity)
                                .offset(y: brandOffset)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.7)
                                        .delay(0.6 + Double(index) * 0.05),
                                    value: brandOpacity
                                )
                        }
                    }
                    
                    Text("A community for people navigating life\nwith invisible challenges.")
                        .titleStyle(size: 20)
                        .foregroundStyle(Theme.text.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(welcomeTextOpacity)
                        .offset(y: welcomeTextOffset)
                }
                
                Spacer()
                
                onboardingButton("Get started") { 
                    withAnimation { step = 1 }
                }
                .padding(.bottom, -20)
                .opacity(buttonOpacity)
                .scaleEffect(buttonScale)
            }
        }
        .onAppear {
            runWelcomeAnimation()
        }
    }
    
    private func runWelcomeAnimation() {
        // Step 1: Logo scales in (motion is handled by MotionResponsiveLogoView)
        withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        // Step 2: Brand text cascade (handled by delay in transition)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            brandOpacity = 1.0
            brandOffset = 0
            bgGlowOpacity = 1.0
        }

        // Step 3: Subtitle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                welcomeTextOpacity = 1.0
                welcomeTextOffset = 0
            }
        }

        // Step 4: Button
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                buttonOpacity = 1.0
                buttonScale = 1.0
            }
        }
    }
    
    // MARK: - Story Screens (1–5)
    
    /// Shared layout for story screens with emoji illustration, title, body, and swipe hint
    private func storyScreen(
        illustration: AnyView,
        title: String,
        body: String,
        isLast: Bool = false
    ) -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Illustration area
            illustration
                .frame(height: 200)
                .padding(.bottom, 32)
            
            // Title
            Text(title)
                .titleStyle(size: 28)
                .foregroundStyle(Theme.text)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 14)
            
            // Body
            Text(body)
                .bodyStyle(size: 17)
                .foregroundStyle(Theme.text.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 32)
            
            Spacer()
            
            if isLast {
                onboardingButton("Get started") {
                    withAnimation { step = 6 }
                }
                .padding(.bottom, -20)
            } else {
                // Swipe hint
                HStack(spacing: 6) {
                    Text("Swipe to continue")
                        .captionStyle(size: 14)
                        .foregroundStyle(Theme.text.opacity(0.35))
                    Image(systemName: "arrow.right")
                        .captionStyle(size: 12)
                        .foregroundStyle(Theme.text.opacity(0.3))
                }
                .padding(.bottom, 56)
            }
        }
    }
    
    // Screen 1: The Movement
    private var storyMovementScreen: some View {
        storyScreen(
            illustration: AnyView(
                VStack(spacing: 16) {
                    // People connected by tulips
                    HStack(spacing: 0) {
                        ForEach(0..<5) { i in
                            if i % 2 == 0 {
                                // Person
                                ZStack {
                                    Circle()
                                        .fill(Theme.text.opacity(0.08))
                                        .frame(width: 48, height: 48)
                                    Image(systemName: i == 0 ? "person.fill" : (i == 2 ? "figure.walk" : "person.fill"))
                                        .font(.system(size: 22))
                                        .foregroundStyle(Theme.text.opacity(0.6))
                                }
                            } else {
                                // Tulip connector
                                VStack(spacing: 2) {
                                    Text("🌷")
                                        .font(.system(size: 20))
                                    Rectangle()
                                        .fill(Theme.accent.opacity(0.3))
                                        .frame(width: 24, height: 1)
                                }
                            }
                        }
                    }
                    
                    // Second row — dotted line with smaller tulips
                    HStack(spacing: 12) {
                        ForEach(0..<7) { i in
                            if i % 2 == 0 {
                                Circle()
                                    .fill(Theme.text.opacity(0.12))
                                    .frame(width: 4, height: 4)
                            } else {
                                Text("🌷")
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
            ),
            title: "You're joining a movement",
            body: "Thousands of people with invisible challenges are finding each other — not through hospitals, but through everyday life. In cafés. In parks. On walks."
        )
    }
    
    // Screen 2: The Charm
    private var storyCharmScreen: some View {
        storyScreen(
            illustration: AnyView(
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(Theme.accent.opacity(0.06))
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .fill(Theme.accent.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    // Charm object
                    ZStack {
                        Circle()
                            .fill(Theme.cardBackground)
                            .frame(width: 80, height: 80)
                            .shadow(color: Theme.text.opacity(0.1), radius: 12, x: 0, y: 4)
                        
                        VStack(spacing: 4) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Theme.text.opacity(0.5))
                            Text("🌷")
                                .font(.system(size: 16))
                        }
                    }
                    
                    // Vibration waves
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(Theme.accent.opacity(0.15 - Double(i) * 0.04), lineWidth: 1.5)
                            .frame(width: CGFloat(100 + i * 24), height: CGFloat(100 + i * 24))
                    }
                }
            ),
            title: "Meet your Charm",
            body: "A small object you carry with you. Squeeze it for a calming vibration when you need it. It connects to the app so you can find people and places that understand."
        )
    }
    
    // Screen 3: Tulip Spaces
    private var storyTulipSpacesScreen: some View {
        storyScreen(
            illustration: AnyView(
                ZStack {
                    // Café window frame
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Theme.cardBackground)
                        .frame(width: 180, height: 140)
                        .shadow(color: Theme.text.opacity(0.08), radius: 12, x: 0, y: 4)
                    
                    // Window panes
                    VStack(spacing: 0) {
                        // Top bar
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.text.opacity(0.1))
                            .frame(width: 160, height: 6)
                            .padding(.top, 12)
                        
                        HStack(spacing: 8) {
                            // Left pane — warm glow
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: 0xFFF3E0), Color(hex: 0xFFE0B2)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 68, height: 90)
                                .overlay(
                                    VStack {
                                        Image(systemName: "cup.and.saucer.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(Theme.text.opacity(0.3))
                                        Spacer()
                                    }
                                    .padding(.top, 16)
                                )
                            
                            // Right pane — tulip sticker
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: 0xFFF8E1), Color(hex: 0xFFECB3)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 68, height: 90)
                                .overlay(
                                    Text("🌷")
                                        .font(.system(size: 36))
                                )
                        }
                        .padding(.top, 8)
                    }
                }
            ),
            title: "Look for the tulip",
            body: "Cafés, gyms, and parks that display the tulip have made a commitment: their staff understand invisible challenges. They won't rush you. You're welcome here."
        )
    }
    
    // Screen 4: The App
    private var storyAppScreen: some View {
        storyScreen(
            illustration: AnyView(
                ZStack {
                    // Map background
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(hex: 0xEDE7D9))
                        .frame(width: 200, height: 150)
                        .shadow(color: Theme.text.opacity(0.06), radius: 10, x: 0, y: 3)
                    
                    // Map grid lines
                    VStack(spacing: 20) {
                        ForEach(0..<4) { _ in
                            Rectangle()
                                .fill(Theme.text.opacity(0.06))
                                .frame(height: 1)
                        }
                    }
                    .frame(width: 180)
                    
                    HStack(spacing: 30) {
                        ForEach(0..<4) { _ in
                            Rectangle()
                                .fill(Theme.text.opacity(0.06))
                                .frame(width: 1, height: 130)
                        }
                    }
                    
                    // Tulip pins
                    Group {
                        Text("🌷").font(.system(size: 22))
                            .offset(x: -40, y: -25)
                        Text("🌷").font(.system(size: 22))
                            .offset(x: 30, y: -35)
                        Text("🌷").font(.system(size: 22))
                            .offset(x: -20, y: 20)
                        Text("🌷").font(.system(size: 22))
                            .offset(x: 50, y: 15)
                        Text("🌷").font(.system(size: 16))
                            .offset(x: 10, y: -5)
                    }
                    
                    // Map icon badge
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Theme.text.opacity(0.8))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "location.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .frame(width: 190, height: 140)
                }
            ),
            title: "Find your spaces and your people",
            body: "Discover tulip venues near you. Join events — coffee meetups, boxing classes, park walks. Connect with people who get it. Everything is opt-in."
        )
    }
    
    // Screen 5: For Every Stage
    private var storyJourneyScreen: some View {
        storyScreen(
            illustration: AnyView(
                HStack(spacing: 20) {
                    // Stage 1 — solo
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Theme.text.opacity(0.06))
                                .frame(width: 52, height: 52)
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Theme.text.opacity(0.45))
                        }
                        Text("🌱")
                            .font(.system(size: 14))
                    }
                    
                    // Arrow
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.text.opacity(0.2))
                    
                    // Stage 2 — pair
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Theme.accent.opacity(0.08))
                                .frame(width: 60, height: 60)
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Theme.text.opacity(0.55))
                        }
                        Text("🌷")
                            .font(.system(size: 18))
                    }
                    
                    // Arrow
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.text.opacity(0.2))
                    
                    // Stage 3 — group
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Theme.accent.opacity(0.12))
                                .frame(width: 68, height: 68)
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Theme.text.opacity(0.65))
                        }
                        Text("🌷")
                            .font(.system(size: 24))
                    }
                }
            ),
            title: "Wherever you are in your journey",
            body: "Just diagnosed? The Charm is your private comfort. Starting to open up? You're not alone. Ready to connect? Find your people. There's no right speed. Every step counts.",
            isLast: true
        )
    }
    
    // MARK: - Screen 6: Name
    
    private var nameScreen: some View {
        VStack(alignment: .leading, spacing: 32) {
            onboardingHeader
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What should we call you?")
                    .titleStyle(size: 28)
                    .foregroundStyle(Theme.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                TextField("Your first name", text: $name)
                    .titleStyle(size: 20)
                    .padding()
                    .background(Theme.glassBackground)
                    .foregroundStyle(Theme.text)
                    .onSubmit {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            }
            
            Spacer()
            
            onboardingButton("Continue", disabled: name.isEmpty) {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                userName = name
                step = 7
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 7: Journey Stage
    
    private var journeyStageScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("Where are you on your journey?")
                .titleStyle(size: 28)
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 12) {
                ForEach(JourneyStage.allCases, id: \.self) { stage in
                    singleSelectCard(
                        title: stage.rawValue,
                        icon: stage.icon,
                        isSelected: selectedJourneyStage == stage
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedJourneyStage = stage
                        }
                    }
                }
            }
            
            Spacer()
            
            onboardingButton("Continue", disabled: selectedJourneyStage == nil) {
                journeyStageRaw = selectedJourneyStage?.rawValue ?? ""
                step = 8
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 8: Experiences (Multi-select)
    
    private var experiencesScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("When you're out and about, what do you notice most?")
                .titleStyle(size: 22)
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Select all that apply")
                .subheadlineStyle()
                .foregroundStyle(Theme.text.opacity(0.6))
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(OutAndAboutExperience.allCases, id: \.self) { exp in
                        multiSelectCard(
                            title: exp.rawValue,
                            icon: exp.icon,
                            isSelected: selectedExperiences.contains(exp)
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if selectedExperiences.contains(exp) {
                                    selectedExperiences.remove(exp)
                                } else {
                                    selectedExperiences.insert(exp)
                                }
                            }
                        }
                    }
                }
            }
            
            onboardingButton("Continue", disabled: selectedExperiences.isEmpty) {
                let rawValues = selectedExperiences.map { $0.rawValue }
                if let data = try? JSONEncoder().encode(rawValues),
                   let str = String(data: data, encoding: .utf8) {
                    experiencesRaw = str
                }
                step = 9
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 9: Body Distribution
    
    private var bodyDistributionScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("Does it mostly affect one side of your body, or both?")
                .titleStyle(size: 22)
                .stigmaFont(size: 22, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 12) {
                ForEach(BodyDistribution.allCases, id: \.self) { dist in
                    singleSelectCard(
                        title: dist.rawValue,
                        icon: dist.icon,
                        isSelected: selectedBodyDistribution == dist
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedBodyDistribution = dist
                        }
                    }
                }
            }
            
            Spacer()
            
            onboardingButton("Continue", disabled: selectedBodyDistribution == nil) {
                bodyDistributionRaw = selectedBodyDistribution?.rawValue ?? ""
                step = 10
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 10: Best Time of Day
    
    private var bestTimeScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("When do you usually feel your best going out?")
                .titleStyle(size: 22)
                .stigmaFont(size: 22, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 12) {
                ForEach(BestTimeOfDay.allCases, id: \.self) { time in
                    singleSelectCard(
                        title: time.rawValue,
                        icon: time.icon,
                        isSelected: selectedBestTime == time
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedBestTime = time
                        }
                    }
                }
            }
            
            Spacer()
            
            onboardingButton("Continue", disabled: selectedBestTime == nil) {
                bestTimeRaw = selectedBestTime?.rawValue ?? ""
                step = 11
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 11: Interests
    
    private var interestsScreen: some View {
        VStack(alignment: .leading, spacing: 20) {
            onboardingHeader
            
            Text("What are you into?")
                .titleStyle(size: 22)
                .stigmaFont(size: 22, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Pick up to 5 — we'll use these to connect you with like-minded people")
                .subheadlineStyle()
                .foregroundStyle(Theme.text.opacity(0.6))
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(Interest.allCases, id: \.self) { interest in
                        let isSelected = selectedInterests.contains(interest)
                        let isDisabled = selectedInterests.count >= 5 && !isSelected
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if isSelected {
                                    selectedInterests.remove(interest)
                                } else if selectedInterests.count < 5 {
                                    selectedInterests.insert(interest)
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: interest.icon)
                                    .footnoteStyle(size: 13)
                                    .stigmaFont(size: 13, name: "AtkinsonHyperlegible-Bold")
                                    .frame(width: 20)
                                Text(interest.rawValue)
                                    .labelStyle()
                                    .lineLimit(1)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .captionStyle()
                                        .foregroundStyle(Theme.accent)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(isSelected ? Theme.accent.opacity(0.12) : Theme.cardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(isSelected ? Theme.accent.opacity(0.5) : Color.clear, lineWidth: 1.5)
                            )
                            .foregroundStyle(isDisabled ? Theme.text.opacity(0.3) : Theme.text)
                        }
                        .buttonStyle(.plain)
                        .disabled(isDisabled)
                    }
                }
            }
            
            HStack {
                Text("\(selectedInterests.count)/5 selected")
                    .labelStyle()
                    .foregroundStyle(Theme.accent)
                Spacer()
            }
            
            onboardingButton("Continue", disabled: selectedInterests.isEmpty) {
                let rawValues = selectedInterests.map { $0.rawValue }
                if let data = try? JSONEncoder().encode(rawValues),
                   let str = String(data: data, encoding: .utf8) {
                    interestsRaw = str
                }
                step = 12
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 12: Confirmation
    
    private var readyScreen: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("You're in, \(name). 🌷")
                .titleStyle(size: 28)
                .foregroundStyle(Theme.text)
            
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimatingAsterisk ? 1.1 : 1.0)
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimatingAsterisk ? 15 : 0))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimatingAsterisk = true
                }
            }
            
            Text("We'll use what you shared to find the right spaces and people for you.")
                .headlineStyle(size: 18)
                .foregroundStyle(Theme.text.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            onboardingButton("Enter Stigma", style: .primary) {
                HapticManager.shared.success()
                hasCompletedOnboarding = true
            }
        }
    }
    
    // MARK: - Shared Components
    
    private var onboardingHeader: some View {
        HStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Spacer()
            // Step title (e.g. "Step 1 of 8")
            if step > 0 && step < totalSteps - 1 {
                Text("Stigma")
                    .logoStyle(size: 20)
                    .foregroundStyle(Theme.text.opacity(0.3))
            }
            Spacer()
            if step > 0 {
                Button {
                    withAnimation { step -= 1 }
                } label: {
                    Image(systemName: "chevron.left")
                        .titleStyle(size: 20)
                        .foregroundStyle(Theme.text.opacity(0.5))
                }
            }
        }
        .padding(.top, 20)
    }
    
    private enum ButtonStyle { case primary, accent }
    
    private func onboardingButton(
        _ title: String,
        disabled: Bool = false,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            HapticFeedback.selection()
            action()
        } label: {
            Text(title)
                .titleStyle(size: 18)
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(disabled ? Theme.text.opacity(0.2) : (style == .primary ? Theme.text : Theme.accent))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .disabled(disabled)
        .padding(.horizontal, 24)
        .padding(.bottom, 48)
    }
    
    // MARK: - Card Components
    
    private func singleSelectCard(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            HapticFeedback.selection()
            action()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Theme.accent.opacity(0.2) : Theme.text.opacity(0.06))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .bodyStyle(size: 16)
                        .stigmaFont(size: 16, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.5))
                }
                
                Text(title)
                    .bodyStyle(size: 16)
                    .stigmaFont(size: 16, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(Theme.text)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .titleStyle(size: 20)
                    .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.2))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Theme.accent.opacity(0.4) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func multiSelectCard(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            HapticFeedback.selection()
            action()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isSelected ? Theme.accent.opacity(0.2) : Theme.text.opacity(0.06))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .bodyStyle(size: 16)
                        .stigmaFont(size: 16, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.5))
                }
                
                Text(title)
                    .subheadlineStyle(size: 15)
                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(Theme.text)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .titleStyle(size: 20)
                    .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.2))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Theme.accent.opacity(0.4) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
}
