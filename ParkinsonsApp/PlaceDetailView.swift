//
//  PlaceDetailView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct PlaceDetailView: View {
    let place: CommunityPlace

    private var members: [CommunityFolk] {
        place.memberIDs.compactMap { folkFor(id: $0) }
    }

    private var activities: [PlaceActivity] {
        activitiesFor(placeID: place.id)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroImage
                content
            }
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
    }

    // MARK: - Hero

    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(place.category.color.opacity(0.15))
                .frame(height: 200)
                .overlay(
                    Image(systemName: place.category.icon)
                        .font(.system(size: 60, weight: .light))
                        .foregroundStyle(place.category.color.opacity(0.3))
                )

            VStack(alignment: .leading, spacing: 4) {
                PillBadge(text: place.category.rawValue, tint: place.category.color, systemImage: place.category.icon)

                if place.isParkinsonsFriendly {
                    PillBadge(text: "Parkinson’s Friendly", tint: Theme.accent, systemImage: "checkmark.seal.fill")
                }

                Text(place.name)
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
            // Quick Info Row
            quickInfoRow

            // Description
            descriptionSection

            friendlySection

            // Opening Hours & Location
            detailsCard

            // Members
            if !members.isEmpty {
                membersSection
            }

            // Activities
            if !activities.isEmpty {
                activitiesSection
            }
        }
        .padding(16)
    }

    private var quickInfoRow: some View {
        HStack(spacing: 12) {
            if let cost = place.cost {
                PillBadge(text: cost, tint: Theme.green, systemImage: "sterlingsign.circle")
            }
            PillBadge(text: "\(members.count) members", tint: Theme.cyan, systemImage: "person.2")
            PillBadge(text: "\(activities.count) activities", tint: Theme.orange, systemImage: "calendar")

            if place.isParkinsonsFriendly {
                PillBadge(text: "Friendly", tint: Theme.accent, systemImage: "handshake")
            }
        }
    }

    private var descriptionSection: some View {
        StigmaCard {
            Text("About")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)
            Text(place.description)
                .font(.subheadline)
                .foregroundStyle(Theme.text.opacity(0.85))
                .lineSpacing(4)
        }
    }

    private var friendlySection: some View {
        Group {
            if place.isParkinsonsFriendly {
                StigmaCard {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title3)
                            .foregroundStyle(Theme.accent)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Parkinson’s Friendly")
                                .font(.headline.weight(.heavy))
                                .foregroundStyle(Theme.text)
                            Text("This place understands Parkinson’s.")
                                .font(.footnote)
                                .foregroundStyle(Theme.text.opacity(0.7))
                        }
                    }

                    Divider().background(Theme.text.opacity(0.1))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("They commit to:")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.text.opacity(0.6))
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: place.staffAwarenessTraining ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(place.staffAwarenessTraining ? Theme.green : Theme.text.opacity(0.4))
                                Text("Staff awareness training")
                                    .font(.subheadline.weight(.medium))
                            }
                            HStack(spacing: 8) {
                                Image(systemName: place.seatingAvailable ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(place.seatingAvailable ? Theme.green : Theme.text.opacity(0.4))
                                Text("Comfortable seating available")
                                    .font(.subheadline.weight(.medium))
                            }
                            HStack(spacing: 8) {
                                Image(systemName: place.calmEnvironment ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(place.calmEnvironment ? Theme.green : Theme.text.opacity(0.4))
                                Text("Calm, patient environment")
                                    .font(.subheadline.weight(.medium))
                            }
                            if place.displaysBeacon {
                                HStack(spacing: 8) {
                                    Image(systemName: "dot.radiowaves.left.and.right")
                                        .foregroundStyle(Theme.accent)
                                    Text("Beacon/sticker displayed on site")
                                        .font(.subheadline.weight(.medium))
                                }
                            }
                        }
                        .foregroundStyle(Theme.text)
                    }
                }
            }
        }
    }

    private var detailsCard: some View {
        StigmaCard {
            // Schedule
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "clock.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Schedule")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.text.opacity(0.6))
                    Text(place.schedule)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.text)
                }
            }

            Divider().background(Theme.text.opacity(0.1))

            // Address
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Location")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.text.opacity(0.6))
                    Text(place.address)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.text)
                    Text(place.postcode)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.text)
                }
            }

            // Link
            if let link = place.link, let url = URL(string: link) {
                Divider().background(Theme.text.opacity(0.1))

                HStack(spacing: 12) {
                    Image(systemName: "link.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.accent)
                        .frame(width: 28)
                    Link("Visit Website", destination: url)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
            }

            // Accessibility tags
            if !place.accessibility.isEmpty {
                Divider().background(Theme.text.opacity(0.1))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Accessibility")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.text.opacity(0.6))

                    FlowLayout(spacing: 6) {
                        ForEach(place.accessibility, id: \.self) { tag in
                            PillBadge(text: tag, tint: Theme.green, systemImage: "checkmark.circle")
                        }
                    }
                }
            }

            // Highlights
            if !place.highlights.isEmpty {
                Divider().background(Theme.text.opacity(0.1))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Highlights")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.text.opacity(0.6))

                    FlowLayout(spacing: 6) {
                        ForEach(place.highlights, id: \.self) { tag in
                            PillBadge(text: tag, tint: Theme.cyan, systemImage: "star.fill")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Members

    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Members & Regulars")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(members) { folk in
                        NavigationLink(destination: FolkDetailView(folk: folk)) {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(folk.avatarColor.opacity(0.2))
                                        .frame(width: 56, height: 56)
                                    Text(folk.initials)
                                        .font(.headline.weight(.bold))
                                        .foregroundStyle(folk.avatarColor)
                                }

                                Text(folk.firstName)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.text)

                                Text(folk.stage.rawValue)
                                    .font(.system(size: 9).weight(.semibold))
                                    .foregroundStyle(Theme.text.opacity(0.6))
                            }
                            .frame(width: 72)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Activities

    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activities")
                .font(.headline.weight(.heavy))
                .foregroundStyle(Theme.text)

            ForEach(activities) { activity in
                NavigationLink(destination: ActivityDetailView(activity: activity)) {
                    activityRow(activity)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func activityRow(_ activity: PlaceActivity) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 2) {
                Text(activity.date.formatted(.dateTime.day()))
                    .font(.title2.weight(.heavy))
                    .foregroundStyle(place.category.color)
                Text(activity.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.text.opacity(0.6))
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.name)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.text)
                Text(activity.time)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.text.opacity(0.7))
                if let recurrence = activity.recurrence {
                    Text(recurrence)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(place.category.color)
                }

                // Participant avatars
                HStack(spacing: -8) {
                    ForEach(activity.participantIDs.prefix(5).compactMap({ folkFor(id: $0) })) { folk in
                        Circle()
                            .fill(folk.avatarColor.opacity(0.3))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Text(folk.initials)
                                    .font(.system(size: 8).weight(.bold))
                                    .foregroundStyle(folk.avatarColor)
                            )
                            .overlay(Circle().stroke(Theme.cardBackground, lineWidth: 1.5))
                    }
                    if activity.participantIDs.count > 5 {
                        Circle()
                            .fill(Theme.text.opacity(0.1))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Text("+\(activity.participantIDs.count - 5)")
                                    .font(.system(size: 8).weight(.bold))
                                    .foregroundStyle(Theme.text.opacity(0.6))
                            )
                    }
                }
                .padding(.top, 4)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.text.opacity(0.3))
                .padding(.top, 4)
        }
        .padding(14)
        .background(Theme.glassBackground)
    }
}

// MARK: - Flow Layout helper

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = CGPoint(x: bounds.minX + result.positions[index].x,
                                y: bounds.minY + result.positions[index].y)
            subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}

#Preview {
    NavigationStack {
        PlaceDetailView(place: samplePlaces[0])
    }
}

