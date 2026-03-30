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
    
    // Popup state
    @State private var tappedPlace: CommunityPlace? = nil
    @State private var navigateToPlace: CommunityPlace? = nil
    
    // Sheet / filter state
    @State private var searchText: String = ""
    @State private var sheetDetent: SheetDetent = .collapsed
    @State private var selectedCategory: PlaceCategory? = nil
    @State private var showFriendlyOnly: Bool = false
    @State private var showEventsOnly: Bool = false
    
    // Animation state for staggered appearance
    @State private var appeared: Set<UUID> = []
    
    private enum SheetDetent {
        case collapsed, expanded
    }

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
            result = result.filter { $0.isTulipCertified }
        }
        if showEventsOnly {
            result = result.filter { !$0.activityIDs.isEmpty }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // MARK: - Map
                Map(position: $position, selection: .constant(nil)) {
                    ForEach(filteredPlaces) { place in
                        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                        let isHub = place.hostsEvents
                        let markerSize: CGFloat = isHub ? 44 : 32
                        let iconSize: CGFloat = isHub ? 18 : 13
                        
                        Annotation(place.name, coordinate: coordinate) {
                            Button {
                                HapticFeedback.impact(.soft)
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                    if tappedPlace?.id == place.id {
                                        navigateToPlace = place
                                    } else {
                                        tappedPlace = place
                                        sheetDetent = .collapsed
                                    }
                                }
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    position = .region(MKCoordinateRegion(
                                        center: CLLocationCoordinate2D(latitude: place.latitude - 0.005, longitude: place.longitude),
                                        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                                    ))
                                }
                            } label: {
                                ZStack {
                                    if isHub {
                                        Circle()
                                            .fill(place.category.color)
                                            .frame(width: markerSize, height: markerSize)
                                            .shadow(color: place.category.color.opacity(0.5), radius: 6, x: 0, y: 3)
                                    } else {
                                        Circle()
                                            .fill(place.category.color.opacity(0.25))
                                            .frame(width: markerSize, height: markerSize)
                                            .shadow(color: place.category.color.opacity(0.15), radius: 3, x: 0, y: 1)
                                    }
                                    
                                    Image(systemName: place.category.icon)
                                        .stigmaFont(size: iconSize, name: "AtkinsonHyperlegible-Bold")
                                        .foregroundStyle(isHub ? .white : place.category.color)
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    if place.communityVerified {
                                        ZStack {
                                            Circle()
                                                .fill(Theme.background)
                                                .frame(width: isHub ? 18 : 14, height: isHub ? 18 : 14)
                                            Image(systemName: "checkmark.circle.fill")
                                                .stigmaFont(size: isHub ? 14 : 11, name: "AtkinsonHyperlegible-Bold")
                                                .foregroundStyle(Theme.green)
                                        }
                                        .offset(x: isHub ? 4 : 2, y: isHub ? 4 : 2)
                                    }
                                }
                                .scaleEffect(tappedPlace?.id == place.id ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: tappedPlace?.id)
                                // Ensure 60pt minimum tap target on map pins
                                .frame(minWidth: A11ySize.minTouchTarget, minHeight: A11ySize.minTouchTarget)
                                .contentShape(Rectangle())
                            }
                            .accessibilityLabel(place.name)
                            .accessibilityHint("\(place.category.rawValue). \(place.isTulipCertified ? "Tulip certified. " : "")Tap to see details")
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .onAppear(perform: configure)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        tappedPlace = nil
                    }
                }
                
                // MARK: - Popup Callout
                if let place = tappedPlace {
                    VStack(spacing: 0) {
                        Spacer()

                        Button {
                            navigateToPlace = place
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                // Gradient hero strip
                                ZStack(alignment: .bottomLeading) {
                                    LinearGradient(
                                        colors: [place.category.color.opacity(0.3), place.category.color.opacity(0.08)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .frame(height: 64)
                                    .overlay(
                                        Image(systemName: place.category.icon)
                                            .stigmaFont(size: 32, name: "AtkinsonHyperlegible-Regular")
                                            .foregroundStyle(place.category.color.opacity(0.2))
                                    )

                                    HStack(spacing: 6) {
                                        PillBadge(text: place.category.rawValue, tint: place.category.color, systemImage: place.category.icon)
                                        if place.isTulipCertified {
                                            PillBadge(text: "Friendly", tint: Theme.green, systemImage: "checkmark.seal.fill")
                                        }
                                    }
                                    .padding(10)
                                }

                                // Content
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 10) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(place.name)
                                                .headlineStyle(size: 17)
                                                .foregroundStyle(Theme.text)
                                                .lineLimit(1)

                                            HStack(spacing: 8) {
                                                if place.hostsEvents {
                                                    HStack(spacing: 4) {
                                                        Image(systemName: "star.fill")
                                                            .caption2Style()
                                                        Text("Community Hub")
                                                            .caption2Style()
                                                    }
                                                    .foregroundStyle(Theme.accent)
                                                }
                                                if place.communityVerified {
                                                    HStack(spacing: 4) {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .caption2Style()
                                                        Text("Verified")
                                                            .caption2Style()
                                                    }
                                                    .foregroundStyle(Theme.green)
                                                }
                                            }
                                        }

                                        Spacer()

                                        // Open arrow
                                        ZStack {
                                            Circle()
                                                .fill(Theme.accent.opacity(0.15))
                                                .frame(width: 36, height: 36)
                                            Image(systemName: "arrow.right")
                                                .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
                                                .foregroundStyle(Theme.accent)
                                        }
                                    }

                                    // Quick stats row
                                    HStack(spacing: 12) {
                                        let memberCount = place.memberIDs.count
                                        let activityCount = activitiesFor(placeID: place.id).count

                                        if memberCount > 0 {
                                            HStack(spacing: 4) {
                                                Image(systemName: "person.2.fill")
                                                    .caption2Style()
                                                Text("\(memberCount)")
                                                    .caption2Style()
                                                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                                            }
                                            .foregroundStyle(Theme.text.opacity(0.5))
                                        }
                                        if activityCount > 0 {
                                            HStack(spacing: 4) {
                                                Image(systemName: "calendar")
                                                    .caption2Style()
                                                Text("\(activityCount) events")
                                                    .caption2Style()
                                                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                                            }
                                            .foregroundStyle(Theme.text.opacity(0.5))
                                        }
                                        if let cost = place.cost {
                                            HStack(spacing: 4) {
                                                Image(systemName: "sterlingsign.circle")
                                                    .caption2Style()
                                                Text(cost)
                                                    .caption2Style()
                                                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                                            }
                                            .foregroundStyle(Theme.green)
                                        }
                                    }

                                    // Accessibility tags
                                    if !place.accessibility.prefix(3).isEmpty {
                                        HStack(spacing: 4) {
                                            ForEach(Array(place.accessibility.prefix(3)), id: \.self) { tag in
                                                Text(tag)
                                                    .stigmaFont(size: 10, name: "AtkinsonHyperlegible-Bold")
                                                    .foregroundStyle(Theme.text.opacity(0.5))
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 3)
                                                    .background(
                                                        Capsule(style: .continuous)
                                                            .fill(Theme.green.opacity(0.1))
                                                    )
                                            }
                                        }
                                    }
                                }
                                .padding(14)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Theme.cardBackground)
                                    .shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 10)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.bottom, sheetDetent == .collapsed ? 112 : 16)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.95, anchor: .bottom)),
                            removal: .opacity.combined(with: .scale(scale: 0.95, anchor: .bottom))
                        ))
                    }
                }
                
                // MARK: - Bottom Sheet
                bottomSheet
            }
            .navigationDestination(item: $navigateToPlace) { place in
                PlaceDetailView(place: place)
            }
            .preferredColorScheme(.light)
            .tint(Theme.text)
        }
    }
    
    // MARK: - Bottom Sheet
    
    private var bottomSheet: some View {
        VStack(spacing: 0) {
            // Drag handle
            Capsule()
                .fill(Theme.text.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 8)
            
            // Search Bar (always visible)
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Theme.text.opacity(0.5))
                    .stigmaFont(size: 16)

                TextField("Search places...", text: $searchText)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            sheetDetent = .expanded
                        }
                    }
                    .subheadlineStyle()
                    .foregroundStyle(Theme.text)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.text.opacity(0.4))
                    }
                }
                
                // Expand / collapse toggle
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        sheetDetent = sheetDetent == .expanded ? .collapsed : .expanded
                    }
                } label: {
                    Image(systemName: sheetDetent == .expanded ? "chevron.down.circle.fill" : "list.bullet.circle.fill")
                        .titleStyle(size: 20)
                        .foregroundStyle(Theme.accent)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Theme.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Theme.text.opacity(0.08), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
            
            // Expanded content
            if sheetDetent == .expanded {
                VStack(spacing: 0) {
                    // Category chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            categoryChip(nil, label: "All", icon: "map.fill", color: Theme.text)
                            toggleChip(isOn: $showFriendlyOnly, label: "Friendly", icon: "checkmark.seal.fill", color: Theme.accent)
                            toggleChip(isOn: $showEventsOnly, label: "Hubs", icon: "star.fill", color: Theme.green)
                            ForEach(Array(Set(samplePlaces.map(\.category))).sorted(by: { $0.rawValue < $1.rawValue }), id: \.rawValue) { cat in
                                categoryChip(cat, label: cat.rawValue, icon: cat.icon, color: cat.color)
                            }
                        }
                        .padding(.horizontal, 14)
                    }
                    .padding(.bottom, 10)
                    
                    // Place count
                    HStack {
                        Text("Community Places")
                            .titleStyle(size: 17)
                            .foregroundStyle(Theme.text)
                        Spacer()
                        Text("\(filteredPlaces.count) places")
                            .caption2Style(size: 11)
                            .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(Theme.text.opacity(0.4))
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 8)
                    
                    // Place list
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(filteredPlaces.enumerated()), id: \.element.id) { index, place in
                                Button {
                                    HapticFeedback.impact(.soft)
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                        tappedPlace = place
                                        sheetDetent = .collapsed
                                    }
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        position = .region(MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(latitude: place.latitude - 0.005, longitude: place.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                                        ))
                                    }
                                } label: {
                                    placeRow(place)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("\(place.name), \(place.category.rawValue)\(place.isTulipCertified ? ", Tulip certified" : "")\(place.cost.map { ", \($0)" } ?? "")")
                                .accessibilityHint("Focuses map on this place. Tap again to open full details")
                                .opacity(appeared.contains(place.id) ? 1 : 0)
                                .offset(y: appeared.contains(place.id) ? 0 : 8)
                                .onAppear {
                                    withAnimation(.easeOut.delay(Double(index) * 0.06)) {
                                        _ = appeared.insert(place.id)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Theme.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: -4)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .frame(height: sheetDetent == .expanded ? 460 : 90)
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: sheetDetent)
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded { value in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        if value.translation.height < -40 {
                            sheetDetent = .expanded
                            HapticManager.shared.impact(.medium)
                        } else if value.translation.height > 40 {
                            sheetDetent = .collapsed
                            HapticManager.shared.impact(.medium)
                        }
                    }
                }
        )
        .padding(.horizontal, 8)
    }

    // MARK: - Components

    private func categoryChip(_ category: PlaceCategory?, label: String, icon: String, color: Color) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            HapticFeedback.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCategory = category
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .caption2Style(size: 11)
                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                    .accessibilityHidden(true)
                Text(label)
                    .labelStyle()
            }
            .foregroundStyle(isSelected ? .white : Theme.text)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .frame(minHeight: A11ySize.minTouchTarget)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? color : Theme.cardBackground)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(isSelected ? color : Theme.text.opacity(0.1), lineWidth: 1)
            )
        }
        .accessibilityLabel("Filter: \(label)")
        .accessibilityHint(isSelected ? "Currently selected. Tap to show all" : "Show only \(label) places")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    private func toggleChip(isOn: Binding<Bool>, label: String, icon: String, color: Color) -> some View {
        let selected = isOn.wrappedValue
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.wrappedValue.toggle()
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .caption2Style(size: 11)
                    .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                Text(label)
                    .labelStyle()
            }
            .foregroundStyle(selected ? .white : Theme.text)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
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
        HStack(alignment: .center, spacing: 12) {
            // Icon badge
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(place.hostsEvents ? place.category.color : place.category.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: place.category.icon)
                    .foregroundStyle(place.hostsEvents ? .white : place.category.color)
                    .stigmaFont(size: 16, name: "AtkinsonHyperlegible-Bold")
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(place.name)
                    .subheadlineStyle(size: 14)
                    .stigmaFont(size: 14, name: "AtkinsonHyperlegible-Bold")
                    .foregroundStyle(Theme.text)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Text(place.hostsEvents ? "Hub" : "Friendly")
                        .caption2Style(size: 11)
                        .stigmaFont(size: 11, name: "AtkinsonHyperlegible-Bold")
                        .foregroundStyle(place.hostsEvents ? Theme.accent : Theme.green)

                    if place.communityVerified {
                        Image(systemName: "checkmark.circle.fill")
                            .stigmaFont(size: 9, name: "AtkinsonHyperlegible-Bold")
                            .foregroundStyle(Theme.green)
                    }

                    Text("· \(place.category.rawValue)")
                        .caption2Style(size: 11)
                        .foregroundStyle(Theme.text.opacity(0.5))
                }
            }

            Spacer()

            Image(systemName: "location.circle.fill")
                .stigmaFont(size: 18, name: "AtkinsonHyperlegible-Regular")
                .foregroundStyle(Theme.accent.opacity(0.5))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.cardBackground)
                .shadow(color: Theme.text.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }

    // MARK: - Helpers

    private func configure() {
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
