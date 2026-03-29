//
//  SymptomProfileView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct SymptomProfileView: View {
    @AppStorage("detailedSymptomProfile") private var profileData: String = ""
    
    @State private var profile: DetailedSymptomProfile = .defaultProfile()
    @State private var expandedCategories: Set<String> = []
    @State private var otherNotes: String = ""
    @State private var hasLoaded = false
    @State private var showSavedBanner = false
    
    private var enabledCount: Int {
        profile.categories.flatMap(\.items).filter(\.isEnabled).count
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    benefitsBanner
                    progressIndicator
                    
                    ForEach(Array(profile.categories.enumerated()), id: \.element.id) { catIdx, category in
                        categorySection(categoryIndex: catIdx, category: category)
                    }
                    
                    otherNotesSection
                    saveButton
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
            
            // Saved confirmation overlay
            if showSavedBanner {
                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                        Text("Saved!")
                            .font(.subheadline.weight(.bold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(Theme.green)
                            .shadow(color: Theme.green.opacity(0.4), radius: 16, y: 4)
                    )
                    .padding(.bottom, 32)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationTitle("My Symptom Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadProfile() }
        .preferredColorScheme(.light)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your detailed symptom profile")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.text)
            
            Text("This optional tool helps us match you with the right spaces, activities, and people in the community. You don't have to fill it in — but the more you share, the better your experience.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.text.opacity(0.65))
                .lineSpacing(3)
        }
    }
    
    // MARK: - Benefits Banner
    
    private var benefitsBanner: some View {
        StigmaCard {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "sparkles")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlock better matches")
                        .font(.subheadline.weight(.heavy))
                        .foregroundStyle(Theme.text)
                    Text("More detail = better venue, activity & people recommendations.")
                        .font(.caption)
                        .foregroundStyle(Theme.text.opacity(0.6))
                }
            }
        }
    }
    
    // MARK: - Progress
    
    private var progressIndicator: some View {
        StigmaCard {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(Theme.text.opacity(0.08), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    Circle()
                        .trim(from: 0, to: CGFloat(enabledCount) / 19.0)
                        .stroke(Theme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                    Text("\(enabledCount)")
                        .font(.caption.weight(.black))
                        .foregroundStyle(Theme.text)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(enabledCount) of 19 symptoms selected")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.text)
                    Text("Toggle each one that applies to you")
                        .font(.caption)
                        .foregroundStyle(Theme.text.opacity(0.5))
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Category Section
    
    private func categorySection(categoryIndex: Int, category: SymptomCategory) -> some View {
        StigmaCard {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if expandedCategories.contains(category.title) {
                        expandedCategories.remove(category.title)
                    } else {
                        expandedCategories.insert(category.title)
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.accent.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: category.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.title)
                            .font(.headline.weight(.heavy))
                            .foregroundStyle(Theme.text)
                        
                        let catEnabledCount = category.items.filter(\.isEnabled).count
                        Text("\(catEnabledCount) of \(category.items.count) selected")
                            .font(.caption)
                            .foregroundStyle(Theme.text.opacity(0.45))
                    }
                    
                    Spacer()
                    
                    let catEnabledCount = category.items.filter(\.isEnabled).count
                    if catEnabledCount > 0 {
                        Text("\(catEnabledCount)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.accent)
                            .clipShape(Capsule())
                    }
                    
                    Image(systemName: expandedCategories.contains(category.title) ? "chevron.up" : "chevron.down")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.text.opacity(0.4))
                }
            }
            .buttonStyle(.plain)
            
            if expandedCategories.contains(category.title) {
                VStack(spacing: 0) {
                    ForEach(Array(category.items.enumerated()), id: \.element.id) { itemIdx, item in
                        VStack(spacing: 0) {
                            if itemIdx > 0 {
                                Divider()
                                    .background(Theme.text.opacity(0.08))
                                    .padding(.leading, 4)
                            }
                            
                            symptomItemRow(categoryIndex: categoryIndex, itemIndex: itemIdx, item: item)
                        }
                    }
                }
                .padding(.top, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    // MARK: - Symptom Item Row
    
    private func symptomItemRow(categoryIndex: Int, itemIndex: Int, item: SymptomItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Main toggle row
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.label)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.text)
                    
                    Text(item.friendlyDescription)
                        .font(.caption)
                        .foregroundStyle(Theme.text.opacity(0.5))
                }
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { profile.categories[categoryIndex].items[itemIndex].isEnabled },
                    set: { newValue in
                        profile.categories[categoryIndex].items[itemIndex].isEnabled = newValue
                        if !newValue {
                            profile.categories[categoryIndex].items[itemIndex].severity = nil
                            profile.categories[categoryIndex].items[itemIndex].side = nil
                        }
                    }
                ))
                .labelsHidden()
                .tint(Theme.accent)
            }
            
            // Detail selectors — only when toggled on
            if item.isEnabled {
                VStack(alignment: .leading, spacing: 10) {
                    // Severity row
                    VStack(alignment: .leading, spacing: 6) {
                        Text("How much does it affect you?")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Theme.text.opacity(0.4))
                        
                        HStack(spacing: 6) {
                            ForEach(SymptomSeverity.allCases, id: \.self) { severity in
                                let isSelected = item.severity == severity
                                Button {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        profile.categories[categoryIndex].items[itemIndex].severity = isSelected ? nil : severity
                                    }
                                } label: {
                                    Text(severity.rawValue)
                                        .font(.caption.weight(.bold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 7)
                                        .background(
                                            Capsule()
                                                .fill(isSelected ? severityColor(severity) : Theme.text.opacity(0.06))
                                        )
                                        .foregroundStyle(isSelected ? .white : Theme.text.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Side selector row
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Which side?")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Theme.text.opacity(0.4))
                        
                        HStack(spacing: 6) {
                            ForEach(SymptomSide.allCases, id: \.self) { side in
                                let isSelected = item.side == side
                                Button {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        profile.categories[categoryIndex].items[itemIndex].side = isSelected ? nil : side
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: side.icon)
                                            .font(.system(size: 9).weight(.bold))
                                        Text(side.rawValue)
                                            .font(.caption.weight(.bold))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(
                                        Capsule()
                                            .fill(isSelected ? Theme.accent : Theme.text.opacity(0.06))
                                    )
                                    .foregroundStyle(isSelected ? .white : Theme.text.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.leading, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
    }
    
    private func severityColor(_ severity: SymptomSeverity) -> Color {
        switch severity {
        case .mild: return Theme.green
        case .moderate: return Theme.orange
        case .significant: return Color(hex: 0xE85D75)
        }
    }
    
    // MARK: - Other Notes
    
    private var otherNotesSection: some View {
        StigmaCard {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: "text.bubble.fill")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
                
                Text("Anything else?")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Theme.text)
            }
            
            Text("Anything we haven't listed that affects your day-to-day?")
                .font(.caption)
                .foregroundStyle(Theme.text.opacity(0.5))
            
            TextField("Type here...", text: $otherNotes, axis: .vertical)
                .font(.subheadline)
                .lineLimit(3...6)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Theme.text.opacity(0.04))
                )
                .foregroundStyle(Theme.text)
        }
    }
    
    // MARK: - Save
    
    private var saveButton: some View {
        Button {
            saveProfile()
        } label: {
            Text("Save My Profile")
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Theme.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.bottom, 24)
    }
    
    // MARK: - Persistence
    
    private func loadProfile() {
        guard !hasLoaded else { return }
        if let data = profileData.data(using: .utf8),
           let saved = try? JSONDecoder().decode(DetailedSymptomProfile.self, from: data) {
            profile = saved
            otherNotes = saved.otherNotes
        }
        hasLoaded = true
    }
    
    private func saveProfile() {
        profile.otherNotes = otherNotes
        if let data = try? JSONEncoder().encode(profile),
           let str = String(data: data, encoding: .utf8) {
            profileData = str
        }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showSavedBanner = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation { showSavedBanner = false }
        }
    }
}

#Preview {
    NavigationStack {
        SymptomProfileView()
    }
}
