//
//  ProfileView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct ProfileView: View {
    @State private var isDiscoverable = sampleUser.isDiscoverable
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader
                        journeyCard
                        charmSettingsCard
                        communityStatsCard
                        settingsSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Components
    
    private var profileHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Text(sampleUser.name.prefix(1))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Theme.accent)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(sampleUser.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Theme.text)
                
                if let year = sampleUser.diagnosisYear {
                    Text("Diagnosed \(String(year)) · \(sampleUser.approximateStage.rawValue)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.text.opacity(0.8))
                }
            }
            
            Spacer()
            
            Button {
                // Edit Profile
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .font(.title)
                    .foregroundStyle(Theme.text.opacity(0.5))
            }
        }
    }
    
    private var journeyCard: some View {
        StigmaCard {
            HStack {
                Text("Journey")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Theme.text)
                Spacer()
                Text("\(sampleUser.milestones.filter({ $0.achieved }).count) milestones")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.text.opacity(0.6))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(sampleUser.milestones.enumerated()), id: \.element.id) { index, milestone in
                    HStack(alignment: .top, spacing: 16) {
                        // Timeline graphic
                        VStack(spacing: 0) {
                            Circle()
                                .fill(milestone.achieved ? Theme.accent : Theme.text.opacity(0.2))
                                .frame(width: 16, height: 16)
                            
                            if index < sampleUser.milestones.count - 1 {
                                Rectangle()
                                    .fill(Theme.text.opacity(0.1))
                                    .frame(width: 2, height: 40)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(milestone.title)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(milestone.achieved ? Theme.text : Theme.text.opacity(0.6))
                            
                            Text(milestone.description)
                                .font(.footnote)
                                .foregroundStyle(Theme.text.opacity(0.6))
                        }
                        .padding(.top, -2) // Align text with circle
                        
                        Spacer()
                    }
                }
            }
            .padding(.top, 12)
        }
    }
    
    private var charmSettingsCard: some View {
        StigmaCard {
            Text("Stigma Charm")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)
            
            VStack(alignment: .leading, spacing: 16) {
                // Connection Status
                HStack(spacing: 12) {
                    Circle()
                        .fill(Theme.green)
                        .frame(width: 8, height: 8)
                    Text(sampleUser.companionName != nil ? "Linked to \(sampleUser.companionName!)" : "No companion linked")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.text)
                }
                .padding(.top, 8)
                
                Divider()
                    .background(Theme.text.opacity(0.1))
                
                // Signal Meanings
                VStack(alignment: .leading, spacing: 12) {
                    Text("Squeeze Signals")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(Theme.text.opacity(0.6))
                    
                    HStack {
                        Text("Quick squeeze")
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Text("I'm okay")
                            .font(.subheadline)
                            .foregroundStyle(Theme.text.opacity(0.6))
                    }
                    HStack {
                        Text("Long squeeze")
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Text("Come find me")
                            .font(.subheadline)
                            .foregroundStyle(Theme.text.opacity(0.6))
                    }
                    HStack {
                        Text("Double squeeze")
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Text("Let's leave")
                            .font(.subheadline)
                            .foregroundStyle(Theme.text.opacity(0.6))
                    }
                }
                .foregroundStyle(Theme.text)
            }
        }
    }
    
    private var communityStatsCard: some View {
        StigmaCard {
            Text("Community")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)
            
            VStack(spacing: 16) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Theme.accent.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(systemName: "person.3.fill")
                            .foregroundStyle(Theme.accent)
                    }
                    Text("47 members active in London this week")
                        .font(.subheadline.weight(.medium))
                    Spacer()
                }
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Theme.green.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundStyle(Theme.green)
                    }
                    Text("12 tulip venues near you")
                        .font(.subheadline.weight(.medium))
                    Spacer()
                }
            }
            .foregroundStyle(Theme.text)
            .padding(.top, 8)
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 0) {
            settingRow(icon: "bell.badge", title: "Notifications")
            Divider().background(Theme.text.opacity(0.1)).padding(.leading, 44)
            Toggle(isOn: $isDiscoverable) {
                HStack(spacing: 12) {
                    Image(systemName: "eye")
                        .font(.body.weight(.semibold))
                        .frame(width: 24)
                    Text("Discoverable to members")
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(Theme.text)
            }
            .tint(Theme.accent)
            .padding()
            Divider().background(Theme.text.opacity(0.1)).padding(.leading, 44)
            settingRow(icon: "info.circle", title: "About Stigma")
            Divider().background(Theme.text.opacity(0.1)).padding(.leading, 44)
            settingRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign out", isDestructive: true)
        }
        .background(Theme.glassBackground)
    }
    
    private func settingRow(icon: String, title: String, isDestructive: Bool = false) -> some View {
        Button {
            // Action
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .frame(width: 24)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.text.opacity(0.3))
            }
            .foregroundStyle(isDestructive ? .red : Theme.text)
            .padding()
        }
    }
}

#Preview {
    ProfileView()
}
