//
//  ProfileView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("onboardingJourneyStage") private var journeyStageRaw: String = ""
    @AppStorage("onboardingExperiences") private var experiencesRaw: String = ""
    @AppStorage("onboardingBodyDistribution") private var bodyDistributionRaw: String = ""
    @AppStorage("onboardingBestTime") private var bestTimeRaw: String = ""
    @AppStorage("detailedSymptomProfile") private var profileData: String = ""
    
    @State private var isDiscoverable = sampleUser.isDiscoverable
    @State private var showSignOutAlert = false
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader
                        onboardingSummaryCard
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
            .sheet(isPresented: $showEditSheet) {
                EditOnboardingView()
            }
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Reset
    
    private func resetProfile() {
        // Clear all onboarding and profile data
        userName = ""
        journeyStageRaw = ""
        experiencesRaw = ""
        bodyDistributionRaw = ""
        bestTimeRaw = ""
        profileData = ""
        hasCompletedOnboarding = false
    }
    
    // MARK: - Components
    
    private var profileHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Text(userName.isEmpty ? "?" : String(userName.prefix(1)))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Theme.accent)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(userName.isEmpty ? sampleUser.name : userName)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Theme.text)
                
                if !journeyStageRaw.isEmpty {
                    Text(journeyStageRaw)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.text.opacity(0.8))
                } else if let year = sampleUser.diagnosisYear {
                    Text("Diagnosed \(String(year)) · \(sampleUser.approximateStage.rawValue)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.text.opacity(0.8))
                }
            }
            
            Spacer()
            
            Button {
                showEditSheet = true
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .font(.title)
                    .foregroundStyle(Theme.text.opacity(0.5))
            }
        }
    }
    
    // MARK: - Onboarding Summary Card
    
    private var onboardingSummaryCard: some View {
        StigmaCard {
            HStack {
                Text("Your Profile")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Theme.text)
                Spacer()
                Button {
                    showEditSheet = true
                } label: {
                    Text("Edit")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                if !journeyStageRaw.isEmpty {
                    profileRow(icon: "road.lanes", label: "Journey", value: journeyStageRaw)
                }
                
                if !experiencesRaw.isEmpty,
                   let data = experiencesRaw.data(using: .utf8),
                   let experiences = try? JSONDecoder().decode([String].self, from: data) {
                    profileRow(icon: "eye", label: "Experiences", value: experiences.joined(separator: ", "))
                }
                
                if !bodyDistributionRaw.isEmpty {
                    profileRow(icon: "figure.arms.open", label: "Affected area", value: bodyDistributionRaw)
                }
                
                if !bestTimeRaw.isEmpty {
                    profileRow(icon: "clock.fill", label: "Best time", value: bestTimeRaw)
                }
            }
            .padding(.top, 4)
        }
    }
    
    private func profileRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.accent)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.text.opacity(0.5))
                Text(value)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.text)
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
            // My Symptom Profile — comprehensive editor
            NavigationLink {
                SymptomProfileView()
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Theme.accent.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: "sparkles")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("My Symptom Profile")
                            .font(.subheadline.weight(.bold))
                        Text("Optional · Improves your matches")
                            .font(.caption)
                            .foregroundStyle(Theme.text.opacity(0.5))
                    }
                    .foregroundStyle(Theme.text)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.text.opacity(0.3))
                }
                .padding()
            }
            
            Divider().background(Theme.text.opacity(0.1)).padding(.leading, 44)
            
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
            
            // Sign Out
            Button {
                showSignOutAlert = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.body.weight(.semibold))
                        .frame(width: 24)
                    Text("Sign Out")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.text.opacity(0.3))
                }
                .foregroundStyle(.orange)
                .padding()
            }
            
            Divider().background(Theme.text.opacity(0.1)).padding(.leading, 44)
            
            // Delete Account
            Button {
                showDeleteAlert = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "trash.fill")
                        .font(.body.weight(.semibold))
                        .frame(width: 24)
                    Text("Delete Account")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.text.opacity(0.3))
                }
                .foregroundStyle(.red)
                .padding()
            }
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
