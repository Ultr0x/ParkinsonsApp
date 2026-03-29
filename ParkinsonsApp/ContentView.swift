//
//  ContentView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI
import MapKit

struct ContentView: View {
    init() {
        // Frosted/tab appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        appearance.backgroundColor = UIColor(Theme.background).withAlphaComponent(0.25)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Theme.text)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Theme.text)]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.text).withAlphaComponent(0.55)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Theme.text).withAlphaComponent(0.55)]
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = UIColor(Theme.text)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Theme.text).withAlphaComponent(0.55)

        let nav = UINavigationBarAppearance()
        nav.configureWithTransparentBackground()
        nav.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        nav.backgroundColor = UIColor(Theme.background).withAlphaComponent(0.2)
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            MapScreen()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
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
    }
}

#Preview {
    ContentView()
}
