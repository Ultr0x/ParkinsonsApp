import SwiftUI

struct NotificationItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let message: String
    let date: Date
    let tint: Color
}

let sampleNotifications: [NotificationItem] = [
    NotificationItem(icon: "bell.fill", title: "Reminder", message: "Don't forget your meeting at 3 PM.", date: Date().addingTimeInterval(-300), tint: .blue),
    NotificationItem(icon: "envelope.fill", title: "New Message", message: "You have received a new message.", date: Date().addingTimeInterval(-6000), tint: .green),
    NotificationItem(icon: "star.fill", title: "Achievement", message: "You reached a new milestone!", date: Date().addingTimeInterval(-86400), tint: .yellow),
    NotificationItem(icon: "exclamationmark.triangle.fill", title: "Warning", message: "Your subscription is about to expire.", date: Date().addingTimeInterval(-172800), tint: .red)
]

struct NotificationsView: View {
    var body: some View {
        List {
            ForEach(sampleNotifications) { item in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(item.tint.opacity(0.15))
                            .frame(width: 36, height: 36)
                        Image(systemName: item.icon)
                            .foregroundStyle(item.tint)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.title)
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text(item.date, style: .relative)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(item.message)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { NotificationsView() }
}
