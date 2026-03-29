//
//  MapScreen.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var places: [CommunityPlace] = samplePlaces
    @State private var selectedPlace: CommunityPlace? = nil

    @State private var searchText: String = ""
    @State private var isSheetExpanded: Bool = false
    @GestureState private var sheetTranslation: CGFloat = 0
    @State private var selectedCategory: PlaceCategory? = nil
    @State private var showFriendlyOnly: Bool = false
    @State private var showEventsOnly: Bool = false

    private let collapsedSheetHeight: CGFloat = 100
    private let expandedSheetHeight: CGFloat = 480

    private var filteredPlaces: [CommunityPlace] {
        var result = places
        if let cat = selectedCategory {
            result = result.filter { $0.category == cat }
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(q) ||
                $0.category.rawValue.lowercased().contains(q) ||
                $0.address.lowercased().contains(q)
            }
        }
        if showFriendlyOnly {
            result = result.filter { $0.isParkinsonsFriendly }
        }
        if showEventsOnly {
            result = result.filter { !$0.activityIDs.isEmpty }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Map(position: $position, selection: .constant(nil)) {
                    ForEach(filteredPlaces) { place in
                        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                        Annotation(place.name, coordinate: coordinate) {
                            Button {
                                selectedPlace = place
                            } label: {
                                ZStack(alignment: .bottomTrailing) {
                                    Circle()
                                        .fill(place.category.color)
                                        .frame(width: 34, height: 34)
                                        .shadow(color: place.category.color.opacity(0.4), radius: 4, x: 0, y: 2)
                                    Image(systemName: place.category.icon)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                    if place.isParkinsonsFriendly {
                                        ZStack {
                                            Circle()
                                                .fill(Theme.background)
                                                .frame(width: 14, height: 14)
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundStyle(Theme.accent)
                                        }
                                        .offset(x: 8, y: 8)
                                    }
                                }
                            }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .onAppear(perform: configure)
                .ignoresSafeArea()

                // Bottom sheet
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 12) {
                        // Drag handle
                        Capsule()
                            .fill(Theme.text.opacity(0.3))
                            .frame(width: 36, height: 4)
                            .padding(.top, 8)
                            .padding(.bottom, 4)

                        // Search Bar
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Theme.text.opacity(0.7))
                                .font(.system(size: 20))

                            TextField("Search places...", text: $searchText)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .onSubmit { isSheetExpanded = true }
                                .font(.system(size: 18))
                                .foregroundStyle(Theme.text)

                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Theme.text.opacity(0.6))
                                }
                            }

                            Image(systemName: "mic.fill")
                                .foregroundStyle(Theme.text.opacity(0.7))
                                .font(.system(size: 18))

                            ZStack {
                                Circle()
                                    .fill(Theme.accent.opacity(0.2))
                                    .frame(width: 32, height: 32)
                                Text(sampleUser.name.prefix(1))
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.accent)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Theme.background)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Theme.text.opacity(0.1), lineWidth: 1)
                                )
                                .shadow(color: Theme.text.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 12)

                        ScrollView {
                            // Category Filter Chips
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    categoryChip(nil, label: "All", icon: "map.fill", color: Theme.text)
                                    // Special filters
                                    toggleChip(isOn: $showFriendlyOnly, label: "Parkinson’s Friendly", icon: "checkmark.seal.fill", color: Theme.accent)
                                    toggleChip(isOn: $showEventsOnly, label: "Events", icon: "calendar", color: Theme.green)
                                    // Categories
                                    ForEach(Array(Set(samplePlaces.map(\.category))).sorted(by: { $0.rawValue < $1.rawValue }), id: \.rawValue) { cat in
                                        categoryChip(cat, label: cat.rawValue, icon: cat.icon, color: cat.color)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.bottom, 8)

                            // Section Header
                            HStack {
                                Text("Community Places")
                                    .font(.headline.weight(.heavy))
                                    .fontDesign(.rounded)
                                    .foregroundStyle(Theme.text)
                                Spacer()
                                Text("\(filteredPlaces.count) places")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.text.opacity(0.5))
                                Button {
                                    isSheetExpanded.toggle()
                                } label: {
                                    Image(systemName: isSheetExpanded ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                                        .font(.title3.weight(.semibold))
                                        .foregroundStyle(Theme.accent)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)

                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(filteredPlaces) { place in
                                    NavigationLink(destination: PlaceDetailView(place: place)) {
                                        placeRow(place)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 24)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Theme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .stroke(Theme.text.opacity(0.05), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: -6)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .frame(height: max(collapsedSheetHeight, min(expandedSheetHeight, (isSheetExpanded ? expandedSheetHeight : collapsedSheetHeight) - sheetTranslation)))
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .updating($sheetTranslation) { value, state, _ in
                                state = value.translation.height
                            }
                            .onEnded { value in
                                let threshold: CGFloat = 60
                                if value.translation.height < -threshold {
                                    isSheetExpanded = true
                                } else if value.translation.height > threshold {
                                    isSheetExpanded = false
                                }
                            }
                    )
                    .padding(.horizontal, 8)
                    .padding(.bottom, .zero)
                }
            }
            .navigationDestination(item: $selectedPlace) { place in
                PlaceDetailView(place: place)
            }
            .preferredColorScheme(.light)
            .tint(Theme.text)
        }
    }

    // MARK: - Components

    private func categoryChip(_ category: PlaceCategory?, label: String, icon: String, color: Color) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCategory = category
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                Text(label)
                    .font(.footnote.weight(.bold))
                    .fontDesign(.rounded)
            }
            .foregroundStyle(isSelected ? .white : Theme.text)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? color : Theme.cardBackground)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(isSelected ? color : Theme.text.opacity(0.1), lineWidth: 1)
            )
        }
    }

    private func toggleChip(isOn: Binding<Bool>, label: String, icon: String, color: Color) -> some View {
        let selected = isOn.wrappedValue
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.wrappedValue.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                Text(label)
                    .font(.footnote.weight(.bold))
                    .fontDesign(.rounded)
            }
            .foregroundStyle(selected ? .white : Theme.text)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(selected ? color : Theme.cardBackground)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(selected ? color : Theme.text.opacity(0.1), lineWidth: 1)
            )
        }
    }

    private func placeRow(_ place: CommunityPlace) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if place.isParkinsonsFriendly {
                Image(systemName: "checkmark.seal.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accent)
            }
            // Category icon
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(place.category.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: place.category.icon)
                    .foregroundStyle(place.category.color)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.text)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(place.category.rawValue)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(place.category.color)
                    if place.isParkinsonsFriendly {
                        Text("· Parkinson’s Friendly")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Theme.accent)
                    }
                    if let cost = place.cost {
                        Text("\u{00B7} \(cost)")
                            .font(.caption2)
                            .foregroundStyle(Theme.text.opacity(0.6))
                    }
                }

                Text(place.schedule)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(Theme.text.opacity(0.6))
                    .lineLimit(1)

                // Member avatars
                HStack(spacing: -6) {
                    ForEach(place.memberIDs.prefix(4).compactMap({ folkFor(id: $0) })) { folk in
                        Circle()
                            .fill(folk.avatarColor.opacity(0.3))
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text(folk.initials)
                                    .font(.system(size: 7).weight(.bold))
                                    .foregroundStyle(folk.avatarColor)
                            )
                            .overlay(Circle().stroke(Theme.cardBackground, lineWidth: 1.5))
                    }
                    if place.memberIDs.count > 4 {
                        Circle()
                            .fill(Theme.text.opacity(0.1))
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("+\(place.memberIDs.count - 4)")
                                    .font(.system(size: 7).weight(.bold))
                                    .foregroundStyle(Theme.text.opacity(0.6))
                            )
                    }
                }
                .padding(.top, 2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.text.opacity(0.3))
        }
        .padding(14)
        .background(Theme.glassBackground)
    }

    // MARK: - Helpers

    private func configure() {
        // Center on London, zoomed out to see all places
        let coord = CLLocationCoordinate2D(latitude: 51.51, longitude: -0.14)
        position = .region(MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)))
    }
}

// Make CommunityPlace Hashable for navigationDestination
extension CommunityPlace: Hashable {
    static func == (lhs: CommunityPlace, rhs: CommunityPlace) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview {
    MapScreen()
}
