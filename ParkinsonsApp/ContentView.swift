//
//  ContentView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var activeDiscovery: DiscoveryType? = nil
    @State private var navigateToFolk: CommunityFolk? = nil
    @State private var navigateToPlace: CommunityPlace? = nil
    
    init() {
        // Atkinson Hyperlegible font for UIKit chrome
        let atkinsonBold = UIFont(name: "AtkinsonHyperlegible-Bold", size: 10)
        let atkinsonRegular = UIFont(name: "AtkinsonHyperlegible-Regular", size: 10)

        // Frosted/tab appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        appearance.backgroundColor = UIColor(Theme.background).withAlphaComponent(0.25)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Theme.text)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.text),
            .font: atkinsonBold ?? .systemFont(ofSize: 10, weight: .bold)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.text).withAlphaComponent(0.55)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.text).withAlphaComponent(0.55),
            .font: atkinsonRegular ?? .systemFont(ofSize: 10)
        ]
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = UIColor(Theme.text)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Theme.text).withAlphaComponent(0.55)

        // Navigation bar with Atkinson Hyperlegible
        let nav = UINavigationBarAppearance()
        nav.configureWithTransparentBackground()
        nav.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        nav.backgroundColor = UIColor(Theme.background).withAlphaComponent(0.2)
        nav.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.text),
            .font: UIFont(name: "AtkinsonHyperlegible-Bold", size: 17) ?? .boldSystemFont(ofSize: 17)
        ]
        nav.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Theme.text),
            .font: UIFont(name: "AtkinsonHyperlegible-Bold", size: 34) ?? .boldSystemFont(ofSize: 34)
        ]
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
    }

    var body: some View {
        ZStack {
            TabView {
                HomeView(onVenueDiscovery: triggerVenueDiscovery)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                MapScreen()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }

                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }

                FolksListView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Community")
                    }

                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            }
            .tint(Theme.text)
            .background(Theme.background.ignoresSafeArea())
            .preferredColorScheme(.light)
            
            // Shake detector for person discovery
            ShakeDetector {
                if activeDiscovery == nil {
                    triggerPersonDiscovery()
                }
            }
            .frame(width: 0, height: 0)

            // Fullscreen discovery overlay
            if let discovery = activeDiscovery {
                ProximityDiscoveryOverlay(
                    discovery: discovery,
                    onDismiss: {
                        activeDiscovery = nil
                    },
                    onOpen: {
                        switch discovery {
                        case .person(let folk):
                            navigateToFolk = folk
                        case .venue(let place):
                            navigateToPlace = place
                        }
                        activeDiscovery = nil
                    }
                )
                .transition(.opacity)
                .zIndex(100)
            }
        }
        .sheet(item: $navigateToFolk) { folk in
            NavigationStack {
                FolkDetailView(folk: folk, fromDiscovery: true)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Dismiss") { navigateToFolk = nil }
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        }
                    }
            }
        }
        .sheet(item: $navigateToPlace) { place in
            NavigationStack {
                PlaceDetailView(place: place, fromDiscovery: true)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Dismiss") { navigateToPlace = nil }
                                .subheadlineStyle(size: 15)
                                .stigmaFont(size: 15, name: "AtkinsonHyperlegible-Bold")
                        }
                    }
            }
        }
    }
    
    // MARK: - Discovery Triggers
    
    private func triggerPersonDiscovery() {
        guard let folk = sampleFolk.randomElement() else { return }
        withAnimation(.easeIn(duration: 0.3)) {
            activeDiscovery = .person(folk)
        }
        HapticManager.shared.proximityPulse()
    }
    
    private func triggerVenueDiscovery() {
        let hubs = samplePlaces.filter { $0.hostsEvents }
        guard let place = hubs.randomElement() else { return }
        withAnimation(.easeIn(duration: 0.3)) {
            activeDiscovery = .venue(place)
        }
        HapticManager.shared.impact(.medium)
    }
}

#Preview {
    ContentView()
}
