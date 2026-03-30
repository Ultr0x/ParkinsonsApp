//
//  ActivityDetailView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct ActivityDetailView: View {
    let activity: PlaceActivity
    @State private var eventManager = EventManager.shared
    @State private var rsvpBounce = false
    @AppStorage("settingsSimplifiedLayout") private var simplifiedLayout: Bool = false
    @AppStorage("settingsLargeButtons") private var largeButtons: Bool = false
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false
    @AppStorage("settingsReduceMotion") private var reduceMotionOverride: Bool = false

    private var place: CommunityPlace? {
        placeFor(id: activity.placeID)
    }

    private var participants: [CommunityFolk] {
        activity.participantIDs.compactMap { folkFor(id: $0) }
    }

    private var isJoined: Bool {
        eventManager.isJoined(activity.id)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    heroHeader
                    content
                    Spacer().frame(height: 100)
                }
            }

            // Floating RSVP button
            rsvpButton
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
    }

    // MARK: - Hero

    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            let colors = activity.photos.first?.gradientColors ?? [
                (place?.category.color ?? Theme.accent).opacity(0.2),
                (place?.category.color ?? Theme.accent).opacity(0.05)
            ]
            LinearGradient(colors: colors.map { $0.opacity(0.4) }, startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 220)
                .overlay(
                    Image(systemName: place?.category.icon ?? "calendar")
                        .stigmaFont(size: 60, name: "AtkinsonHyperlegible-Regular")
                        .foregroundStyle(.white.opacity(0.3))
                )

            VStack(alignment: .leading, spacing: 6) {
                if let recurrence = activity.recurrence {
                    PillBadge(text: recurrence, tint: place?.category.color ?? Theme.accent)
                }
                Text(activity.name)
                    .titleStyle(size: 24)
                    .foregroundStyle(Theme.text)
            }
            .padding(16)
        }
    }

    // MARK: - Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            dateTimeCard
            descriptionSection

            // Photo gallery (hidden in simplified mode)
            if !simplifiedLayout && !activity.photos.isEmpty {
                photoGallery
            }

            if let place = place {
                venueCard(place)
            }

            if !participants.isEmpty {
                if simplifiedLayout {
                    // Simplified: just show count, no avatar row
                    simplifiedParticipantsSection
                } else {
                    participantsSection
                }
            }

            // Stage info
            stageInfoSection
        }
        .padding(16)
    }

    // MARK: - Date & Time

    private var dateTimeCard: some View {
        HStack(spacing: 16) {
            VStack(spacing: 2) {
                Text(activity.date.formatted(.dateTime.weekday(.wide)))
                    .labelStyle()
                    .foregroundStyle(place?.category.color ?? Theme.accent)
                Text(activity.date.formatted(.dateTime.day()))
                    .stigmaFont(size: 36, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(Theme.text)
                Text(activity.date.formatted(.dateTime.month(.wide)))
                    .labelStyle()
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
                        .headlineStyle()
                        .foregroundStyle(Theme.text)
                }

                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(Theme.cyan)
                    Text("\(participants.count) going")
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text.opacity(0.8))
                }

                if activity.recurrence != nil {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(Theme.green)
                        Text("Recurring")
                            .subheadlineStyle(size: 15)
                            .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(Theme.text.opacity(0.8))
                    }
                }
            }

            Spacer()
        }
        .padding(14)
        .background(Theme.glassBackground)
    }

    // MARK: - Description

    private var descriptionSection: some View {
        StigmaCard {
            Text("About this event")
                .headlineStyle(size: 18)
                .foregroundStyle(Theme.text)
            Text(activity.description)
                .subheadlineStyle()
                .foregroundStyle(Theme.text.opacity(0.85))
                .lineSpacing(4)
        }
    }

    // MARK: - Photo Gallery

    private var photoGallery: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Photos")
                .headlineStyle(size: 18)
                .foregroundStyle(Theme.text)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(activity.photos) { photo in
                        ZStack {
                            LinearGradient(
                                colors: photo.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            VStack(spacing: 6) {
                                Image(systemName: photo.iconName)
                                    .stigmaFont(size: 32, name: "AtkinsonHyperlegible-Regular")
                                    .foregroundStyle(.white.opacity(0.9))
                                if let caption = photo.caption {
                                    Text(caption)
                                        .stigmaFont(size: 12, name: "AtkinsonHyperlegible-Bold")
                                        .foregroundStyle(.white.opacity(0.8))
                                        .lineLimit(1)
                                }
                            }
                        }
                        .frame(width: 180, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
    }

    // MARK: - Stage Info

    private var stageInfoSection: some View {
        StigmaCard {
            if let stage = activity.stageFilter {
                HStack(spacing: 8) {
                    Image(systemName: stage.icon)
                        .foregroundStyle(Theme.accent)
                    Text("Recommended for: \(stage.rawValue)")
                        .subheadlineStyle()
                        .foregroundStyle(Theme.text)
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "person.3.fill")
                        .foregroundStyle(Theme.accent)
                    Text("All stages welcome")
                        .subheadlineStyle()
                        .foregroundStyle(Theme.text)
                }
            }

            Text("People at a similar stage to you attend this event")
                .captionStyle()
                .foregroundStyle(Theme.text.opacity(0.6))
        }
    }

    // MARK: - Venue Card

    private func venueCard(_ place: CommunityPlace) -> some View {
        NavigationLink(destination: PlaceDetailView(place: place)) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(place.category.color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: place.category.icon)
                        .headlineStyle()
                        .foregroundStyle(place.category.color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Venue")
                        .labelStyle()
                        .foregroundStyle(Theme.text.opacity(0.6))
                    Text(place.name)
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text)
                    Text(place.address.replacingOccurrences(of: "\n", with: ", "))
                        .captionStyle()
                        .foregroundStyle(Theme.text.opacity(0.7))
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .footnoteStyle(size: 13)
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
            Text("Who's going")
                .headlineStyle(size: 18)
                .foregroundStyle(Theme.text)

            // Avatar row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(participants) { folk in
                        NavigationLink(destination: FolkDetailView(folk: folk)) {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(folk.avatarColor.opacity(0.2))
                                        .frame(width: 48, height: 48)
                                    Text(folk.initials)
                                        .headlineStyle()
                                        .foregroundStyle(folk.avatarColor)
                                }
                                Text(folk.firstName)
                                    .labelStyle()
                                    .foregroundStyle(Theme.text)
                            }
                            .frame(width: 64)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // Detailed list
            ForEach(participants) { folk in
                NavigationLink(destination: FolkDetailView(folk: folk)) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(folk.avatarColor.opacity(0.2))
                                .frame(width: 40, height: 40)
                            Text(folk.initials)
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(folk.avatarColor)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(folk.firstName) \(folk.lastName)")
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(Theme.text)
                            Text("\(folk.stage.rawValue) \u{00B7} \(folk.yearsSinceDiagnosis)y since diagnosis")
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.7))
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .footnoteStyle(size: 13)
                            .foregroundStyle(Theme.text.opacity(0.3))
                    }
                    .padding(12)
                    .background(Theme.glassBackground)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Simplified Participants

    private var simplifiedParticipantsSection: some View {
        StigmaCard {
            HStack(spacing: 12) {
                Image(systemName: "person.2.fill")
                    .headlineStyle()
                    .foregroundStyle(Theme.cyan)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(participants.count) people going")
                        .headlineStyle(size: 18)
                        .foregroundStyle(Theme.text)
                    Text(participants.prefix(3).map { $0.firstName }.joined(separator: ", ") + (participants.count > 3 ? " & more" : ""))
                        .captionStyle()
                        .foregroundStyle(Theme.text.opacity(0.7))
                }
                Spacer()
            }
        }
    }

    // MARK: - RSVP Button

    private var rsvpButton: some View {
        let animOrNone: Animation? = reduceMotionOverride ? nil : .spring(response: 0.3, dampingFraction: 0.6)
        return Button {
            if let anim = animOrNone {
                withAnimation(anim) {
                    rsvpBounce = true
                    eventManager.toggleJoin(activity.id)
                }
                withAnimation(anim.delay(0.15)) {
                    rsvpBounce = false
                }
            } else {
                eventManager.toggleJoin(activity.id)
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isJoined ? "checkmark.circle.fill" : "plus.circle.fill")
                    .headlineStyle(size: largeButtons ? 22 : 18)
                    .symbolEffect(.bounce, value: isJoined)
                Text(isJoined ? "You're going!" : "I'm going!")
                    .headlineStyle(size: largeButtons ? 22 : 18)
            }
            .foregroundStyle(.white)
            .padding(.vertical, largeButtons ? 22 : 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: largeButtons ? 20 : 16, style: .continuous)
                    .fill(isJoined ? Theme.green : Theme.accent)
                    .shadow(color: (isJoined ? Theme.green : Theme.accent).opacity(0.4), radius: 12, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: largeButtons ? 20 : 16, style: .continuous)
                    .stroke(highContrast ? .white.opacity(0.4) : Color.clear, lineWidth: 2)
            )
            .scaleEffect(rsvpBounce ? 1.05 : 1.0)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)

        // "Change your mind?" link
        .overlay(alignment: .bottom) {
            if isJoined {
                Text("Change your mind?")
                    .captionStyle()
                    .foregroundStyle(Theme.text.opacity(0.4))
                    .padding(.bottom, 2)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ActivityDetailView(activity: sampleActivities[0])
    }
}
