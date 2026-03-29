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
    @State private var venues: [TulipVenue] = sampleVenues

    @State private var searchText: String = ""
    @State private var isSheetExpanded: Bool = false
    @GestureState private var sheetTranslation: CGFloat = 0
    @State private var currentRegion: MKCoordinateRegion? = nil

    private let collapsedSheetHeight: CGFloat = 100
    private let expandedSheetHeight: CGFloat = 480

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position, selection: .constant(nil)) {
                ForEach(venues) { venue in
                    let coordinate = CLLocationCoordinate2D(latitude: venue.latitude, longitude: venue.longitude)
                    Annotation(venue.name, coordinate: coordinate) {
                        ZStack {
                            Circle()
                                .fill(venue.isCertified ? Theme.accent : Theme.text)
                                .frame(width: 28, height: 28)
                            
                            if venue.isCertified {
                                Image(systemName: "asterisk")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white)
                            } else {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .onAppear(perform: configure)
            .ignoresSafeArea()

            // Bottom sheet with integrated search and places list
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 12) {
                    // Drag handle
                    Capsule()
                        .fill(Theme.text.opacity(0.3))
                        .frame(width: 36, height: 4)
                        .padding(.top, 8)
                        .padding(.bottom, 4)

                    // Integrated Apple Maps-style Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Theme.text.opacity(0.7))
                            .font(.system(size: 20))
                        
                        TextField("Search Stigma spaces...", text: $searchText)
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                            .onSubmit(performSearch)
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
                        
                        // Profile picture placeholder
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
                        // Filter Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                PillBadge(text: "All", tint: Theme.text)
                                PillBadge(text: "Café", tint: Theme.green)
                                PillBadge(text: "Gym", tint: Theme.cyan)
                                PillBadge(text: "Park", tint: Theme.orange)
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 8)

                        // Section Header
                        HStack {
                            Text("Tulip Venues")
                                .font(.headline.weight(.heavy))
                                .fontDesign(.rounded)
                                .foregroundStyle(Theme.text)
                            Spacer()
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
                            ForEach(venues) { venue in
                                Button {
                                    focus(on: venue)
                                } label: {
                                    HStack(alignment: .top, spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(venue.isCertified ? Theme.accent.opacity(0.2) : Theme.text.opacity(0.1))
                                                .frame(width: 40, height: 40)
                                            if venue.isCertified {
                                                Image(systemName: "asterisk")
                                                    .foregroundStyle(Theme.accent)
                                                    .font(.headline)
                                            } else {
                                                Image(systemName: "mappin")
                                                    .foregroundStyle(Theme.text.opacity(0.6))
                                            }
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(venue.name)
                                                    .font(.subheadline.weight(.bold))
                                                    .foregroundStyle(Theme.text)
                                                
                                                Text(String(format: "%.1f ★", venue.rating))
                                                    .font(.caption2.weight(.bold))
                                                    .foregroundStyle(Theme.orange)
                                            }
                                            
                                            HStack {
                                                Text(venue.type.rawValue)
                                                    .font(.caption2.weight(.bold))
                                                    .foregroundStyle(typeColor(for: venue.type))
                                                Text("· 0.3 mi away")
                                                    .font(.caption)
                                                    .foregroundStyle(Theme.text.opacity(0.6))
                                            }
                                            
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 4) {
                                                    ForEach(venue.accessibility, id: \.self) { tag in
                                                        Text(tag)
                                                            .font(.caption2.weight(.medium))
                                                            .padding(.horizontal, 6)
                                                            .padding(.vertical, 2)
                                                            .background(Theme.pill(tint: Theme.text.opacity(0.5)))
                                                            .foregroundStyle(Theme.text.opacity(0.8))
                                                    }
                                                }
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.footnote.weight(.semibold))
                                            .foregroundStyle(Theme.text.opacity(0.3))
                                    }
                                    .padding(16)
                                    .background(Theme.glassBackground)
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
                .padding(.bottom, .zero) // Anchor edge properly
            }
        }
        .preferredColorScheme(.light)
        .tint(Theme.text)
    }

    private func configure() {
        let coord = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
        position = .region(MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        currentRegion = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }

    private func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else {
            venues = sampleVenues
            return
        }
        
        venues = sampleVenues.filter { $0.name.lowercased().contains(query) || $0.type.rawValue.lowercased().contains(query) }
        isSheetExpanded = true
    }

    private func focus(on venue: TulipVenue) {
        let coordinate = CLLocationCoordinate2D(latitude: venue.latitude, longitude: venue.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        withAnimation {
            position = .region(region)
        }
    }
    
    private func typeColor(for type: VenueType) -> Color {
        switch type {
        case .cafe: return Theme.green
        case .gym: return Theme.cyan
        case .park: return Theme.orange
        case .cultural: return Theme.accent
        }
    }
}

#Preview {
    MapScreen()
}
