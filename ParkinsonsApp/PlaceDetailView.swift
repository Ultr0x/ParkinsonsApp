//
//  PlaceDetailView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import SwiftUI

struct PlaceDetailView: View {
    let place: CommunityPlace
    var fromDiscovery: Bool = false

    private var members: [CommunityFolk] {
        place.memberIDs.compactMap { folkFor(id: $0) }
    }

    private var activities: [PlaceActivity] {
        activitiesFor(placeID: place.id)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    heroImage
                    content
                    
                    if fromDiscovery {
                        // Extra bottom padding for the floating button
                        Spacer().frame(height: 100)
                    }
                }
            }
            
            if fromDiscovery {
                checkInButton
            }
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 6) {
                    if place.hostsEvents {
                        Image(systemName: "star.fill")
                            .labelStyle()
                            .foregroundStyle(Theme.accent)
                        Text("Community Hub")
                            .titleStyle(size: 16)
                            .foregroundStyle(Theme.text)
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }

    // MARK: - Hero

    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            // Extend the color behind the navigation bar (eliminates top gap)
            VStack(spacing: 0) {
                place.category.color.opacity(0.15)
                    .frame(height: 60)
                    .ignoresSafeArea(edges: .top)
                
                Rectangle()
                    .fill(place.category.color.opacity(0.15))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: place.category.icon)
                            .stigmaFont(size: 60, name: "AtkinsonHyperlegible-Regular")
                            .foregroundStyle(place.category.color.opacity(0.3))
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    PillBadge(text: place.category.rawValue, tint: place.category.color, systemImage: place.category.icon)
                }
                
                HStack(spacing: 6) {
                    if place.isTulipCertified {
                        PillBadge(text: "Tulip Certified", tint: Theme.green, systemImage: "checkmark.seal.fill")
                    }
                    
                    if place.communityVerified {
                        PillBadge(text: "Verified", tint: Theme.green, systemImage: "checkmark.circle.fill")
                    }
                }

                Text(place.name)
                    .logoStyle(size: 32)
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

            // Photo gallery
            placePhotoGallery

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
        FlowLayout(spacing: 8) {
            if let cost = place.cost {
                PillBadge(text: cost, tint: Theme.green, systemImage: "sterlingsign.circle")
            }
            PillBadge(text: "\(members.count) members", tint: Theme.cyan, systemImage: "person.2")
            PillBadge(text: "\(activities.count) activities", tint: Theme.orange, systemImage: "calendar")

            if place.isTulipCertified {
                PillBadge(text: "Friendly", tint: Theme.accent, systemImage: "handshake")
            }
        }
    }

    private var descriptionSection: some View {
        StigmaCard {
            Text("About")
                .headlineStyle(size: 18)
                .foregroundStyle(Theme.text)
            Text(place.description)
                .subheadlineStyle()
                .foregroundStyle(Theme.text.opacity(0.85))
                .lineSpacing(4)
        }
    }

    private var friendlySection: some View {
        Group {
            if place.isTulipCertified {
                StigmaCard {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .titleStyle(size: 20)
                            .foregroundStyle(Theme.accent)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tulip Certified")
                                .headlineStyle(size: 18)
                                .foregroundStyle(Theme.text)
                            Text("Staff here are trained to be patient and understanding.")
                                .footnoteStyle()
                                .foregroundStyle(Theme.text.opacity(0.7))
                        }
                    }

                    Divider().background(Theme.text.opacity(0.1))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("They commit to:")
                            .labelStyle()
                            .foregroundStyle(Theme.text.opacity(0.6))
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: place.staffAwarenessTraining ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(place.staffAwarenessTraining ? Theme.green : Theme.text.opacity(0.4))
                                Text("Staff awareness training")
                                    .subheadlineStyle()
                            }
                            HStack(spacing: 8) {
                                Image(systemName: place.seatingAvailable ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(place.seatingAvailable ? Theme.green : Theme.text.opacity(0.4))
                                Text("Comfortable seating available")
                                    .subheadlineStyle()
                            }
                            HStack(spacing: 8) {
                                Image(systemName: place.calmEnvironment ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(place.calmEnvironment ? Theme.green : Theme.text.opacity(0.4))
                                Text("Calm, patient environment")
                                    .subheadlineStyle()
                            }
                            if place.displaysBeacon {
                                HStack(spacing: 8) {
                                    Image(systemName: "dot.radiowaves.left.and.right")
                                        .foregroundStyle(Theme.accent)
                                    Text("Beacon/sticker displayed on site")
                                        .subheadlineStyle()
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
                    .titleStyle(size: 20)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Schedule")
                        .labelStyle()
                        .foregroundStyle(Theme.text.opacity(0.6))
                    Text(place.schedule)
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text)
                }
            }

            Divider().background(Theme.text.opacity(0.1))

            // Address
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .titleStyle(size: 20)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Location")
                        .labelStyle()
                        .foregroundStyle(Theme.text.opacity(0.6))
                    Text(place.address)
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text)
                    Text(place.postcode)
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.text)
                }
            }

            // Link
            if let link = place.link, let url = URL(string: link) {
                Divider().background(Theme.text.opacity(0.1))

                HStack(spacing: 12) {
                    Image(systemName: "link.circle.fill")
                        .titleStyle(size: 20)
                        .foregroundStyle(Theme.accent)
                        .frame(width: 28)
                    Link("Visit Website", destination: url)
                        .subheadlineStyle(size: 15)
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.accent)
                }
            }

            // Accessibility tags
            if !place.accessibility.isEmpty {
                Divider().background(Theme.text.opacity(0.1))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Accessibility")
                        .labelStyle()
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
                        .labelStyle()
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
                .headlineStyle(size: 18)
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
                                        .headlineStyle()
                                        .foregroundStyle(folk.avatarColor)
                                        .accessibilityHidden(true)
                                }

                                Text(folk.firstName)
                                    .labelStyle()
                                    .foregroundStyle(Theme.text)

                                // Fix: min size 14pt, was size 9
                                Text(folk.stage.rawValue)
                                    .caption2Style()
                                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text.opacity(0.6))
                            }
                            .frame(width: 72)
                            .frame(minHeight: A11ySize.minTouchTarget)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(folk.firstName) \(folk.lastName), \(folk.stage.rawValue)")
                        .accessibilityHint("Opens \(folk.firstName)'s profile")
                    }
                }
            }
        }
    }

    // MARK: - Activities

    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activities")
                .headlineStyle(size: 18)
                .foregroundStyle(Theme.text)

            ForEach(activities) { activity in
                NavigationLink(destination: ActivityDetailView(activity: activity)) {
                    activityRow(activity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(activity.name), \(activity.time)\(activity.recurrence.map { ", \($0)" } ?? ""), \(activity.participantIDs.count) participants")
                .accessibilityHint("Opens full activity details")
            }
        }
    }

    private func activityRow(_ activity: PlaceActivity) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 2) {
                Text(activity.date.formatted(.dateTime.day()))
                    .titleStyle(size: 22)
                    .foregroundStyle(place.category.color)
                Text(activity.date.formatted(.dateTime.month(.abbreviated)))
                    .labelStyle()
                    .foregroundStyle(Theme.text.opacity(0.6))
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.name)
                    .subheadlineStyle(size: 15)
                    .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(Theme.text)
                Text(activity.time)
                    .labelStyle()
                    .foregroundStyle(Theme.text.opacity(0.7))
                if let recurrence = activity.recurrence {
                    Text(recurrence)
                        .caption2Style()
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
                                    .stigmaFont(size: 8, name: "AtkinsonHyperlegible-Bold")
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
                                    .stigmaFont(size: 8, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text.opacity(0.6))
                            )
                    }
                }
                .padding(.top, 4)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .footnoteStyle(size: 13)
                .stigmaFont(size: 13, name: "AtkinsonHyperlegible-Bold")
                .foregroundStyle(Theme.text.opacity(0.3))
                .padding(.top, 4)
        }
        .padding(14)
        .background(Theme.glassBackground)
    }

    // MARK: - Photo Gallery

    private var placePhotoGallery: some View {
        let categoryColor = place.category.color
        // Generate placeholder photos from the place's activities and category
        let photos: [(icon: String, colors: [Color], caption: String)] = {
            var result: [(String, [Color], String)] = [
                (place.category.icon, [categoryColor, categoryColor.opacity(0.6)], place.category.rawValue),
            ]
            // Add activity-based photos
            for act in activities.prefix(3) {
                if let firstPhoto = act.photos.first {
                    result.append((firstPhoto.iconName, firstPhoto.gradientColors, firstPhoto.caption ?? act.name))
                }
            }
            // Add accessibility-themed photos
            if place.seatingAvailable {
                result.append(("chair.fill", [Color(hex: 0x81C784), Color(hex: 0x2E7D32)], "Comfortable seating"))
            }
            if place.calmEnvironment {
                result.append(("leaf.fill", [Color(hex: 0xA5D6A7), Color(hex: 0x43A047)], "Calm environment"))
            }
            return result
        }()

        return VStack(alignment: .leading, spacing: 10) {
            Text("Photos")
                .headlineStyle(size: 18)
                .foregroundStyle(Theme.text)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(photos.enumerated()), id: \.offset) { _, photo in
                        ZStack {
                            LinearGradient(
                                colors: photo.colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            VStack(spacing: 6) {
                                Image(systemName: photo.icon)
                                    .stigmaFont(size: 28, name: "AtkinsonHyperlegible-Regular")
                                    .foregroundStyle(.white.opacity(0.9))
                                Text(photo.caption)
                                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(.white.opacity(0.8))
                                    .lineLimit(1)
                            }
                        }
                        .frame(width: 160, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
    }

    // MARK: - Discovery Overlay

    private var checkInButton: some View {
        Button {
            HapticManager.shared.success()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .headlineStyle(size: 18)
                Text("Check In at \(place.name)")
                    .headlineStyle(size: 18)
            }
            .foregroundStyle(.white)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(place.category.color)
                    .shadow(color: place.category.color.opacity(0.4), radius: 12, y: 6)
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .transition(.move(edge: .bottom).combined(with: .opacity))
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
            
            // If the subview is wider than current row, and we aren't at the start of a row, move to next row
            if x + size.width > maxWidth && x > 0 {
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

