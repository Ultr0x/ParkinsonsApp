import SwiftUI

struct MapPreviewView: View {
    var body: some View {
        List {
            Section(header: Text("Tulip spaces nearby").font(.headline)) {
                ForEach(samplePlaces) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(place.category.color.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                Image(systemName: place.category.icon)
                                    .foregroundStyle(place.category.color)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(place.name)
                                    .font(.subheadline.weight(.semibold))
                                Text(place.category.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Map preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { MapPreviewView() }
}
