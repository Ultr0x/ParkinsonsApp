import SwiftUI

struct EventsListView: View {
    private var upcoming: [PlaceActivity] {
        sampleActivities.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        List {
            Section(header: Text("Upcoming events").font(.headline)) {
                ForEach(upcoming) { activity in
                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                        HStack(spacing: 12) {
                            VStack(spacing: 0) {
                                Text(activity.date.formatted(.dateTime.weekday(.abbreviated)))
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(.secondary)
                                Text(activity.date.formatted(.dateTime.day()))
                                    .font(.footnote.weight(.heavy))
                            }
                            .frame(width: 36)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(activity.name)
                                    .font(.subheadline.weight(.semibold))
                                Text(activity.date.formatted(.dateTime.hour().minute()))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { EventsListView() }
}
