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
    
    @State private var step = 0
    @State private var name: String = ""
    @State private var selectedJourneyStage: JourneyStage? = nil
    @State private var selectedExperiences: Set<OutAndAboutExperience> = []
    @State private var selectedBodyDistribution: BodyDistribution? = nil
    @State private var selectedBestTime: BestTimeOfDay? = nil
    @State private var isAnimatingAsterisk = false
    
    private let totalSteps = 7
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar (hidden on welcome & final)
                if step > 0 && step < totalSteps - 1 {
                    progressBar
                        .padding(.top, 8)
                        .padding(.horizontal, 24)
                }
                
                TabView(selection: $step) {
                    welcomeScreen.tag(0)
                    nameScreen.tag(1)
                    journeyStageScreen.tag(2)
                    experiencesScreen.tag(3)
                    bodyDistributionScreen.tag(4)
                    bestTimeScreen.tag(5)
                    readyScreen.tag(6)
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
                    .frame(width: geo.size.width * CGFloat(step) / CGFloat(totalSteps - 2), height: 6)
                    .animation(.easeInOut(duration: 0.35), value: step)
            }
        }
        .frame(height: 6)
    }
    
    // MARK: - Screen 0: Welcome
    
    private var welcomeScreen: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "asterisk")
                .font(.system(size: 80, weight: .bold))
                .foregroundStyle(Theme.accent)
            
            VStack(spacing: 16) {
                Text("Welcome to Stigma")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundStyle(Theme.text)
                
                Text("A community for people navigating life with invisible challenges.")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Theme.text.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            onboardingButton("Get started") { step = 1 }
        }
    }
    
    // MARK: - Screen 1: Name
    
    private var nameScreen: some View {
        VStack(alignment: .leading, spacing: 32) {
            onboardingHeader
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What should we call you?")
                    .font(.title.weight(.heavy))
                    .foregroundStyle(Theme.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                TextField("Your first name", text: $name)
                    .font(.title3)
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
                step = 2
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 2: Journey Stage
    
    private var journeyStageScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("Where are you on your journey?")
                .font(.title.weight(.heavy))
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
                step = 3
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 3: Experiences (Multi-select)
    
    private var experiencesScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("When you're out and about, what do you notice most?")
                .font(.title2.weight(.heavy))
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Select all that apply")
                .font(.subheadline.weight(.medium))
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
                step = 4
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 4: Body Distribution
    
    private var bodyDistributionScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("Does it mostly affect one side of your body, or both?")
                .font(.title2.weight(.heavy))
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
                step = 5
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 5: Best Time of Day
    
    private var bestTimeScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            onboardingHeader
            
            Text("When do you usually feel your best going out?")
                .font(.title2.weight(.heavy))
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
                step = 6
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Screen 6: Confirmation
    
    private var readyScreen: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("You're in, \(name). 🌷")
                .font(.title.weight(.heavy))
                .foregroundStyle(Theme.text)
            
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimatingAsterisk ? 1.1 : 1.0)
                
                Image(systemName: "asterisk")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .rotationEffect(.degrees(isAnimatingAsterisk ? 15 : 0))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimatingAsterisk = true
                }
            }
            
            Text("We'll use what you shared to find the right spaces and people for you.")
                .font(.headline.weight(.medium))
                .foregroundStyle(Theme.text.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            onboardingButton("Enter Stigma", style: .primary) {
                hasCompletedOnboarding = true
            }
        }
    }
    
    // MARK: - Shared Components
    
    private var onboardingHeader: some View {
        HStack {
            Image(systemName: "asterisk")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.accent)
            Spacer()
            if step > 0 {
                Button {
                    withAnimation { step -= 1 }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
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
        Button(action: action) {
            Text(title)
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(disabled ? Theme.text.opacity(0.2) : (style == .primary ? Theme.text : Theme.accent))
                .foregroundStyle(style == .primary ? Theme.background : .white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .disabled(disabled)
        .padding(.horizontal, 24)
        .padding(.bottom, 48)
    }
    
    // MARK: - Card Components
    
    private func singleSelectCard(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Theme.accent.opacity(0.2) : Theme.text.opacity(0.06))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.5))
                }
                
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Theme.text)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
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
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isSelected ? Theme.accent.opacity(0.2) : Theme.text.opacity(0.06))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.5))
                }
                
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.text)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title3)
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
