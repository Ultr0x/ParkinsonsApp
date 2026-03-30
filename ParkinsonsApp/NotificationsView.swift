import SwiftUI

struct NotificationsView: View {
    @State private var expandedID: UUID? = nil
    @State private var appeared: Set<UUID> = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Array(sampleNotifications.enumerated()), id: \.element.id) { index, item in
                    notificationCard(item: item, index: index)
                }
            }
            .padding(16)
        }
        .background(Theme.background)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    private func notificationCard(item: NotificationItem, index: Int) -> some View {
        let isExpanded = expandedID == item.id
        
        StigmaCard {
            HStack(alignment: .top, spacing: 12) {
                iconBadge(icon: item.icon, tint: item.tint)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(item.title)
                            .subheadlineStyle(size: 15)
                            .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(Theme.text)
                        Spacer()
                        Text(item.date, style: .relative)
                            .captionStyle()
                            .foregroundStyle(Theme.text.opacity(0.6))
                    }
                    
                    Text(item.message)
                        .captionStyle()
                        .foregroundStyle(Theme.text.opacity(isExpanded ? 0.85 : 0.6))
                        .lineLimit(isExpanded ? nil : 1)
                }
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                expandedID = isExpanded ? nil : item.id
            }
        }
        .opacity(appeared.contains(item.id) ? 1 : 0)
        .offset(y: appeared.contains(item.id) ? 0 : 8)
        .onAppear {
            withAnimation(.easeOut.delay(Double(index) * 0.06)) {
                _ = appeared.insert(item.id)
            }
        }
    }
    
    private func iconBadge(icon: String, tint: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint.opacity(0.15))
                .frame(width: 36, height: 36)
            Image(systemName: icon)
                .foregroundStyle(tint)
        }
    }
}

#Preview {
    NavigationStack { NotificationsView() }
}
