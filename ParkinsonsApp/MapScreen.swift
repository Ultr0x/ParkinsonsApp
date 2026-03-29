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
    @State private var mapItems: [MKMapItem] = []

    var body: some View {
        NavigationStack {
            Map(position: $position, selection: .constant(nil)) {
                ForEach(mapItems, id: \.self) { item in
                    if let coordinate = item.placemark.location?.coordinate {
                        Annotation(item.name ?? "Place", coordinate: coordinate) {
                            ZStack {
                                Circle()
                                    .fill(Theme.tulipPurple)
                                    .frame(width: 24, height: 24)
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .onAppear(perform: configure)
            .navigationTitle("Map")
            .toolbarBackground(Theme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .background(Theme.background.ignoresSafeArea())
        .preferredColorScheme(.light)
        .tint(Theme.text)
    }

    private func configure() {
        // Center on a sensible default (e.g., a city center). You can swap to user location later.
        let coord = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278) // London placeholder
        position = .region(MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))

        // Example map items (replace with real clubs/groups)
        let example1 = MKMapItem(placemark: MKPlacemark(coordinate: coord))
        example1.name = "Walking Club"
        let example2 = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 51.52, longitude: -0.1)))
        example2.name = "Support Group"
        mapItems = [example1, example2]
    }
}

#Preview {
    MapScreen()
}
