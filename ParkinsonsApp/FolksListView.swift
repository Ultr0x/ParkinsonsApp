//
//  FolksListView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct FolksListView: View {
    @State private var searchText = ""
    @State private var selectedStage: Stage? = nil

    private var filteredFolk: [CommunityFolk] {
        var result = sampleFolk
        if let stage = selectedStage {
            result = result.filter { $0.stage == stage }
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.firstName.lowercased().contains(q) ||
                $0.lastName.lowercased().contains(q) ||
                $0.interests.contains(where: { $0.lowercased().contains(q) })
            }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Stage filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                stageFilterPill(nil, label: "All")
                                ForEach(Stage.allCases, id: \.rawValue) { stage in
                                    stageFilterPill(stage, label: stage.rawValue)
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // Stats
                        HStack(spacing: 12) {
                            statBadge(count: sampleFolk.count, label: "Members", color: Theme.accent)
                            statBadge(count: samplePlaces.count, label: "Places", color: Theme.green)
                            statBadge(count: sampleActivities.count, label: "Activities", color: Theme.cyan)
                        }
                        .padding(.horizontal, 16)

                        // Folk list
                        LazyVStack(spacing: 10) {
                            ForEach(filteredFolk) { folk in
                                NavigationLink(destination: FolkDetailView(folk: folk)) {
                                    folkRow(folk)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search people, interests...")
        }
        .preferredColorScheme(.light)
    }

    // MARK: - Components

    private func stageFilterPill(_ stage: Stage?, label: String) -> some View {
        let isSelected = selectedStage == stage
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedStage = stage
            }
        } label: {
            Text(label)
                .font(.footnote.weight(.bold))
                .fontDesign(.rounded)
                .foregroundStyle(isSelected ? .white : Theme.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule(style: .continuous)
                        .fill(isSelected ? Theme.accent : Theme.cardBackground)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(isSelected ? Theme.accent : Theme.text.opacity(0.1), lineWidth: 1)
                )
        }
    }

    private func statBadge(count: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2.weight(.heavy))
                .fontDesign(.rounded)
                .foregroundStyle(color)
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.text.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.glassBackground)
    }

    private func folkRow(_ folk: CommunityFolk) -> some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack {
                Circle()
                    .fill(folk.avatarColor.opacity(0.2))
                    .frame(width: 52, height: 52)
                Text(folk.initials)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(folk.avatarColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(folk.firstName) \(folk.lastName)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.text)

                    Spacer()

                    Text("Age \(folk.age)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Theme.text.opacity(0.5))
                }

                HStack(spacing: 6) {
                    PillBadge(text: folk.stage.rawValue, tint: stageColor(folk.stage))
                    Text("\(folk.yearsSinceDiagnosis)y diagnosed")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.text.opacity(0.6))
                }

                // Interests
                HStack(spacing: 4) {
                    ForEach(folk.interests.prefix(3), id: \.self) { interest in
                        Text(interest)
                            .font(.system(size: 10).weight(.semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Theme.pill(tint: Theme.text.opacity(0.4)))
                            .foregroundStyle(Theme.text.opacity(0.7))
                    }
                    if folk.interests.count > 3 {
                        Text("+\(folk.interests.count - 3)")
                            .font(.system(size: 10).weight(.bold))
                            .foregroundStyle(Theme.text.opacity(0.5))
                    }
                }
            }

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.text.opacity(0.3))
        }
        .padding(14)
        .background(Theme.glassBackground)
    }

    private func stageColor(_ stage: Stage) -> Color {
        switch stage {
        case .early: return Theme.green
        case .mid: return Theme.orange
        case .advanced: return Theme.accent
        }
    }
}

#Preview {
    FolksListView()
}
