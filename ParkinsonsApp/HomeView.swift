//
//  HomeView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var isDiscoverable = sampleUser.isDiscoverable
    @State private var showMatchmaking = false
    @State private var isPulsing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        header
                        greetingCard
                        charmStatusCard
                        findNearbyButton
                        weeklyCheckInCard
                        milestonesStrip
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
                
                if showMatchmaking {
                    MatchmakingOverlay(isVisible: $showMatchmaking)
                        .transition(.opacity)
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Components
    
    private var header: some View {
        HStack {
            Image(systemName: "asterisk")
                .font(.title2.weight(.bold))
                .foregroundStyle(Theme.accent)
            Text("Stigma")
                .font(.title2.weight(.heavy))
                .fontDesign(.rounded)
                .foregroundStyle(Theme.text)
            
            Spacer()
            
            Button {
                // Notifications
            } label: {
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.text.opacity(0.8))
            }
        }
        .padding(.top, 8)
    }
    
    private var greetingCard: some View {
        StigmaCard {
            Text("Good morning, \(sampleUser.name)")
                .font(.title2.weight(.bold))
                .foregroundStyle(Theme.text)
            
            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                    .font(.subheadline)
                Text("3 community members nearby")
                    .font(.subheadline.weight(.medium))
            }
            .foregroundStyle(Theme.text.opacity(0.8))
        }
    }
    
    private var charmStatusCard: some View {
        StigmaCard {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "battery.75")
                            .foregroundStyle(Theme.green)
                        Text("Charm connected")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Theme.text)
                    }
                    
                    Text("Last signal to \(sampleUser.companionName ?? "companion"): 2h ago")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(Theme.text.opacity(0.8))
                }
                Spacer()
                
                // Discoverable Toggle
                VStack {
                    Toggle("", isOn: $isDiscoverable)
                        .labelsHidden()
                        .tint(Theme.accent)
                    Text("Discoverable")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.text.opacity(0.7))
                }
            }
        }
    }
    
    private var findNearbyButton: some View {
        VStack(spacing: 12) {
            Button {
                withAnimation {
                    showMatchmaking = true
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .scaleEffect(isPulsing ? 1.05 : 1.0)
                    
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 120, height: 120)
                        .shadow(color: Theme.accent.opacity(0.4), radius: 15, x: 0, y: 8)
                    
                    Image(systemName: "asterisk")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            
            Text("Find nearby")
                .font(.headline.weight(.bold))
                .foregroundStyle(Theme.text)
        }
        .padding(.vertical, 16)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
    
    private var weeklyCheckInCard: some View {
        StigmaCard {
            Text("How are you feeling this week?")
                .font(.headline.weight(.bold))
                .foregroundStyle(Theme.text)
            
            HStack(spacing: 0) {
                ForEach(["😢", "😕", "😐", "🙂", "😄"], id: \.self) { emoji in
                    Button {
                        // Action
                    } label: {
                        Text(emoji)
                            .font(.system(size: 36))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    private var milestonesStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Journey")
                .font(.headline.weight(.bold))
                .foregroundStyle(Theme.text)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sampleMilestones) { milestone in
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(milestone.achieved ? Theme.cyan : Theme.text.opacity(0.1))
                                    .frame(width: 60, height: 60)
                                
                                if milestone.achieved {
                                    Image(systemName: "checkmark")
                                        .font(.title3.weight(.bold))
                                        .foregroundStyle(.white)
                                } else {
                                    Image(systemName: "lock.fill")
                                        .foregroundStyle(Theme.text.opacity(0.4))
                                }
                            }
                            
                            Text(milestone.title)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(milestone.achieved ? Theme.text : Theme.text.opacity(0.5))
                                .multilineTextAlignment(.center)
                                .frame(width: 80)
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    HomeView()
}
