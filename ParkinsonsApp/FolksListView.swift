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
    @State private var filterAppeared = false
    @AppStorage("settingsSimplifiedLayout") private var simplifiedLayout: Bool = false
    @AppStorage("settingsReduceMotion") private var reduceMotionOverride: Bool = false
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false

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
                $0.interests.contains(where: { $0.rawValue.lowercased().contains(q) })
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
                        // Stage filters (simplified = compact pills instead of full cards)
                        if simplifiedLayout {
                            simplifiedStageFilters
                        } else {
                            stageFilterSection
                        }

                        // Stats (hidden in simplified mode)
                        if !simplifiedLayout {
                            HStack(spacing: 12) {
                                statBadge(count: filteredFolk.count, label: "Members", color: Theme.accent, icon: "person.2.fill")
                                statBadge(count: samplePlaces.count, label: "Places", color: Theme.green, icon: "mappin.circle.fill")
                                statBadge(count: sampleActivities.count, label: "Events", color: Theme.cyan, icon: "calendar")
                            }
                            .padding(.horizontal, 16)
                        }

                        // Folk list
                        LazyVStack(spacing: 10) {
                            ForEach(Array(filteredFolk.enumerated()), id: \.element.id) { index, folk in
                                NavigationLink(destination: FolkDetailView(folk: folk)) {
                                    folkRow(folk)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("\(folk.firstName) \(folk.lastName), age \(folk.age), \(folk.stage.rawValue), diagnosed \(folk.yearsSinceDiagnosis) years ago")
                                .accessibilityHint("Opens \(folk.firstName)'s full profile")
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .offset(y: 12)),
                                    removal: .opacity
                                ))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedStage)
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
        .onAppear {
            if reduceMotionOverride {
                filterAppeared = true
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    filterAppeared = true
                }
            }
        }
    }

    // MARK: - Stage Filter Cards

    private var stageFilterSection: some View {
        VStack(spacing: 10) {
            // "All" button
            Button {
                HapticFeedback.selection()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    selectedStage = nil
                }
            } label: {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(selectedStage == nil ? Theme.accent : Theme.accent.opacity(0.15))
                            .frame(width: 36, height: 36)
                        Image(systemName: "person.3.fill")
                            .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(selectedStage == nil ? .white : Theme.accent)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Everyone")
                            .headlineStyle(size: 16)
                            .foregroundStyle(Theme.text)
                        Text("\(sampleFolk.count) members in your community")
                            .captionStyle()
                            .foregroundStyle(Theme.text.opacity(0.6))
                    }
                    Spacer()
                    if selectedStage == nil {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Theme.accent)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(selectedStage == nil ? Theme.accent.opacity(0.08) : Theme.cardBackground)
                        .shadow(color: Theme.text.opacity(0.04), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(selectedStage == nil ? Theme.accent.opacity(0.3) : Color.clear, lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
            .scaleEffect(filterAppeared ? 1 : 0.95)
            .opacity(filterAppeared ? 1 : 0)

            // Stage cards
            ForEach(Array(Stage.allCases.enumerated()), id: \.element) { index, stage in
                let isSelected = selectedStage == stage
                let color = stageColor(stage)
                let count = sampleFolk.filter { $0.stage == stage }.count

                Button {
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedStage = isSelected ? nil : stage
                    }
                } label: {
                    HStack(spacing: 12) {
                        // Icon with gradient background
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [color, color.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 48, height: 48)

                            Image(systemName: stage.icon)
                                .stigmaFont(size: 20, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(stage.rawValue)
                                .headlineStyle(size: 16)
                                .foregroundStyle(Theme.text)

                            Text(stageSubtitle(stage))
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.55))
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(count)")
                                .stigmaFont(size: 22, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(isSelected ? color : Theme.text.opacity(0.5))
                            Text("members")
                                .caption2Style()
                                .foregroundStyle(Theme.text.opacity(0.4))
                        }

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(color)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isSelected ? color.opacity(0.08) : Theme.cardBackground)
                            .shadow(color: Theme.text.opacity(0.04), radius: 8, x: 0, y: 4)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(isSelected ? color.opacity(0.3) : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
                .scaleEffect(filterAppeared ? 1 : 0.95)
                .opacity(filterAppeared ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1 * Double(index + 1)), value: filterAppeared)
            }
        }
        .padding(.horizontal, 16)
    }

    private func stageSubtitle(_ stage: Stage) -> String {
        switch stage {
        case .early: return "0-2 years since diagnosis"
        case .mid: return "2-10 years, finding their rhythm"
        case .advanced: return "11+ years, experienced & inspiring"
        }
    }

    // MARK: - Components

    private func statBadge(count: Int, label: String, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .captionStyle()
                .foregroundStyle(color)
            Text("\(count)")
                .titleStyle(size: 22)
                .foregroundStyle(color)
            Text(label)
                .captionStyle(size: 12)
                .stigmaFont(size: 12, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(Theme.text.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.glassBackground)
    }

    private func folkRow(_ folk: CommunityFolk) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(folk.avatarColor.opacity(0.2))
                    .frame(width: 52, height: 52)
                Text(folk.initials)
                    .headlineStyle(size: 18)
                    .foregroundStyle(folk.avatarColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(folk.firstName) \(folk.lastName)")
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text)

                    Spacer()

                    Text("Age \(folk.age)")
                        .caption2Style(size: 11)
                        .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text.opacity(0.5))
                }

                HStack(spacing: 6) {
                    PillBadge(text: folk.stage.rawValue, tint: stageColor(folk.stage), systemImage: folk.stage.icon)
                    Text("\(folk.yearsSinceDiagnosis)y")
                        .caption2Style(size: 11)
                        .foregroundStyle(Theme.text.opacity(0.6))
                }

                if !simplifiedLayout {
                    HStack(spacing: 5) {
                        ForEach(folk.interests.prefix(4), id: \.self) { interest in
                            Image(systemName: interest.icon)
                                .font(.system(size: 12))
                                .padding(6)
                                .background(Theme.pill(tint: Theme.text.opacity(0.3)))
                                .foregroundStyle(Theme.text.opacity(0.75))
                        }
                        if folk.interests.count > 4 {
                            Text("+\(folk.interests.count - 4)")
                                .caption2Style(size: 11)
                                .foregroundStyle(Theme.text.opacity(0.45))
                        }
                    }
                    .accessibilityLabel("Interests: \(folk.interests.map(\.rawValue).joined(separator: ", "))")
                }
            }

            Image(systemName: "chevron.right")
                .footnoteStyle(size: 13)
                .stigmaFont(size: 13, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(Theme.text.opacity(0.3))
        }
        .padding(14)
        .background(Theme.glassBackground)
    }

    // MARK: - Simplified Stage Filters

    private var simplifiedStageFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                simplifiedFilterButton(label: "All", icon: "person.3.fill", color: Theme.accent, isSelected: selectedStage == nil) {
                    selectedStage = nil
                }
                ForEach(Stage.allCases, id: \.self) { stage in
                    let count = sampleFolk.filter { $0.stage == stage }.count
                    simplifiedFilterButton(
                        label: "\(stage.rawValue) (\(count))",
                        icon: stage.icon,
                        color: stageColor(stage),
                        isSelected: selectedStage == stage
                    ) {
                        selectedStage = selectedStage == stage ? nil : stage
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func simplifiedFilterButton(label: String, icon: String, color: Color, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            HapticFeedback.selection()
            withAnimation(.easeInOut(duration: 0.2)) { action() }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .captionStyle()
                Text(label)
                    .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
            }
            .foregroundStyle(isSelected ? .white : Theme.text)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? color : Theme.cardBackground)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(highContrast ? Theme.text.opacity(0.3) : (isSelected ? color : Color.clear), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
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
