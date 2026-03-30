//
//  HomeView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct HomeView: View {
    var onVenueDiscovery: (() -> Void)? = nil
    @State private var eventManager = EventManager.shared
    @State private var isDiscoverable = sampleUser.isDiscoverable
    @State private var showMatchmaking = false
    @State private var showSettings = false
    @State private var showCharmSettings = false
    @State private var isPulsing = false
    @State private var nearbyDiscoverableCount: Int = 1
    @State private var selectedDay: Date = Calendar.current.startOfDay(for: Date())
    @State private var weekOffset: Int = 0
    @State private var selectedMood: String? = nil
    @State private var moodScale: [String: CGFloat] = [:]
    @State private var moodSubmitted = false
    @State private var confettiParticles: [ConfettiParticle] = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Accessibility settings
    @AppStorage("settingsSimplifiedLayout") private var simplifiedLayout: Bool = false
    @AppStorage("settingsLargeButtons") private var largeButtons: Bool = false
    @AppStorage("settingsReduceMotion") private var reduceMotionOverride: Bool = false
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false

    private var effectiveReduceMotion: Bool { reduceMotion || reduceMotionOverride }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        header
                        greetingCard
                        calendarSection
                        dayEventsSection
                        if !simplifiedLayout {
                            upcomingFeedSection
                            communityUpdateCard
                        }
                        weeklyCheckInCard
                        if !simplifiedLayout {
                            journeyProgress
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }

                if showMatchmaking {
                    MatchmakingOverlay(isVisible: $showMatchmaking)
                        .transition(.opacity)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                nearbyDiscoverableCount = sampleFolk.filter { $0.isDiscoverable }.count
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showCharmSettings) {
            CharmSettingsView()
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            LogoView(size: 22)
            Text("Stigma")
                .logoStyle(size: 24)
                .foregroundStyle(Theme.text)
                .onLongPressGesture(minimumDuration: 0.8) {
                    onVenueDiscovery?()
                }

            Spacer()

            Button {
                HapticFeedback.selection()
                showCharmSettings = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: "hand.tap.fill")
                        .subheadlineStyle(size: 15)
                        .foregroundStyle(Theme.accent)
                }
                .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
            }
            .accessibilityLabel("Charm settings")

            Button {
                showSettings = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Theme.text.opacity(0.06))
                        .frame(width: 36, height: 36)
                    Image(systemName: "gearshape.fill")
                        .subheadlineStyle(size: 15)
                        .foregroundStyle(Theme.text.opacity(0.7))
                }
                .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
            }
            .accessibilityLabel("Settings")

            NavigationLink(destination: NotificationsView()) {
                Image(systemName: "bell.fill")
                    .titleStyle(size: 20)
                    .foregroundStyle(Theme.text.opacity(0.8))
                    .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
            }
            .accessibilityLabel("Notifications")
        }
        .padding(.top, 8)
    }

    // MARK: - Greeting

    private var greetingCard: some View {
        StigmaCard {
            Text(greetingText)
                .titleStyle(size: 24)
                .foregroundStyle(Theme.text)

            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                    .subheadlineStyle()
                Text("3 community members nearby")
                    .subheadlineStyle()
            }
            .foregroundStyle(Theme.text.opacity(0.8))

            HStack(spacing: 6) {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .caption2Style()
                Text(nearbyDiscoverableCount == 1 ? "Someone nearby is discoverable" : "\(nearbyDiscoverableCount) charms nearby")
                    .labelStyle()
            }
            .foregroundStyle(Theme.text.opacity(0.7))
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeOfDay: String
        if hour < 12 { timeOfDay = "Good morning" }
        else if hour < 17 { timeOfDay = "Good afternoon" }
        else { timeOfDay = "Good evening" }
        return "\(timeOfDay), \(sampleUser.name)"
    }

    // MARK: - Interactive Calendar

    private var calendarSection: some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday == 1) ? 6 : weekday - 2
        let baseMonday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
        let monday = calendar.date(byAdding: .day, value: weekOffset * 7, to: baseMonday)!
        let days = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
        let dayLetters = ["M", "T", "W", "T", "F", "S", "S"]

        let isCurrentWeek = weekOffset == 0
        let monthLabel = monday.formatted(.dateTime.month(.wide).year())

        return StigmaCard {
            VStack(spacing: 12) {
                // Month header with navigation arrows
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            weekOffset -= 1
                            // Select monday of new week
                            let newMonday = calendar.date(byAdding: .day, value: -7, to: monday)!
                            selectedDay = newMonday
                        }
                        HapticFeedback.selection()
                    } label: {
                        Image(systemName: "chevron.left")
                            .headlineStyle()
                            .foregroundStyle(Theme.accent)
                            .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
                    }
                    .accessibilityLabel("Previous week")

                    Spacer()

                    VStack(spacing: 2) {
                        Text(monthLabel)
                            .headlineStyle(size: 18)
                            .foregroundStyle(Theme.text)
                        if isCurrentWeek {
                            Text("This week")
                                .captionStyle()
                                .foregroundStyle(Theme.accent)
                        } else {
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    weekOffset = 0
                                    selectedDay = today
                                }
                                HapticFeedback.selection()
                            } label: {
                                Text("Back to today")
                                    .captionStyle()
                                    .foregroundStyle(Theme.accent)
                            }
                        }
                    }

                    Spacer()

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            weekOffset += 1
                            let newMonday = calendar.date(byAdding: .day, value: 7, to: monday)!
                            selectedDay = newMonday
                        }
                        HapticFeedback.selection()
                    } label: {
                        Image(systemName: "chevron.right")
                            .headlineStyle()
                            .foregroundStyle(Theme.accent)
                            .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
                    }
                    .accessibilityLabel("Next week")
                }

                // Day strip
                HStack(spacing: 0) {
                    ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                        let isSelected = calendar.isDate(day, inSameDayAs: selectedDay)
                        let isToday = calendar.isDateInToday(day)
                        let dayEvents = sampleActivities.filter { calendar.isDate($0.date, inSameDayAs: day) }
                        let hasEvent = !dayEvents.isEmpty
                        let hasJoinedEvent = dayEvents.contains { eventManager.isJoined($0.id) }

                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedDay = day
                            }
                            HapticFeedback.selection()
                        } label: {
                            VStack(spacing: 4) {
                                Text(dayLetters[index])
                                    .captionStyle(size: 11)
                                    .foregroundStyle(isSelected ? .white : Theme.text.opacity(0.55))

                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .fill(Theme.accent)
                                            .frame(width: 36, height: 36)
                                    } else if isToday {
                                        Circle()
                                            .strokeBorder(Theme.accent, lineWidth: 1.5)
                                            .frame(width: 36, height: 36)
                                    }
                                    Text(day.formatted(.dateTime.day()))
                                        .footnoteStyle(size: 15)
                                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                        .foregroundStyle(isSelected ? .white : (isToday ? Theme.accent : Theme.text))
                                }

                                HStack(spacing: 2) {
                                    if hasEvent {
                                        Circle()
                                            .fill(isSelected ? .white : Theme.accent)
                                            .frame(width: 5, height: 5)
                                    }
                                    if hasJoinedEvent {
                                        Circle()
                                            .fill(isSelected ? .white.opacity(0.7) : Theme.green)
                                            .frame(width: 5, height: 5)
                                    }
                                    if !hasEvent && !hasJoinedEvent {
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: 5, height: 5)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: A11ySize.minTouchTarget)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(day.formatted(.dateTime.weekday(.wide).day().month()))\(hasEvent ? ", \(dayEvents.count) events" : "")\(hasJoinedEvent ? ", you're attending" : "")")
                    }
                }
            }
        }
    }

    // MARK: - Day Events (selected day)

    private var dayEventsSection: some View {
        let calendar = Calendar.current
        let dayActivities = sampleActivities
            .filter { calendar.isDate($0.date, inSameDayAs: selectedDay) }
            .sorted { $0.date < $1.date }
        let isToday = calendar.isDateInToday(selectedDay)
        let title = isToday
            ? "Today's events"
            : selectedDay.formatted(.dateTime.weekday(.wide).day().month())

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .headlineStyle(size: 20)
                    .foregroundStyle(Theme.text)
                Spacer()
                if !dayActivities.isEmpty {
                    Text("\(dayActivities.count) event\(dayActivities.count == 1 ? "" : "s")")
                        .captionStyle()
                        .foregroundStyle(Theme.text.opacity(0.5))
                }
            }

            if dayActivities.isEmpty {
                emptyDayCard
                    .transition(.opacity.combined(with: .offset(y: 8)))
            } else {
                ForEach(dayActivities) { activity in
                    EventFeedCard(activity: activity, eventManager: eventManager)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(y: 16)).combined(with: .scale(scale: 0.98)),
                            removal: .opacity.combined(with: .scale(scale: 0.98))
                        ))
                }
            }
        }
        .animation(effectiveReduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.85), value: selectedDay)
    }

    private var emptyDayCard: some View {
        StigmaCard {
            VStack(spacing: 8) {
                Image(systemName: "calendar")
                    .titleStyle(size: 28)
                    .foregroundStyle(Theme.text.opacity(0.25))
                Text("Your calendar is clear")
                    .headlineStyle()
                    .foregroundStyle(Theme.text.opacity(0.55))
                Text("Browse events to find something you'd enjoy.")
                    .captionStyle()
                    .foregroundStyle(Theme.text.opacity(0.4))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Upcoming Feed (next events)

    private var upcomingFeedSection: some View {
        let calendar = Calendar.current
        let upcoming = sampleActivities
            .filter { $0.date > Date() && !calendar.isDate($0.date, inSameDayAs: selectedDay) }
            .sorted { $0.date < $1.date }
            .prefix(3)

        return Group {
            if !upcoming.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Coming up")
                        .headlineStyle(size: 20)
                        .foregroundStyle(Theme.text)

                    ForEach(Array(upcoming)) { activity in
                        EventFeedCard(activity: activity, eventManager: eventManager, compact: true)
                    }

                    NavigationLink(destination: EventsListView()) {
                        HStack {
                            Spacer()
                            Text("See all events")
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                            Image(systemName: "chevron.right")
                                .captionStyle()
                            Spacer()
                        }
                        .foregroundStyle(Theme.accent)
                        .padding(.vertical, 12)
                        .background(Theme.glassBackground)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Community Update

    private var communityUpdateCard: some View {
        StigmaCard {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Theme.accent)
                Text("This week in your community")
                    .captionStyle()
                    .foregroundStyle(Theme.accent)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .captionStyle()
                        .foregroundStyle(Theme.cyan)
                    Text("\(sampleFolk.count) members active nearby")
                        .subheadlineStyle()
                        .foregroundStyle(Theme.text)
                }
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .captionStyle()
                        .foregroundStyle(Theme.green)
                    Text("\(sampleActivities.filter { $0.date > Date() }.count) events happening")
                        .subheadlineStyle()
                        .foregroundStyle(Theme.text)
                }
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle.fill")
                        .captionStyle()
                        .foregroundStyle(Theme.orange)
                    Text("\(samplePlaces.filter { $0.isTulipCertified }.count) tulip spaces certified")
                        .subheadlineStyle()
                        .foregroundStyle(Theme.text)
                }
            }

            Text("\"\(sampleFolk.count) people in London carried their Charm this week\"")
                .footnoteStyle()
                .foregroundStyle(Theme.text.opacity(0.6))
                .padding(.top, 4)
        }
    }

    // MARK: - Weekly Check-in

    private var weeklyCheckInCard: some View {
        let moods: [(emoji: String, label: String, color: Color)] = [
            ("😢", "Struggling", Color(hex: 0x7986CB)),
            ("😕", "Not great", Color(hex: 0xFFB74D)),
            ("😐", "Okay", Color(hex: 0xBCAAA4)),
            ("🙂", "Good", Color(hex: 0x81C784)),
            ("😄", "Great", Color(hex: 0xFFD54F))
        ]

        return StigmaCard {
            if moodSubmitted {
                // Thank you state
                VStack(spacing: 12) {
                    Text("Thanks for sharing")
                        .headlineStyle(size: 18)
                        .foregroundStyle(Theme.text)

                    if let selected = selectedMood,
                       let mood = moods.first(where: { $0.emoji == selected }) {
                        Text(mood.emoji)
                            .font(.system(size: 48))
                            .scaleEffect(1.2)

                        Text("You're feeling \(mood.label.lowercased()) this week")
                            .subheadlineStyle()
                            .foregroundStyle(Theme.text.opacity(0.7))
                    }

                    Text("Here's to next week")
                        .captionStyle()
                        .foregroundStyle(Theme.accent)

                    // Mini sparkle particles
                    ZStack {
                        ForEach(confettiParticles) { p in
                            Circle()
                                .fill(p.color)
                                .frame(width: p.size, height: p.size)
                                .offset(x: p.x, y: p.y)
                                .opacity(p.opacity)
                        }
                    }
                    .frame(height: 20)
                }
                .frame(maxWidth: .infinity)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                VStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Text("Weekly reflection")
                            .captionStyle()
                            .foregroundStyle(Theme.accent)
                        Text("How has this week been?")
                            .headlineStyle(size: 18)
                            .foregroundStyle(Theme.text)
                    }

                    // Emoji row
                    HStack(spacing: 4) {
                        ForEach(moods, id: \.emoji) { mood in
                            let isSelected = selectedMood == mood.emoji
                            let scale = moodScale[mood.emoji] ?? 1.0

                            Button {
                                selectMood(mood.emoji)
                            } label: {
                                VStack(spacing: 6) {
                                    Text(mood.emoji)
                                        .font(.system(size: isSelected ? 44 : 32))
                                        .scaleEffect(scale)
                                        .shadow(color: isSelected ? mood.color.opacity(0.5) : .clear, radius: isSelected ? 12 : 0)

                                    Text(mood.label)
                                        .stigmaFont(size: 10, name: "AtkinsonHyperlegible-Bold")
                                        .foregroundStyle(isSelected ? mood.color : Theme.text.opacity(0.4))
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(isSelected ? mood.color.opacity(0.15) : Color.clear)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(isSelected ? mood.color.opacity(0.3) : Color.clear, lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(mood.label)
                            .accessibilityHint("Select \(mood.label) as your mood")
                            .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                        }
                    }

                    // Confidence slider hint
                    if selectedMood != nil {
                        VStack(spacing: 10) {
                            // Submit button
                            Button {
                                submitMood()
                            } label: {
                                HStack(spacing: 6) {
                                    Text("Submit")
                                        .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
                                    Image(systemName: "arrow.right.circle.fill")
                                        .captionStyle()
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Theme.accent)
                                )
                            }
                            .buttonStyle(.plain)
                            .transition(.opacity.combined(with: .offset(y: 8)))

                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    selectedMood = nil
                                }
                            } label: {
                                Text("Skip")
                                    .captionStyle()
                                    .foregroundStyle(Theme.text.opacity(0.4))
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .animation(effectiveReduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.8), value: selectedMood)
        .animation(effectiveReduceMotion ? .none : .spring(response: 0.5, dampingFraction: 0.8), value: moodSubmitted)
    }

    private func selectMood(_ emoji: String) {
        // Bounce animation
        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
            selectedMood = emoji
            moodScale[emoji] = 1.3
        }

        // Haptic
        HapticManager.shared.softDoublePulse()

        // Scale back
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.15)) {
            moodScale[emoji] = 1.0
        }
    }

    private func submitMood() {
        HapticManager.shared.success()

        // Generate confetti particles
        var particles: [ConfettiParticle] = []
        let colors: [Color] = [Theme.accent, Theme.green, Theme.cyan, Theme.orange, .yellow]
        for i in 0..<12 {
            particles.append(ConfettiParticle(
                id: i,
                x: CGFloat.random(in: -80...80),
                y: CGFloat.random(in: -20...20),
                size: CGFloat.random(in: 4...8),
                color: colors[i % colors.count],
                opacity: 1.0
            ))
        }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            moodSubmitted = true
            confettiParticles = particles
        }

        // Fade out confetti
        withAnimation(.easeOut(duration: 1.5).delay(0.5)) {
            confettiParticles = confettiParticles.map {
                var p = $0
                p.opacity = 0
                p.y -= 20
                return p
            }
        }
    }

    // MARK: - Journey

    private var journeyProgress: some View {
        StigmaCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your journey")
                    .headlineStyle(size: 18)
                    .foregroundStyle(Theme.text)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: "largecircle.fill.circle")
                            .foregroundStyle(Theme.accent)
                        Text("Private connection")
                            .subheadlineStyle(size: 15)
                            .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(Theme.text)
                    }
                    HStack(spacing: 8) {
                        Image(systemName: eventManager.joinedEventIDs.isEmpty ? "circle" : "largecircle.fill.circle")
                            .foregroundStyle(eventManager.joinedEventIDs.isEmpty ? Theme.text.opacity(0.4) : Theme.green)
                        Text("First meetup")
                            .subheadlineStyle(size: 15)
                            .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(eventManager.joinedEventIDs.isEmpty ? Theme.text.opacity(0.7) : Theme.text)
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "circle")
                            .foregroundStyle(Theme.text.opacity(0.4))
                        Text("Community supporter")
                            .subheadlineStyle(size: 15)
                            .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(Theme.text.opacity(0.7))
                    }
                }
            }
        }
    }
}

// MARK: - Event Feed Card

struct EventFeedCard: View {
    let activity: PlaceActivity
    var eventManager: EventManager
    var compact: Bool = false
    @State private var joinBounce: Bool = false
    @AppStorage("settingsSimplifiedLayout") private var simplifiedLayout: Bool = false
    @AppStorage("settingsLargeButtons") private var largeButtons: Bool = false
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false

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
        NavigationLink(destination: ActivityDetailView(activity: activity)) {
            VStack(alignment: .leading, spacing: 0) {
                // Hero photo area (hidden in simplified mode)
                if !compact && !simplifiedLayout {
                    eventHeroImage
                }

                VStack(alignment: .leading, spacing: 10) {
                    // Title & Date
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.name)
                            .headlineStyle(size: compact ? 16 : 18)
                            .foregroundStyle(Theme.text)
                            .lineLimit(2)

                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .captionStyle()
                            Text(activity.date.formatted(.dateTime.weekday(.wide).day().month()))
                                .captionStyle()
                            Text("·")
                                .captionStyle()
                            Text(activity.time)
                                .captionStyle()
                        }
                        .foregroundStyle(Theme.text.opacity(0.6))

                        if let place = place {
                            HStack(spacing: 6) {
                                Image(systemName: "mappin")
                                    .captionStyle()
                                Text(place.name)
                                    .captionStyle()
                            }
                            .foregroundStyle(Theme.text.opacity(0.6))
                        }
                    }

                    // Attendees & stage
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .captionStyle()
                                .foregroundStyle(Theme.green)
                            Text("\(participants.count) going")
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.7))
                        }

                        if let stage = activity.stageFilter {
                            PillBadge(text: stage.rawValue, tint: Theme.cyan, systemImage: stage.icon)
                        } else {
                            PillBadge(text: "All stages", tint: Theme.cyan, systemImage: "person.3.fill")
                        }
                    }

                    // Participant avatars (hidden in simplified mode)
                    if !compact && !simplifiedLayout {
                        HStack(spacing: -6) {
                            ForEach(participants.prefix(5)) { folk in
                                Circle()
                                    .fill(folk.avatarColor.opacity(0.3))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Text(folk.initials)
                                            .stigmaFont(size: 10, name: "AtkinsonHyperlegible-Bold")
                                            .foregroundStyle(folk.avatarColor)
                                    )
                                    .overlay(Circle().stroke(Theme.cardBackground, lineWidth: 1.5))
                            }
                            if participants.count > 5 {
                                Circle()
                                    .fill(Theme.text.opacity(0.1))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Text("+\(participants.count - 5)")
                                            .stigmaFont(size: 10, name: "AtkinsonHyperlegible-Bold")
                                            .foregroundStyle(Theme.text.opacity(0.6))
                                    )
                            }
                        }
                    }

                    // Photo gallery preview (hidden in simplified mode)
                    if !compact && !simplifiedLayout && !activity.photos.isEmpty {
                        photoGalleryStrip
                    }

                    // Action buttons
                    HStack(spacing: 10) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                joinBounce = true
                                eventManager.toggleJoin(activity.id)
                            }
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.15)) {
                                joinBounce = false
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: isJoined ? "checkmark.circle.fill" : "plus.circle.fill")
                                    .symbolEffect(.bounce, value: isJoined)
                                Text(isJoined ? "You're going!" : "I'm going")
                                    .stigmaFont(size: largeButtons ? 17 : 14, name: "AtkinsonHyperlegible-Bold")
                            }
                            .foregroundStyle(isJoined ? .white : Theme.text)
                            .padding(.horizontal, largeButtons ? 20 : 16)
                            .padding(.vertical, largeButtons ? 16 : 10)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: largeButtons ? A11ySize.largeTouchTarget : 0)
                            .background(
                                RoundedRectangle(cornerRadius: largeButtons ? 16 : 12, style: .continuous)
                                    .fill(isJoined ? Theme.green : Theme.green.opacity(0.2))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: largeButtons ? 16 : 12, style: .continuous)
                                    .stroke(highContrast ? Theme.text.opacity(0.3) : Color.clear, lineWidth: 1.5)
                            )
                            .scaleEffect(joinBounce ? 1.05 : 1.0)
                        }
                        .buttonStyle(.plain)

                        if !compact {
                            Button {
                                // dismiss / not for me
                            } label: {
                                Text("Not for me")
                                    .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(Theme.text.opacity(0.5))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(Theme.text.opacity(0.15), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(14)
            }
            .background(Theme.glassBackground)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Hero Image

    private var eventHeroImage: some View {
        ZStack(alignment: .bottomLeading) {
            let colors = activity.photos.first?.gradientColors ?? [
                (place?.category.color ?? Theme.accent).opacity(0.2),
                (place?.category.color ?? Theme.accent).opacity(0.05)
            ]
            LinearGradient(colors: colors.map { $0.opacity(0.3) }, startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 160)
                .overlay(
                    Image(systemName: place?.category.icon ?? "calendar")
                        .stigmaFont(size: 48, name: "AtkinsonHyperlegible-Regular")
                        .foregroundStyle(.white.opacity(0.3))
                )

            // Overlay label
            if let recurrence = activity.recurrence {
                PillBadge(text: recurrence, tint: .white)
                    .padding(12)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Photo Gallery Strip

    private var photoGalleryStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(activity.photos) { photo in
                    ZStack {
                        LinearGradient(
                            colors: photo.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        VStack(spacing: 4) {
                            Image(systemName: photo.iconName)
                                .stigmaFont(size: 24, name: "AtkinsonHyperlegible-Regular")
                                .foregroundStyle(.white.opacity(0.9))
                            if let caption = photo.caption {
                                Text(caption)
                                    .stigmaFont(size: 10, name: "AtkinsonHyperlegible-Bold")
                                    .foregroundStyle(.white.opacity(0.8))
                                    .lineLimit(1)
                            }
                        }
                    }
                    .frame(width: 120, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }
}

// MARK: - Confetti Particle

struct ConfettiParticle: Identifiable {
    let id: Int
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var color: Color
    var opacity: Double
}

#Preview {
    HomeView()
}
