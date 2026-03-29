//
//  HomeView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header

                    TulipCard(title: "Explore nearby", accent: Theme.tulipCyan) {
                        Text("Clubs, recreational activities, support groups")
                    }

                    TulipCard(title: "Community updates", accent: Theme.tulipPink) {
                        Text("News, research, events")
                    }

                    TulipCard(title: "Calendar", accent: Theme.tulipOrange) {
                        Text("Upcoming events and activities")
                    }

                    TulipCard(title: "Search", accent: Theme.tulipPurple) {
                        Text("Find events, groups, clubs")
                    }

                    TulipCard(title: "My groups", accent: Theme.tulipGreen) {
                        Text("Your clubs and communities")
                    }
                }
                .padding(16)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Stigma")
            .toolbarBackground(Theme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .preferredColorScheme(.light)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome")
                    .font(.title2).bold()
                    .foregroundStyle(Theme.text)
                Text("How can we help today?")
                    .foregroundStyle(Theme.text.opacity(0.8))
            }
            Spacer()
            // Placeholder tulip icon (replace with SVG later)
            Image(systemName: "leaf.fill")
                .foregroundStyle(Theme.tulipGreen)
                .padding(10)
                .background(Theme.cardBackground(for: Theme.tulipGreen))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

#Preview {
    HomeView()
}
