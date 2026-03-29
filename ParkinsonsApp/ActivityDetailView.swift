//
//  ActivityDetailView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct ActivityDetailView: View {
    let activity: PlaceActivity

    private var place: CommunityPlace? {
        placeFor(id: activity.placeID)
    }

    private var participants: [CommunityFolk] {
        activity.participantIDs.compactMap { folkFor(id: $0) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroHeader
                content
            }
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
    }

    // MARK: - Hero

    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            (place?.category.color ?? Theme.accent).opacity(0.2),
                            (place?.category.color ?? Theme.accent).opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180)
                .overlay(
                    Image(systemName: place?.category.icon ?? "calendar")
                        .font(.system(size: 50, weight: .light))
                        .foregroundStyle((place?.category.color ?? Theme.accent).opacity(0.2))
                )

            VStack(alignment: .leading, spacing: 6) {
                if let recurrence = activity.recurrence {
                    PillBadge(text: recurrence, tint: place?.category.color ?? Theme.accent)
                }
                Text(activity.name)
                    .font(.title2.weight(.heavy))
                    .fontDesign(.rounded)
                    .foregroundStyle(Theme.text)
            }
            .padding(16)
        }
    }

    // MARK: - Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Date & Time
            dateTimeCard

            // Description
            StigmaCard {
                Text("About this activity")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Theme.text)
                Text(activity.description)
                    .font(.subheadline)
                    .foregroundStyle(Theme.text.opacity(0.85))
                    .lineSpacing(4)
            }

            // Venue
            if let place = place {
                venueCard(place)
            }

            // Participants
            if !participants.isEmpty {
                participantsSection
            }
        }
        .padding(16)
    }

    private var dateTimeCard: some View {
        HStack(spacing: 16) {
            // Date block
            VStack(spacing: 2) {
                Text(activity.date.formatted(.dateTime.weekday(.wide)))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(place?.category.color ?? Theme.accent)
                Text(activity.date.formatted(.dateTime.day()))
                    .font(.system(size: 36, weight: .heavy))
                    .fontDesign(.rounded)
                    .foregroundStyle(Theme.text)
                Text(activity.date.formatted(.dateTime.month(.wide)))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.text.opacity(0.6))
            }
            .frame(width: 90)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill((place?.category.color ?? Theme.accent).opacity(0.1))
            )

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(Theme.accent)
                    Text(activity.time)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Theme.text)
                }

                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(Theme.cyan)
                    Text("\(participants.count) participants")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.text.opacity(0.8))
                }

                if activity.recurrence != nil {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(Theme.green)
                        Text("Recurring")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.text.opacity(0.8))
                    }
                }
            }

            Spacer()
        }
        .padding(14)
        .background(Theme.glassBackground)
    }

    private func venueCard(_ place: CommunityPlace) -> some View {
        NavigationLink(destination: PlaceDetailView(place: place)) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(place.category.color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: place.category.icon)
                        .font(.headline)
                        .foregroundStyle(place.category.color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Venue")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.text.opacity(0.6))
                    Text(place.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.text)
                    Text(place.address.replacingOccurrences(of: "\n", with: ", "))
                        .font(.caption)
                        .foregroundStyle(Theme.text.opacity(0.7))
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.text.opacity(0.3))
            }
            .padding(14)
            .background(Theme.glassBackground)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Participants

    private var participantsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Participants")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)

            ForEach(participants) { folk in
                NavigationLink(destination: FolkDetailView(folk: folk)) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(folk.avatarColor.opacity(0.2))
                                .frame(width: 40, height: 40)
                            Text(folk.initials)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(folk.avatarColor)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(folk.firstName) \(folk.lastName)")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Theme.text)
                            Text("\(folk.stage.rawValue) \u{00B7} \(folk.yearsSinceDiagnosis)y since diagnosis")
                                .font(.caption)
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
}

#Preview {
    NavigationStack {
        ActivityDetailView(activity: sampleActivities[0])
    }
}
