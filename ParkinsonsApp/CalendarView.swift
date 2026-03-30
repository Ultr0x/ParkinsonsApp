//
//  CalendarView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 30/03/2026.
//

import SwiftUI

struct CalendarView: View {
    @State private var eventManager = EventManager.shared
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var displayedMonth: Date = Date()
    @AppStorage("settingsLargeButtons") private var largeButtons: Bool = false
    @AppStorage("settingsHighContrast") private var highContrast: Bool = false

    private let calendar = Calendar.current
    private let dayLetters = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        monthGrid
                        dayEventsList
                        if !eventManager.joinedActivities.isEmpty {
                            myCalendarSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.light)
    }

    // MARK: - Month Grid

    private var monthGrid: some View {
        let month = calendar.component(.month, from: displayedMonth)
        let year = calendar.component(.year, from: displayedMonth)
        let monthLabel = displayedMonth.formatted(.dateTime.month(.wide).year())

        return StigmaCard {
            // Month navigation
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                    }
                    HapticFeedback.selection()
                } label: {
                    Image(systemName: "chevron.left")
                        .headlineStyle()
                        .foregroundStyle(Theme.accent)
                        .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text(monthLabel)
                        .headlineStyle(size: 18)
                        .foregroundStyle(Theme.text)
                }

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                    }
                    HapticFeedback.selection()
                } label: {
                    Image(systemName: "chevron.right")
                        .headlineStyle()
                        .foregroundStyle(Theme.accent)
                        .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
                }
            }

            // Day headers
            HStack(spacing: 0) {
                ForEach(dayLetters, id: \.self) { letter in
                    Text(letter)
                        .captionStyle(size: 12)
                        .foregroundStyle(Theme.text.opacity(0.5))
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            let days = daysInMonth(month: month, year: year)
            let firstWeekday = firstWeekdayOfMonth(month: month, year: year)
            let totalSlots = firstWeekday + days.count
            let rows = (totalSlots + 6) / 7

            VStack(spacing: 4) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { col in
                            let index = row * 7 + col
                            let dayIndex = index - firstWeekday

                            if dayIndex >= 0 && dayIndex < days.count {
                                let day = days[dayIndex]
                                let isSelected = calendar.isDate(day, inSameDayAs: selectedDate)
                                let isToday = calendar.isDateInToday(day)
                                let dayEvents = sampleActivities.filter { calendar.isDate($0.date, inSameDayAs: day) }
                                let hasEvent = !dayEvents.isEmpty
                                let hasJoinedEvent = dayEvents.contains { eventManager.isJoined($0.id) }

                                Button {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        selectedDate = day
                                    }
                                    HapticFeedback.selection()
                                } label: {
                                    VStack(spacing: 2) {
                                        ZStack {
                                            if isSelected {
                                                Circle()
                                                    .fill(Theme.accent)
                                                    .frame(width: 32, height: 32)
                                            } else if isToday {
                                                Circle()
                                                    .strokeBorder(Theme.accent, lineWidth: 1.5)
                                                    .frame(width: 32, height: 32)
                                            }
                                            Text("\(calendar.component(.day, from: day))")
                                                .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
                                                .foregroundStyle(isSelected ? .white : (isToday ? Theme.accent : Theme.text))
                                        }

                                        HStack(spacing: 2) {
                                            if hasEvent {
                                                Circle()
                                                    .fill(isSelected ? .white : Theme.accent)
                                                    .frame(width: 4, height: 4)
                                            }
                                            if hasJoinedEvent {
                                                Circle()
                                                    .fill(isSelected ? .white.opacity(0.7) : Theme.green)
                                                    .frame(width: 4, height: 4)
                                            }
                                        }
                                        .frame(height: 4)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(minHeight: 42)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Color.clear
                                    .frame(maxWidth: .infinity)
                                    .frame(minHeight: 42)
                            }
                        }
                    }
                }
            }

            // Today button
            if !calendar.isDate(selectedDate, inSameDayAs: Date()) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedDate = calendar.startOfDay(for: Date())
                        displayedMonth = Date()
                    }
                    HapticFeedback.selection()
                } label: {
                    HStack {
                        Image(systemName: "arrow.uturn.backward")
                        Text("Back to today")
                    }
                    .captionStyle()
                    .foregroundStyle(Theme.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }
            }
        }
    }

    // MARK: - Day Events

    private var dayEventsList: some View {
        let dayActivities = sampleActivities
            .filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.date < $1.date }
        let isToday = calendar.isDateInToday(selectedDate)
        let title = isToday ? "Today" : selectedDate.formatted(.dateTime.weekday(.wide).day().month())

        return VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .headlineStyle(size: 20)
                .foregroundStyle(Theme.text)

            if dayActivities.isEmpty {
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

                        NavigationLink(destination: EventsListView()) {
                            HStack(spacing: 6) {
                                Text("Explore events")
                                    .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
                                Image(systemName: "arrow.right")
                                    .captionStyle()
                            }
                            .foregroundStyle(Theme.accent)
                            .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            } else {
                ForEach(dayActivities) { activity in
                    calendarEventRow(activity)
                }
            }
        }
    }

    private func calendarEventRow(_ activity: PlaceActivity) -> some View {
        let place = placeFor(id: activity.placeID)
        let joined = eventManager.isJoined(activity.id)

        return NavigationLink(destination: ActivityDetailView(activity: activity)) {
            HStack(alignment: .top, spacing: 12) {
                // Time column
                VStack(spacing: 2) {
                    Text(activity.date.formatted(.dateTime.hour().minute()))
                        .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(Theme.accent)
                }
                .frame(width: 50, alignment: .trailing)

                // Accent bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(joined ? Theme.green : (place?.category.color ?? Theme.accent))
                    .frame(width: 3)

                // Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(activity.name)
                        .headlineStyle(size: 16)
                        .foregroundStyle(Theme.text)

                    if let place = place {
                        Text(place.name)
                            .captionStyle()
                            .foregroundStyle(Theme.text.opacity(0.6))
                    }

                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .caption2Style()
                            Text("\(activity.participantIDs.count) going")
                                .caption2Style()
                        }
                        .foregroundStyle(Theme.text.opacity(0.5))

                        if joined {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .caption2Style()
                                Text("You're going")
                                    .caption2Style()
                            }
                            .foregroundStyle(Theme.green)
                        }
                    }

                    // Join button
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            eventManager.toggleJoin(activity.id)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: joined ? "checkmark.circle.fill" : "plus.circle.fill")
                                .caption2Style()
                            Text(joined ? "You're going!" : "I'm going")
                                .stigmaFont(size: 12, name: "AtkinsonHyperlegible-Bold")
                        }
                        .foregroundStyle(joined ? .white : Theme.text)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(joined ? Theme.green : Theme.green.opacity(0.2))
                        )
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .captionStyle()
                    .foregroundStyle(Theme.text.opacity(0.3))
                    .padding(.top, 4)
            }
            .padding(14)
            .background(Theme.glassBackground)
        }
        .buttonStyle(.plain)
    }

    // MARK: - My Calendar (joined events)

    private var myCalendarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(Theme.green)
                Text("Your RSVPs")
                    .headlineStyle(size: 20)
                    .foregroundStyle(Theme.text)
            }

            ForEach(eventManager.joinedActivities) { activity in
                let place = placeFor(id: activity.placeID)

                NavigationLink(destination: ActivityDetailView(activity: activity)) {
                    HStack(spacing: 12) {
                        VStack(spacing: 0) {
                            Text(activity.date.formatted(.dateTime.weekday(.abbreviated)))
                                .caption2Style()
                                .foregroundStyle(Theme.text.opacity(0.6))
                            Text(activity.date.formatted(.dateTime.day()))
                                .stigmaFont(size: 18, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(Theme.accent)
                            Text(activity.date.formatted(.dateTime.month(.abbreviated)))
                                .caption2Style()
                                .foregroundStyle(Theme.text.opacity(0.6))
                        }
                        .frame(width: 44)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(activity.name)
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(Theme.text)
                            if let place = place {
                                Text(place.name)
                                    .captionStyle()
                                    .foregroundStyle(Theme.text.opacity(0.6))
                            }
                            Text(activity.time)
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.6))
                        }

                        Spacer()

                        Button {
                            withAnimation {
                                eventManager.toggleJoin(activity.id)
                            }
                        } label: {
                            Text("Remove")
                                .stigmaFont(size: 12, name: "AtkinsonHyperlegible-Bold")
                                .foregroundStyle(Theme.text.opacity(0.4))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(12)
                    .background(Theme.glassBackground)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Helpers

    private func daysInMonth(month: Int, year: Int) -> [Date] {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return []
        }

        return range.compactMap { day in
            var dc = DateComponents()
            dc.year = year
            dc.month = month
            dc.day = day
            return calendar.date(from: dc)
        }
    }

    private func firstWeekdayOfMonth(month: Int, year: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let firstDay = calendar.date(from: components) else { return 0 }
        let weekday = calendar.component(.weekday, from: firstDay)
        // Convert to Monday-based (Mon=0, Sun=6)
        return (weekday == 1) ? 6 : weekday - 2
    }
}

#Preview {
    CalendarView()
}
