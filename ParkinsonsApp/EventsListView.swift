import SwiftUI

struct EventsListView: View {
    @State private var eventManager = EventManager.shared

    private var upcoming: [PlaceActivity] {
        sampleActivities
            .filter { $0.date >= Calendar.current.startOfDay(for: Date()) }
            .sorted { $0.date < $1.date }
    }

    private var past: [PlaceActivity] {
        sampleActivities
            .filter { $0.date < Calendar.current.startOfDay(for: Date()) }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Joined events banner
                if !eventManager.joinedActivities.isEmpty {
                    joinedBanner
                }

                // Upcoming
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upcoming")
                        .headlineStyle(size: 20)
                        .foregroundStyle(Theme.text)

                    ForEach(upcoming) { activity in
                        eventRow(activity)
                    }
                }

                // Past
                if !past.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent")
                            .headlineStyle(size: 20)
                            .foregroundStyle(Theme.text.opacity(0.6))

                        ForEach(past) { activity in
                            eventRow(activity, isPast: true)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Theme.background)
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.light)
    }

    // MARK: - Joined Banner

    private var joinedBanner: some View {
        StigmaCard {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(Theme.green)
                Text("You're going to \(eventManager.joinedEventIDs.count) event\(eventManager.joinedEventIDs.count == 1 ? "" : "s")")
                    .headlineStyle()
                    .foregroundStyle(Theme.text)
            }
        }
    }

    // MARK: - Event Row

    private func eventRow(_ activity: PlaceActivity, isPast: Bool = false) -> some View {
        let place = placeFor(id: activity.placeID)
        let joined = eventManager.isJoined(activity.id)

        return NavigationLink(destination: ActivityDetailView(activity: activity)) {
            HStack(alignment: .top, spacing: 12) {
                // Date block
                VStack(spacing: 2) {
                    Text(activity.date.formatted(.dateTime.weekday(.abbreviated)))
                        .caption2Style()
                        .foregroundStyle(Theme.text.opacity(0.6))
                    Text(activity.date.formatted(.dateTime.day()))
                        .stigmaFont(size: 22, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(isPast ? Theme.text.opacity(0.4) : Theme.accent)
                    Text(activity.date.formatted(.dateTime.month(.abbreviated)))
                        .caption2Style()
                        .foregroundStyle(Theme.text.opacity(0.6))
                }
                .frame(width: 44)

                VStack(alignment: .leading, spacing: 6) {
                    Text(activity.name)
                        .headlineStyle(size: 16)
                        .foregroundStyle(isPast ? Theme.text.opacity(0.5) : Theme.text)
                        .lineLimit(2)

                    if let place = place {
                        HStack(spacing: 4) {
                            Image(systemName: place.category.icon)
                                .captionStyle()
                                .foregroundStyle(place.category.color)
                            Text(place.name)
                                .captionStyle()
                                .foregroundStyle(Theme.text.opacity(0.6))
                        }
                    }

                    HStack(spacing: 8) {
                        Text(activity.time)
                            .captionStyle()
                            .foregroundStyle(Theme.text.opacity(0.5))

                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .caption2Style()
                            Text("\(activity.participantIDs.count)")
                                .caption2Style()
                        }
                        .foregroundStyle(Theme.text.opacity(0.5))
                    }

                    // Photo strip
                    if !activity.photos.isEmpty && !isPast {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(activity.photos.prefix(3)) { photo in
                                    ZStack {
                                        LinearGradient(colors: photo.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                                        Image(systemName: photo.iconName)
                                            .stigmaFont(size: 16, name: "AtkinsonHyperlegible-Regular")
                                            .foregroundStyle(.white.opacity(0.8))
                                    }
                                    .frame(width: 50, height: 36)
                                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                }
                            }
                        }
                    }

                    if !isPast {
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
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .captionStyle()
                    .foregroundStyle(Theme.text.opacity(0.3))
                    .padding(.top, 4)
            }
            .padding(14)
            .background(Theme.glassBackground)
            .opacity(isPast ? 0.7 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack { EventsListView() }
}
