//
//  FolkDetailView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct FolkDetailView: View {
    let folk: CommunityFolk

    private var places: [CommunityPlace] {
        placesFor(folkID: folk.id)
    }

    private var activities: [PlaceActivity] {
        activitiesFor(folkID: folk.id)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileHeader
                content
            }
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
    }

    // MARK: - Header

    private var profileHeader: some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(folk.avatarColor.opacity(0.15))
                    .frame(width: 120, height: 120)
                Circle()
                    .fill(folk.avatarColor.opacity(0.25))
                    .frame(width: 100, height: 100)
                Text(folk.initials)
                    .font(.system(size: 40, weight: .heavy))
                    .fontDesign(.rounded)
                    .foregroundStyle(folk.avatarColor)
            }

            Text("\(folk.firstName) \(folk.lastName)")
                .font(.title2.weight(.heavy))
                .fontDesign(.rounded)
                .foregroundStyle(Theme.text)

            // Quick stats
            HStack(spacing: 16) {
                quickStat(value: "Age \(folk.age)", icon: "person.fill", color: Theme.text)
                quickStat(value: folk.stage.rawValue, icon: "chart.bar.fill", color: stageColor(folk.stage))
                quickStat(value: "\(folk.yearsSinceDiagnosis)y", icon: "calendar", color: Theme.accent)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(folk.avatarColor.opacity(0.05))
    }

    private func quickStat(value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.footnote)
                .foregroundStyle(color)
            Text(value)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.text)
        }
        .frame(minWidth: 70)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.cardBackground)
        )
    }

    // MARK: - Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Bio
            StigmaCard {
                Text("About")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Theme.text)
                Text(folk.bio)
                    .font(.subheadline)
                    .foregroundStyle(Theme.text.opacity(0.85))
                    .lineSpacing(4)
            }

            // Interests
            StigmaCard {
                Text("Interests")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Theme.text)

                FlowLayout(spacing: 6) {
                    ForEach(folk.interests, id: \.self) { interest in
                        PillBadge(text: interest, tint: folk.avatarColor)
                    }
                }
            }
            
            // Experiences & Journey
            StigmaCard {
                Text("Experiences")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Theme.text)
                
                VStack(alignment: .leading, spacing: 10) {
                    experienceRow(icon: "road.lanes", label: "Journey", value: folk.journeyStage.rawValue)
                    
                    if !folk.experiences.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Image(systemName: "eye")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(Theme.accent)
                                    .frame(width: 20)
                                Text("When out & about")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.text.opacity(0.5))
                            }
                            FlowLayout(spacing: 6) {
                                ForEach(folk.experiences, id: \.self) { exp in
                                    PillBadge(text: exp.rawValue, tint: Theme.accent, systemImage: exp.icon)
                                }
                            }
                        }
                    }
                    
                    experienceRow(icon: "figure.arms.open", label: "Affected area", value: folk.bodyDistribution.rawValue)
                    experienceRow(icon: "clock.fill", label: "Best time", value: folk.bestTimeOfDay.rawValue)
                }
            }

            // Places they attend
            if !places.isEmpty {
                placesSection
            }

            // Upcoming activities
            if !activities.isEmpty {
                activitiesSection
            }
        }
        .padding(16)
    }
    
    private func experienceRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
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

    // MARK: - Places

    private var placesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Places \(folk.firstName) attends")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)

            ForEach(places) { place in
                NavigationLink(destination: PlaceDetailView(place: place)) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(place.category.color.opacity(0.15))
                                .frame(width: 44, height: 44)
                            Image(systemName: place.category.icon)
                                .font(.headline)
                                .foregroundStyle(place.category.color)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(place.name)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Theme.text)
                                .lineLimit(1)
                            HStack(spacing: 6) {
                                Text(place.category.rawValue)
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(place.category.color)
                                Text(place.schedule)
                                    .font(.caption2)
                                    .foregroundStyle(Theme.text.opacity(0.6))
                                    .lineLimit(1)
                            }
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Theme.text.opacity(0.3))
                    }
                    .padding(12)
                    .background(Theme.glassBackground)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Activities

    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming activities")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)

            ForEach(activities) { activity in
                let activityPlace = placeFor(id: activity.placeID)
                NavigationLink(destination: ActivityDetailView(activity: activity)) {
                    HStack(spacing: 12) {
                        VStack(spacing: 2) {
                            Text(activity.date.formatted(.dateTime.day()))
                                .font(.title3.weight(.heavy))
                                .foregroundStyle(activityPlace?.category.color ?? Theme.accent)
                            Text(activity.date.formatted(.dateTime.month(.abbreviated)))
                                .font(.system(size: 10).weight(.bold))
                                .foregroundStyle(Theme.text.opacity(0.6))
                        }
                        .frame(width: 40)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(activity.name)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Theme.text)
                                .lineLimit(1)
                            Text(activity.time)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Theme.text.opacity(0.7))
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Theme.text.opacity(0.3))
                    }
                    .padding(12)
                    .background(Theme.glassBackground)
                }
                .buttonStyle(.plain)
            }
        }
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
    NavigationStack {
        FolkDetailView(folk: sampleFolk[0])
    }
}
