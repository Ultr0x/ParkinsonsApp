//
//  EditOnboardingView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct EditOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("onboardingJourneyStage") private var journeyStageRaw: String = ""
    @AppStorage("onboardingExperiences") private var experiencesRaw: String = ""
    @AppStorage("onboardingBodyDistribution") private var bodyDistributionRaw: String = ""
    @AppStorage("onboardingBestTime") private var bestTimeRaw: String = ""
    
    @State private var selectedJourneyStage: JourneyStage? = nil
    @State private var selectedExperiences: Set<OutAndAboutExperience> = []
    @State private var selectedBodyDistribution: BodyDistribution? = nil
    @State private var selectedBestTime: BestTimeOfDay? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        // MARK: - Journey Stage
                        sectionHeader(title: "Where are you on your journey?", icon: "road.lanes")
                        
                        VStack(spacing: 10) {
                            ForEach(JourneyStage.allCases, id: \.self) { stage in
                                selectCard(
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
                        
                        Divider().background(Theme.text.opacity(0.1))
                        
                        // MARK: - Experiences
                        sectionHeader(title: "When you're out and about, what do you notice most?", icon: "eye")
                        
                        Text("Select all that apply")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.text.opacity(0.5))
                        
                        VStack(spacing: 10) {
                            ForEach(OutAndAboutExperience.allCases, id: \.self) { exp in
                                selectCard(
                                    title: exp.rawValue,
                                    icon: exp.icon,
                                    isSelected: selectedExperiences.contains(exp),
                                    isMulti: true
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
                        
                        Divider().background(Theme.text.opacity(0.1))
                        
                        // MARK: - Body Distribution
                        sectionHeader(title: "Does it mostly affect one side, or both?", icon: "figure.arms.open")
                        
                        VStack(spacing: 10) {
                            ForEach(BodyDistribution.allCases, id: \.self) { dist in
                                selectCard(
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
                        
                        Divider().background(Theme.text.opacity(0.1))
                        
                        // MARK: - Best Time
                        sectionHeader(title: "When do you usually feel your best going out?", icon: "clock.fill")
                        
                        VStack(spacing: 10) {
                            ForEach(BestTimeOfDay.allCases, id: \.self) { time in
                                selectCard(
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
                        
                        // Save button
                        Button {
                            save()
                            dismiss()
                        } label: {
                            Text("Save Changes")
                                .font(.headline.weight(.bold))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.text)
                }
            }
        }
        .onAppear { loadCurrent() }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Components
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.accent)
            Text(title)
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(Theme.text)
        }
    }
    
    private func selectCard(title: String, icon: String, isSelected: Bool, isMulti: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Theme.accent.opacity(0.2) : Theme.text.opacity(0.06))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.5))
                }
                
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.text)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: isSelected ? (isMulti ? "checkmark.square.fill" : "checkmark.circle.fill") : (isMulti ? "square" : "circle"))
                    .font(.title3)
                    .foregroundStyle(isSelected ? Theme.accent : Theme.text.opacity(0.2))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? Theme.accent.opacity(0.4) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Persistence
    
    private func loadCurrent() {
        selectedJourneyStage = JourneyStage.allCases.first { $0.rawValue == journeyStageRaw }
        selectedBodyDistribution = BodyDistribution.allCases.first { $0.rawValue == bodyDistributionRaw }
        selectedBestTime = BestTimeOfDay.allCases.first { $0.rawValue == bestTimeRaw }
        
        if let data = experiencesRaw.data(using: .utf8),
           let rawValues = try? JSONDecoder().decode([String].self, from: data) {
            selectedExperiences = Set(rawValues.compactMap { raw in
                OutAndAboutExperience.allCases.first { $0.rawValue == raw }
            })
        }
    }
    
    private func save() {
        journeyStageRaw = selectedJourneyStage?.rawValue ?? ""
        bodyDistributionRaw = selectedBodyDistribution?.rawValue ?? ""
        bestTimeRaw = selectedBestTime?.rawValue ?? ""
        
        let rawValues = selectedExperiences.map { $0.rawValue }
        if let data = try? JSONEncoder().encode(rawValues),
           let str = String(data: data, encoding: .utf8) {
            experiencesRaw = str
        }
    }
}

#Preview {
    EditOnboardingView()
}
